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
  $display("===============================TIER CHECK===============================");
  $display("=====================================================================\n");
  
  $display("\n******************** TIER ********************");
  $display("***** Reset value check *****");
  test_bench.verify(ADDR_TIER  ,    32'h0000_0000);


  $display("***** R/W access *****");
  test_bench.write(ADDR_TIER   ,    32'h0000_0000, 4'hF);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0000);
  test_bench.write(ADDR_TIER   ,    32'h5555_5555, 4'hF);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);
  test_bench.write(ADDR_TIER   ,    32'h5445_4554, 4'hF);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0000);
  test_bench.write(ADDR_TIER   ,    32'h5445_4554, 4'h0);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0000);


  $display("***** Reserved bit access *****");
  test_bench.write(ADDR_TIER   ,    32'hFFFF_FFFF, 4'hF);
  test_bench.verify(ADDR_TIER  ,    32'h0000_0001);


  $display("\n=================================END=================================\n");


end
endtask
