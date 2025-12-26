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
  $display("===============================APB CHECK===============================");
  $display("=====================================================================\n");


  $display("\t\n================NORMAL APB================");
  test_bench.write(ADDR_TDR0   ,    32'h5555_5555, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'h5555_5555); 
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\t\n================WRONG APB================");
  $display("==================WRITE==================");

  $display("\n***** psel is not assert, only penable => error write*****");
  //test_bench.err_psel = 1'b1;
  force test_bench.tim_psel = 0;
  test_bench.write(ADDR_TDR0   ,    32'h1234_5678, 4'hF);
  //test_bench.err_psel = 1'b0;
  release test_bench.tim_psel;
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000); 
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** penable is not assert, only psel => error write *****");
  //test_bench.err_penable = 1'b1;
  force test_bench.tim_penable = 0;
  test_bench.write(ADDR_TDR0   ,    32'h1234_5678, 4'hF);
  //test_bench.err_penable = 1'b0;
  release test_bench.tim_penable;
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000); 
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("==================READ==================");

  $display("\n***** psel is not assert, only penable => error read*****");
  //test_bench.err_psel = 1'b1;
  force test_bench.tim_psel = 0;
  test_bench.read(ADDR_TDR0   ,    tmp);
  //test_bench.err_psel = 1'b0;
  release test_bench.tim_psel;
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000); 
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("\n***** penable is not assert, only psel => error read *****");
  //test_bench.err_penable = 1'b1;
  force test_bench.tim_penable = 0;
  test_bench.read(ADDR_TDR0   ,    tmp);
  //test_bench.err_penable = 1'b0;
  release test_bench.tim_penable;
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000); 
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

 // test_bench.read(ADDR_TDR0   ,    tmp);
 // test_bench.verify(ADDR_TDR0  ,    32'h5555_5555); 

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\t\n================MULTIPLE ACCESS================");
  $display("\n***** WW-RR *****");

  //set up
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_paddr = ADDR_TDR0;
  test_bench.tim_pwrite = 1;
  test_bench.tim_psel = 1;
  test_bench.tim_pwdata = 32'h5555_5555;
  test_bench.tim_pstrb = 4'b1111;

  //access 
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_penable = 1;
  wait(test_bench.tim_pready === 1);
  //set up
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_penable = 0;
  test_bench.tim_paddr = ADDR_TDR1;
  test_bench.tim_pwdata = 32'h6666_6666;
  //access
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_penable = 1;
  wait(test_bench.tim_pready === 1);
  @(posedge test_bench.sys_clk);
  //end
  #1;
  test_bench.tim_paddr = 0;
  test_bench.tim_pwrite = 0;
  test_bench.tim_psel = 0;
  test_bench.tim_pwdata = 0;
  test_bench.tim_penable = 0;
  

  //Read
  //set up
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_paddr = ADDR_TDR0;
  test_bench.tim_pwrite = 0;
  test_bench.tim_psel = 1;

  //access 
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_penable = 1;
  wait(test_bench.tim_pready === 1);
  #1;
  test_bench.verify(ADDR_TDR0, 32'h5555_5555);
  //set up
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_psel = 1;
  test_bench.tim_penable = 0;
  test_bench.tim_paddr = ADDR_TDR1;
  //access
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.tim_penable = 1;
  wait(test_bench.tim_pready === 1);
  #1;
  test_bench.verify(ADDR_TDR1, 32'h6666_6666);
  @(posedge test_bench.sys_clk);
  //end
  #1;
  test_bench.tim_paddr = 0;
  test_bench.tim_pwrite = 0;
  test_bench.tim_psel = 0;
  test_bench.tim_pwdata = 0;
  test_bench.tim_penable = 0;
  



  







  $display("\n=================================END=================================\n");


end
endtask
