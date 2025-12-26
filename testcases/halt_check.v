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
reg [63:0] cnt_tmp;
reg [63:0] cnt;
begin
  #100;
  $display("\n=====================================================================");
  $display("============================HALT CHECK============================");
  $display("=====================================================================\n");
  
  $display("\t\n***************Check value of halt_ack****************");
  $display("\t\n***************When dbg_mode=0 and halt_req=1****************");
  test_bench.write(ADDR_THCSR    ,    32'h1, 4'hF);
  test_bench.verify(ADDR_THCSR   ,    32'h1);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n***************When dbg_mode=1 and halt_req=1****************");
  test_bench.write(ADDR_THCSR    ,    32'h1, 4'hF);
  test_bench.verify(ADDR_THCSR   ,    32'h1);
  test_bench.dbg_mode = 1'b1;
  repeat (5) @(posedge test_bench.sys_clk);
  test_bench.verify(ADDR_THCSR   ,    32'h3);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n***************When dbg_mode=1 and halt_req=0****************");
  test_bench.write(ADDR_THCSR    ,    32'h0, 4'hF);
  test_bench.dbg_mode = 1'b1;
  repeat (5) @(posedge test_bench.sys_clk);
  test_bench.verify(ADDR_THCSR   ,    32'h0);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\t\n***************Check counter halted and resumed****************");
  test_bench.dbg_mode = 1'b1;
  test_bench.write(ADDR_TCR     ,    32'h0000_0203, 4'hF);
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0, tmp);
  test_bench.read(ADDR_TDR1, tmp);
  test_bench.write(ADDR_THCSR    ,    32'h1, 4'hF);
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0, cnt_tmp[31:0]);
  test_bench.read(ADDR_TDR1, cnt_tmp[63:32]);
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0, cnt[31:0]);
  test_bench.read(ADDR_TDR1, cnt[63:32]);
  if (cnt === cnt_tmp)
    $display("PASS. Counter increments normally when timer_en & dbg_mode is HIGH; and STOP when both dbg_mode & halt_req are asserted");
  else
    $display("FAIL");


  $display("Deassert halt_req");
  test_bench.write(ADDR_THCSR    ,    32'h0, 4'hF);

  $display("Continue counting");
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0, cnt[31:0]);
  test_bench.read(ADDR_TDR1, cnt[63:32]);
  if (cnt !== cnt_tmp)
    $display("PASS. Counter is counting normally when halt_req is deasserted");
  else
    $display("FAIL. Counter did not resume");








  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  test_bench.dbg_mode = 1'b1;
  test_bench.write(ADDR_TCR     ,    32'h0000_0001, 4'hF);
  repeat (100) @(posedge test_bench.sys_clk);
  test_bench.write(ADDR_THCSR    ,    32'h1, 4'hF);
  repeat (100) @(posedge test_bench.sys_clk);


  $display("\n=================================END=================================\n");


end
endtask
