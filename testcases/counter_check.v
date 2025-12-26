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
reg [63:0] cnt;
begin
  #100;
  $display("\n=====================================================================");
  $display("=============================COUNTER CHECK=============================");
  $display("=====================================================================\n");
  
  $display("\t\n================COUNTING BEHAVIOR CHECK================\n");
  
  $display("\n***** Check counting at boundary of TDR0 *****");
  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FF00, 4'hF);
  test_bench.write(ADDR_TDR1   ,    32'h0000_0000, 4'hF);
  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);
  repeat (252) @(posedge test_bench.sys_clk);
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0001);
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  $display("\n***** Check counting at boundary of TDR1 *****");
  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FF00, 4'hF);
  test_bench.write(ADDR_TDR1   ,    32'hFFFF_FFFF, 4'hF);

  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);
  repeat (252) @(posedge test_bench.sys_clk);

  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0000);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  $display("\t\n================UPDATE TDR0/1 WHEN TIMER IS WORKING================\n");
  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);
  repeat (252) @(posedge test_bench.sys_clk);
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0100);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0000);

  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FF00, 4'hF);
  test_bench.write(ADDR_TDR1   ,    32'h0000_0000, 4'hF);

  repeat (251) @(posedge test_bench.sys_clk);

  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0001);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  

  $display("\t\n================TIMER IS DISABLED AND RESUMED================\n");
  $display("\n***** When timer changed from 1 to 0, counter does not count *****");


  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);
  repeat (252) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  test_bench.read(ADDR_TDR1    ,    tmp);
  $display("timer_en is deasserted");
  test_bench.write(ADDR_TCR    ,    32'h0000_0000, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0000);

  $display("\n***** After timer_en changed from 0 to 1, div_en=1, div_val=3, counter works normally*****");
  $display("timer_en is asserted");
  test_bench.write(ADDR_TCR    ,    32'h0000_0303, 4'hF);
  repeat (252) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  read(ADDR_TDR1    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\t\n================COUNTER CONTINUE COUNTING================\n");
  $display("\n***** When interrupt occurs *****");


  test_bench.write(ADDR_TCMP0    ,    32'h0000_00FF, 4'hF);
  test_bench.write(ADDR_TCMP1    ,    32'h0000_0000, 4'hF);
  test_bench.write(ADDR_TIER     ,    32'h0000_0001, 4'hF);
  test_bench.write(ADDR_TCR      ,    32'h0000_0001, 4'hF);

  repeat (252) @(posedge test_bench.sys_clk);
  $display("Interrupt");
  wait (test_bench.tim_int === 1);
  $display("Read again");
  test_bench.read(ADDR_TDR0    ,    tmp);
  test_bench.read(ADDR_TDR1    ,    tmp);
 
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** When overflow*****");
  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FF00, 4'hF);
  test_bench.write(ADDR_TDR1   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);

  $display("Overflow");
  repeat (252) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  test_bench.read(ADDR_TDR1    ,    tmp);
  $display("Read again");
  test_bench.read(ADDR_TDR0    ,    tmp);
  test_bench.read(ADDR_TDR1    ,    tmp);


 




  $display("\n=================================END=================================\n");


end
endtask
