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
  $display("============================ONE HOT CHECK============================");
  $display("=====================================================================\n");
  test_bench.write(ADDR_TCR   ,    32'h1010_1010, 4'hF);
  test_bench.write(ADDR_TDR0  ,    32'h1111_1111, 4'hF);
  test_bench.write(ADDR_TDR1  ,    32'h2222_2222, 4'hF);
  test_bench.write(ADDR_TCMP0 ,    32'h3333_3333, 4'hF);
  test_bench.write(ADDR_TCMP1 ,    32'h4444_4444, 4'hF);
  test_bench.write(ADDR_TIER  ,    32'h5555_5555, 4'hF);
  test_bench.write(ADDR_TISR  ,    32'h6666_6666, 4'hF);
  test_bench.write(ADDR_THCSR ,    32'h7777_7777, 4'hF);

  test_bench.verify(ADDR_TCR  ,   32'h0000_0000);
  test_bench.verify(ADDR_TDR0 ,   32'h1111_1111);
  test_bench.verify(ADDR_TDR1 ,   32'h2222_2222);
  test_bench.verify(ADDR_TCMP0,   32'h3333_3333);
  test_bench.verify(ADDR_TCMP1,   32'h4444_4444);
  test_bench.verify(ADDR_TIER ,   32'h0000_0001);
  test_bench.verify(ADDR_TISR ,   32'h0000_0000);
  test_bench.verify(ADDR_THCSR,   32'h0000_0001);

  $display("\n=================================END=================================\n");


end
endtask
