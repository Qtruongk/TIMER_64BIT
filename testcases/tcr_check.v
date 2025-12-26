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
  $display("===============================TCR CHECK===============================");
  $display("=====================================================================\n");
  
  $display("***** Reset value check *****");
  test_bench.verify(ADDR_TCR  ,    32'h0000_0100);


  $display("***** R/W access *****");
  test_bench.write(ADDR_TCR   ,    32'h0000_0000, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0000);
  test_bench.write(ADDR_TCR   ,    32'hFFFF_F6F0, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0600);
  test_bench.write(ADDR_TCR   ,    32'h5555_5555, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0501);
  test_bench.write(ADDR_TCR   ,    32'h5445_4554, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0500);

  $display("***** Reserved bit access *****");
  test_bench.write(ADDR_TCR   ,    32'hFFFF_F6FF, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0603);

  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;
  

  $display("***** Write a prohibited value to div_val *****");
  test_bench.write(ADDR_TCR   ,    32'h5555_5955, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0100);
  test_bench.write(ADDR_TCR   ,    32'h5555_5a55, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0100);
  test_bench.write(ADDR_TCR   ,    32'h5555_5655, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0601);
  test_bench.write(ADDR_TCR   ,    32'h5555_5255, 4'b1101);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0601);
  test_bench.write(ADDR_TCR   ,    32'h5555_5855, 4'b0000);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0601);
  test_bench.write(ADDR_TCR   ,    32'h5555_5355, 4'b0000);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0601);
  test_bench.write(ADDR_TCR   ,    32'h5555_5650, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0600);
  test_bench.write(ADDR_TCR   ,    32'h5555_5e50, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0600);
  test_bench.sys_rst_n = 1'b0;
  #10;
  @(posedge test_bench.sys_clk);
  #1;
  test_bench.sys_rst_n = 1'b1;

  $display("***** div_val, div_en is prohibited to change when timer_en is High *****");
  test_bench.write(ADDR_TCR   ,    32'h5555_5553, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0503);
  test_bench.write(ADDR_TCR   ,    32'h5555_5653, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0503);
  test_bench.write(ADDR_TCR   ,    32'h5555_5a51, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0503);
  test_bench.write(ADDR_TCR   ,    32'h5555_5251, 4'hF);
  test_bench.verify(ADDR_TCR  ,    32'h0000_0503);





  $display("\n=================================END=================================\n");


end
endtask
