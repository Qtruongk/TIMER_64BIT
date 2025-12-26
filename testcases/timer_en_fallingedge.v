task run_test;
parameter ADDR_TCR    = 12'h00;
parameter ADDR_TDR0   = 12'h04;
parameter ADDR_TDR1   = 12'h08;
parameter ADDR_TCMP0  = 12'h0C;
parameter ADDR_TCMP1  = 12'h10;
parameter ADDR_TIER   = 12'h14;
parameter ADDR_TISR   = 12'h18;
parameter ADDR_THCSR  = 12'h1C;
reg [31:0] tmp;
begin
  #100;
  $display("\n=====================================================================");
  $display("======================Timer_en FALLING EDGE CHECK======================");
  $display("=====================================================================\n");
  

  test_bench.write(ADDR_TDR0    ,    32'h0022_0022, 4'hF);
  test_bench.write(ADDR_TDR1    ,    32'h00AA_00AA, 4'hF);
  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  test_bench.read(ADDR_TDR1    ,    tmp);
  test_bench.write(ADDR_TCR    ,    32'h0000_0000, 4'hF);
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.verify(ADDR_TDR0  ,    32'h0);
  test_bench.verify(ADDR_TDR1  ,    32'h0);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  test_bench.write(ADDR_TDR0    ,    32'h0022_0022, 4'hF);
  test_bench.write(ADDR_TDR1    ,    32'h00AA_00AA, 4'hF);
  test_bench.write(ADDR_TCR    ,    32'h0000_0303, 4'hF);
  repeat (13) @(posedge test_bench.sys_clk);
  test_bench.write(ADDR_TCR    ,    32'h0000_0302, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'h0);
  test_bench.verify(ADDR_TDR1  ,    32'h0);




  $display("\n=================================END=================================\n");


end
endtask
