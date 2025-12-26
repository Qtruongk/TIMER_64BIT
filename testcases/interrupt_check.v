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
  $display("============================INTERRUPT CHECK============================");
  $display("=====================================================================\n");
  
  $display("\t\n***************INTERRUPT PENDING****************");
  $display("\t\n===============SET CONDITION================");
  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 0)
    $display("PASS. TISR.int_st = 1. Interrupt output is not asserted");
  else
    $display("FAIL");
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\t\n===============CLEAR CONDITION================");
  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);

  $display("TISR.int_st = 1");
  $display("Write 0 to TISR.int_st");
  test_bench.write(ADDR_TISR     ,    32'h0, 4'hF);
  test_bench.read(ADDR_TISR, tmp);

  if (tmp === 32'h1)
    $display("PASS. TISR.int_st remains 1");
  else
    $display("FAIL");
  $display("Write 1 to TISR.int_st");
  test_bench.write(ADDR_TISR     ,    32'h1, 4'hF);
  test_bench.read(ADDR_TISR, tmp);

  if (tmp === 32'h0)
    $display("PASS. TISR.int_st is cleared to 0");
  else
    $display("FAIL");
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n===============MANUAL CONDITION================");
  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.write(ADDR_TDR1   ,    32'hFFFF_FFFF, 4'hF);

  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 0)
    $display("PASS. TISR.int_st = 1. Interrupt output is not asserted");
  else
    $display("FAIL");
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n***************INTERRUPT ENABLE****************");

  $display("\t\n===============SET CONDITION================");
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
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\t\n===============CLEAR CONDITION================");
  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TIER    ,    32'h1, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);
  $display("tim_int = %h", test_bench.tim_int);

  $display("TISR.int_st = 1. tim_int = 1");
  $display("Write 0 to TISR.int_st");
  test_bench.write(ADDR_TISR     ,    32'h0, 4'hF);
  test_bench.read(ADDR_TISR, tmp);

  if (tmp === 32'h1)
    $display("PASS. TISR.int_st remains 1");
  else
    $display("FAIL");
  $display("Write 1 to TISR.int_st");
  test_bench.write(ADDR_TISR     ,    32'h1, 4'hF);
  test_bench.read(ADDR_TISR, tmp);

  if (tmp === 32'h0)
    $display("PASS. TISR.int_st is cleared to 0");
  else
    $display("FAIL");
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n===============MANUAL CONDITION================");
  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.write(ADDR_TDR1   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.write(ADDR_TIER    ,    32'h1, 4'hF);

  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 1)
    $display("PASS. TISR.int_st = 1. tim_int = 1. Interrupt output is asserted");
  else
    $display("FAIL");
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;



  $display("\t\n===============MASK CONDITION================");
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


  $display("Set TIER.int_en = 0");
  test_bench.write(ADDR_TIER    ,    32'h0, 4'hF);
  $display("Check interrupt output tim_int");
  $display("tim_int = %h", test_bench.tim_int);

  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 0)
    $display("PASS. TISR.int_st = 1. tim_int = 0. Interrupt output is negated");
  else
    $display("FAIL");

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n===============ONCE ASSERTED, INTERRUPT MUST BE KEPT================");
  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TIER    ,    32'h1, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 1)
    $display("TISR.int_st = 1. tim_int = 1. Interrupt output is asserted");
  else
    $display("FAIL");


  $display("Wait 256 cycle. Read TISR.int_st and tim_int again");
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);
  if (tmp === 32'h1 && test_bench.tim_int === 1)
    $display("TISR.int_st = 1. tim_int = 1. Interrupt keeps HIGH, TISR.int_st keeps 1");
  else
    $display("FAIL");

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;



  test_bench.write(ADDR_TCMP0   ,    32'hFF, 4'hF);
  test_bench.write(ADDR_TCMP1   ,    32'h0, 4'hF);
  test_bench.write(ADDR_TCR     ,    32'h1, 4'hF);
  
  repeat (254) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TISR, tmp);

  $display("TISR.int_st = 1");
  $display("Write 0 to TISR.int_st");

  $display("Write 1 to TISR.int_st");
  test_bench.write(ADDR_TISR     ,    32'h1, 4'h0);
  test_bench.read(ADDR_TISR, tmp);




  $display("\n=================================END=================================\n");


end
endtask
