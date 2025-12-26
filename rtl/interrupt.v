module interrupt
(
  input wire sys_clk,
  input wire sys_rst_n,
  input wire tisr_wr_sel,
  input wire [31:0] wdata,
  input wire [3:0] pstrb,
  input wire [63:0] cnt,
  input wire [63:0] tcmp,
  input wire int_en,
  output reg int_st,

  output wire tim_int

);

//internal signals
wire int_set;
wire int_clr;

assign int_set = (cnt == tcmp);
assign int_clr = (int_st == 1) && tisr_wr_sel && (wdata[0] == 1'b1) && pstrb[0];//bo sung



//int_st
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    int_st <= 0;
  end
  else begin
    if (int_clr)
      int_st <= 1'b0;
    else begin
      if (int_set)
        int_st <= 1'b1;
      else
        int_st <= int_st;
    end
  end
end

assign tim_int = int_en && int_st;

endmodule
