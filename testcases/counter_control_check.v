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
  $display("=========================COUNTER CONTROL CHECK=========================");
  $display("=====================================================================\n");
  
  $display("\t\n================DEFAULT MODE================\n");
  
  $display("\n***** div_en = 0 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0001, 4'hF);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
   $display("\t\n================CONTROL MODE================\n");
  
  $display("\n***** div_en = 1, div_val = 0 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0003, 4'hF);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 1 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0103, 4'hF);
  repeat (10) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (10) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (10) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 2 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0203, 4'hF);
  repeat (24) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (24) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (24) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 3 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0303, 4'hF);
  repeat (52) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (52) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (52) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 4 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0403, 4'hF);
  repeat (108) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (108) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (108) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 5 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0503, 4'hF);
  repeat (220) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (220) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (220) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 6 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0603, 4'hF);
  repeat (444) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (444) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (444) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 7 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0703, 4'hF);
  repeat (892) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (892) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (892) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** div_en = 1, div_val = 8 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0803, 4'hF);
  repeat (1788) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (1788) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (1788) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


   $display("\t\n================SET DIV_VAL BUT DOES NOT SET DIV_EN================\n");
  
  $display("\n***** div_en = 0, div_val = 2 *****");
  test_bench.write(ADDR_TCR    ,    32'h0000_0201, 4'hF);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);
  repeat (3) @(posedge test_bench.sys_clk);
  test_bench.read(ADDR_TDR0    ,    tmp);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n=================================END=================================\n");







  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_TCR    ,    32'h0000_0003, 4'hF);
  repeat (17) @(posedge test_bench.sys_clk);
  test_bench.write(ADDR_TCR    ,    32'h0000_0002, 4'hF);
  repeat (17) @(posedge test_bench.sys_clk);

  

   test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1; 
  test_bench.write(ADDR_THCSR  ,    32'h0000_0000, 4'hF);
  test_bench.write(ADDR_TCR    ,    32'h0000_0000, 4'hF);
  repeat (17) @(posedge test_bench.sys_clk);
/*
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  test_bench.write(ADDR_TCR    ,    32'h0000_0303, 4'hF);
  repeat (17) @(posedge test_bench.sys_clk);
  test_bench.write(ADDR_THCSR  ,    32'h0000_0000, 4'hF);
  test_bench.dbg_mode = 0;
  test_bench.write(ADDR_TCR    ,    32'h0000_0302, 4'hF);
  test_bench.write(ADDR_TCR    ,    32'h0000_0300, 4'hF);
  repeat (17) @(posedge test_bench.sys_clk);
*/
end
endtask
