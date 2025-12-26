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
  $display("===============================PSTRB CHECK===============================");
  $display("=====================================================================\n");
  
  $display("\n***** TCR pstrb check *****");
  test_bench.write(ADDR_TCR   ,    32'h3333_3333, 4'b0010);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0300);
  test_bench.write(ADDR_TCR   ,    32'h3333_3333, 4'b0001);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0303);
  test_bench.write(ADDR_TCR   ,    32'h3333_3333, 4'b0100);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0303);
  test_bench.write(ADDR_TCR   ,    32'h3333_3333, 4'b1000);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0303);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_TCR   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0501);
  test_bench.write(ADDR_TCR   ,    32'h7777_7777, 4'b1100);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0501);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1; 
  test_bench.write(ADDR_TCR   ,    32'h5555_5555, 4'b1111);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0501);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1; 


  $display("\n***** TDR0 pstrb check *****");
  test_bench.write(ADDR_TDR0   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_TDR0  ,    32'h0000_00CD);
  test_bench.write(ADDR_TDR0   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_TDR0  ,    32'h0000_ABCD);
  test_bench.write(ADDR_TDR0   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_TDR0  ,    32'h0034_ABCD);
  test_bench.write(ADDR_TDR0   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_TDR0  ,    32'h1234_ABCD);  
  test_bench.write(ADDR_TDR0   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TDR0  ,    32'h1234_5555);
  test_bench.write(ADDR_TDR0   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_TDR0  ,    32'h5555_5555);
  test_bench.write(ADDR_TDR0   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_TDR0  ,    32'h6666_6666);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  $display("\n***** TDR1 pstrb check *****");
  test_bench.write(ADDR_TDR1   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_00CD);
  test_bench.write(ADDR_TDR1   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_ABCD);
  test_bench.write(ADDR_TDR1   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_TDR1  ,    32'h0034_ABCD);
  test_bench.write(ADDR_TDR1   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_TDR1  ,    32'h1234_ABCD);  
  test_bench.write(ADDR_TDR1   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TDR1  ,    32'h1234_5555);
  test_bench.write(ADDR_TDR1   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_TDR1  ,    32'h5555_5555);
  test_bench.write(ADDR_TDR1   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_TDR1  ,    32'h6666_6666);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  $display("\n***** TCMP0 pstrb check *****");
  test_bench.write(ADDR_TCMP0   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_TCMP0  ,    32'hFFFF_FFCD);
  test_bench.write(ADDR_TCMP0   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_TCMP0  ,    32'hFFFF_ABCD);
  test_bench.write(ADDR_TCMP0   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_TCMP0  ,    32'hFF34_ABCD);
  test_bench.write(ADDR_TCMP0   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_TCMP0  ,    32'h1234_ABCD);  
  test_bench.write(ADDR_TCMP0   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TCMP0  ,    32'h1234_5555);
  test_bench.write(ADDR_TCMP0   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_TCMP0  ,    32'h5555_5555);
  test_bench.write(ADDR_TCMP0   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_TCMP0  ,    32'h6666_6666);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  $display("\n***** TCMP1 pstrb check *****");
  test_bench.write(ADDR_TCMP1   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_TCMP1  ,    32'hFFFF_FFCD);
  test_bench.write(ADDR_TCMP1   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_TCMP1  ,    32'hFFFF_ABCD);
  test_bench.write(ADDR_TCMP1   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_TCMP1  ,    32'hFF34_ABCD);
  test_bench.write(ADDR_TCMP1   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_TCMP1  ,    32'h1234_ABCD);  
  test_bench.write(ADDR_TCMP1   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TCMP1  ,    32'h1234_5555);
  test_bench.write(ADDR_TCMP1   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_TCMP1  ,    32'h5555_5555);
  test_bench.write(ADDR_TCMP1   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_TCMP1  ,    32'h6666_6666);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  
  $display("\n***** TIER pstrb check *****");
  test_bench.write(ADDR_TIER   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);
  test_bench.write(ADDR_TIER   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);
  test_bench.write(ADDR_TIER   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);
  test_bench.write(ADDR_TIER   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);  
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_TIER   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);
  test_bench.write(ADDR_TIER   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_TIER   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0000);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\n***** TISR pstrb check *****");
  test_bench.write(ADDR_TISR   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);
  test_bench.write(ADDR_TISR   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);
  test_bench.write(ADDR_TISR   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);
  test_bench.write(ADDR_TISR   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);  
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_TISR   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);
  test_bench.write(ADDR_TISR   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_TISR   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_TISR  ,    32'h0000_0000);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;


  $display("\n***** THCSR pstrb check *****");
  test_bench.write(ADDR_THCSR   ,    32'h1234_ABCD, 4'b0001);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0001);
  test_bench.write(ADDR_THCSR   ,    32'h1234_AB77, 4'b0010);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0001);
  test_bench.write(ADDR_THCSR   ,    32'h1234_ABCD, 4'b0100);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0001);
  test_bench.write(ADDR_THCSR   ,    32'h1277_7777, 4'b1000);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0001);  
  
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_THCSR   ,    32'h5555_5555, 4'b0011);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0001);
  test_bench.write(ADDR_THCSR   ,    32'h5555_5555, 4'b1100);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0001);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  test_bench.write(ADDR_THCSR   ,    32'h6666_6666, 4'b1111);
  test_bench.verify(ADDR_THCSR  ,    32'h0000_0000);


  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;




  $display("\n=================================END=================================\n");


end
endtask
