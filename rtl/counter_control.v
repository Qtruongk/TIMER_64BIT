module counter_control
(
  input wire sys_clk,
  input wire sys_rst_n,
  input wire dbg_mode,
  input wire timer_en,
  input wire div_en,
  input wire halt_req,
  input wire [3:0] div_val,

  output wire cnt_en,
  output wire halt_ack
);

reg [7:0] int_cnt;
reg [7:0] limit;
wire normal_mode;
wire control_mode;
wire mode0;
wire cnt_rst;
wire [7:0] int_cnt_nxt;

always @* begin
  case (div_val)
    // 4'd0: limit = 8'd0;
    4'b0001: limit = 8'd1;
    4'b0010: limit = 8'd3;
    4'b0011: limit = 8'd7;
    4'b0100: limit = 8'd15;
    4'b0101: limit = 8'd31;
    4'b0110: limit = 8'd63;
    4'b0111: limit = 8'd127;
    4'b1000: limit = 8'd255;
    default: limit = 8'd0;
  endcase
end

assign cnt_rst = ~timer_en | ~div_en | (int_cnt == limit);

assign halt_ack = halt_req & dbg_mode;
assign normal_mode = timer_en & ~div_en;
assign mode0 = timer_en & div_en & (div_val == 4'b0000);
assign control_mode = timer_en & div_en & (div_val != 4'b0000);

assign int_cnt_nxt = halt_ack ? int_cnt : (cnt_rst ? 8'h0 : (timer_en ? int_cnt + 1 : int_cnt));
always @(posedge sys_clk or negedge sys_rst_n)
  if (!sys_rst_n)
    int_cnt  <= 1'b0;
  else
    int_cnt <= int_cnt_nxt;

assign cnt_en = (normal_mode || mode0 || (control_mode && (int_cnt == limit))) & ~halt_ack;

endmodule
