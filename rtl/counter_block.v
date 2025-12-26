module counter_block
(
  input wire sys_clk,
  input wire sys_rst_n,
  input wire cnt_en,
  input wire [3:0] pstrb,
  input wire [31:0] wdata,

  input wire tdr_0_wr_sel,
  input wire tdr_1_wr_sel,
  input wire cnt_clr,

  output reg [63:0] cnt
);

always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    cnt[63:0] <= 64'b0;
  end
  else if (cnt_clr) begin
    cnt[63:0] <= 64'b0;
  end

  else if (tdr_0_wr_sel) begin
    cnt[31:24] <= (pstrb[3]) ? wdata[31:24]  : cnt[31:24];
    cnt[23:16] <= (pstrb[2]) ? wdata[23:16]  : cnt[23:16];
    cnt[15:8]  <= (pstrb[1]) ? wdata[15:8]   : cnt[15:8];
    cnt[7:0]   <= (pstrb[0]) ? wdata[7:0]    : cnt[7:0];
  end
  else if (tdr_1_wr_sel) begin
    cnt[63:56] <= (pstrb[3]) ? wdata[31:24]  : cnt[63:56];
    cnt[55:48] <= (pstrb[2]) ? wdata[23:16]  : cnt[55:48];
    cnt[47:40] <= (pstrb[1]) ? wdata[15:8]   : cnt[47:40];
    cnt[39:32] <= (pstrb[0]) ? wdata[7:0]    : cnt[39:32];
  end
  else if (cnt_en)
    cnt <= cnt + 1;
  else 
    cnt <= cnt;
end

endmodule
