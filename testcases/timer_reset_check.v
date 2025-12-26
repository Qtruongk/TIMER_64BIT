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
  $display("============================TIMER RESET CHECK============================");
  $display("=====================================================================\n");
  
  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TIER    ,    32'h1, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 1)
    $display("PASS. TISR.int_st = 1. tim_int = 1. Interrupt output is asserted");
  else
    $display("FAIL");
  
  $display("Assert RESET");
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("When RESET occurs, interrupt is cleared");
  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h0 && test_bench.tim_int === 0)
    $display("PASS. TISR.int_st = 0. tim_int = 0");
  else
    $display("FAIL");


  $display("Check interrupt can be asserted normally after reset. Set interrupt again");
  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TIER    ,    32'h1, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 1)
    $display("PASS. TISR.int_st = 1. tim_int = 1. Interrupt output is asserted again after RESET");
  else
    $display("FAIL");











  $display("\n=================================END=================================\n");


end
endtask
