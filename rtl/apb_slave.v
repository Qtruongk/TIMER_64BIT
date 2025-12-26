module apb_slave(
  //input APB
  input wire sys_clk,
  input wire sys_rst_n,
  input wire tim_pwrite,
  input wire tim_psel,
  input wire tim_penable,

  //output APB
  output wire tim_pready,
  output wire wr_en,
  output wire rd_en
);


reg wait_state;


// wr_en rd_en
assign wr_en = tim_psel & tim_penable & tim_pwrite;
assign rd_en = tim_psel & tim_penable & ~tim_pwrite;

always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    wait_state <= 0;
  end
  else begin
    if (tim_psel & tim_penable) begin
      wait_state <= 1;
    end
    else begin
      wait_state <= 0;
    end
  end
end

assign tim_pready = (tim_psel & tim_penable) ? (wait_state ? 1'b1 : 1'b0) : 1'b0;


endmodule
