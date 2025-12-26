task run_test;
parameter ADDR_TCR    = 12'h00;
parameter ADDR_TDR0   = 12'h04;
parameter ADDR_TDR1   = 12'h08;
parameter ADDR_TCMP0  = 12'h0C;
parameter ADDR_TCMP1  = 12'h10;
parameter ADDR_TIER   = 12'h14;
parameter ADDR_TISR   = 12'h18;
parameter ADDR_THCSR  = 12'h1C;
begin
  #100;
  $display("\n=====================================================================");
  $display("===============================TDR CHECK===============================");
  $display("=====================================================================\n");
  
  $display("\n******************** TDR0 ********************");
  $display("***** Reset value check *****");
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000);


  $display("***** R/W access *****");
  test_bench.write(ADDR_TDR0   ,    32'h0000_0000, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'h0000_0000);
  test_bench.write(ADDR_TDR0   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'hFFFF_FFFF);
  test_bench.write(ADDR_TDR0   ,    32'h5555_5555, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'h5555_5555);
  test_bench.write(ADDR_TDR0   ,    32'h5445_4554, 4'hF);
  test_bench.verify(ADDR_TDR0  ,    32'h5445_4554);

  $display("\n******************** TDR1 ********************");
  $display("***** Reset value check *****");
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0000);


  $display("***** R/W access *****");
  test_bench.write(ADDR_TDR1   ,    32'h0000_0000, 4'hF);
  test_bench.verify(ADDR_TDR1  ,    32'h0000_0000);
  test_bench.write(ADDR_TDR1   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.verify(ADDR_TDR1  ,    32'hFFFF_FFFF);
  test_bench.write(ADDR_TDR1   ,    32'h5555_5555, 4'hF);
  test_bench.verify(ADDR_TDR1  ,    32'h5555_5555);
  test_bench.write(ADDR_TDR1   ,    32'h5445_4554, 4'hF);
  test_bench.verify(ADDR_TDR1  ,    32'h5445_4554);




  $display("\n=================================END=================================\n");


end
endtask
