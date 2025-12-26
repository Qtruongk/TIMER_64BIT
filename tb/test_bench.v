module test_bench;

parameter ADDR_TCR    = 12'h00;
parameter ADDR_TDR0   = 12'h04;
parameter ADDR_TDR1   = 12'h08;
parameter ADDR_TCMP0  = 12'h0C;
parameter ADDR_TCMP1  = 12'h10;
parameter ADDR_TIER   = 12'h14;
parameter ADDR_TISR   = 12'h18;
parameter ADDR_THCSR  = 12'h1C;

reg sys_clk;                     
reg sys_rst_n;
reg tim_pwrite;
reg tim_psel;
reg tim_penable;
reg [11:0] tim_paddr;
reg [31:0] tim_pwdata;
reg [3:0] tim_pstrb;
reg dbg_mode;
wire [31:0] tim_prdata;
wire tim_int;
wire tim_pready;
wire tim_pslverr;

reg failed;

timer_top u_timer_top (.*);



`include "../sim/run_test.v"



//200MHz
initial begin
  sys_clk = 1'b0;
  forever #2.5 sys_clk = ~sys_clk;
end

initial begin
  sys_rst_n = 1'b0;
  #25;
  sys_rst_n = 1'b1;
end

initial begin
  tim_psel = 0;
  tim_penable = 0;
  tim_pwrite = 0;
  tim_paddr = 0;
  tim_pwdata = 0;
  tim_pstrb = 0;
  dbg_mode = 0;

end

initial begin 
  run_test();
  if (failed == 1)
    $display("Test_result FAILED");
  else
    $display("Test_result PASSED");


  #1000;
  $finish;
end

task write (input [11:0] in_addr,
	    input [31:0] in_data,
	    input [3:0]  in_pstrb);
begin
  $display("-------------------------------------------------------------------");
  $display("t= %10d [WRITE] : addr=%x wdata=%x pstrb=4'b%b", $time, in_addr, in_data, in_pstrb);
  //set up phase
  @(posedge sys_clk);
  #1;
  tim_paddr   = in_addr;
  tim_pwdata  = in_data;
  tim_pstrb   = in_pstrb;
  tim_pwrite  = 1;
  tim_psel    = 1;

  tim_penable = 0;
  //access phase
  @(posedge sys_clk);
  #1;

  tim_penable = 1;
  if (tim_psel && tim_penable)
    wait(tim_pready === 1);
  else
    repeat (10) @(posedge sys_clk);

  @(posedge sys_clk);
  #1;
  tim_paddr = 0;
  tim_pwdata = 0;
  tim_pwrite = 0;
  tim_psel = 0;
  tim_penable = 0;

end
endtask



task read  (input  [11:0] in_addr,
	    output [31:0] out_data);
begin
  //set up phase
  @(posedge sys_clk);
  #1;
  tim_penable = 0;
  tim_paddr = in_addr;
  tim_pwrite = 0;
  tim_psel    = 1;

  //access phase
  @(posedge sys_clk);
  #1;
   tim_penable = 1;
  if (tim_psel && tim_penable)
    wait(tim_pready === 1);
  else
    repeat (10) @(posedge sys_clk);
  #1;
  out_data = tim_prdata;
  @(posedge sys_clk);
  #1;
  tim_psel = 0;
  tim_penable = 0;
  tim_pwrite = 0;
  tim_paddr = 0;
  tim_pwdata = 0;
  $display("t= %10d [READ]  : addr=%x rdata=%x", $time, in_addr, out_data);

end
endtask


task verify  (input [11:0] tim_paddr,
	      input [31:0] expected_data);
reg [31:0] read_data;
failed = 0;
begin
  read(tim_paddr, read_data);
  if (read_data === expected_data)
    $display("t= %10d ==> PASS: addr=%x Exp=  %x  Actual=%x", $time, tim_paddr,expected_data, read_data);
  else begin
    $display("t= %10d ==> FAIL: addr=%x rdata=%x, BUT EXPECTED DATA=%x", $time, tim_paddr,read_data,expected_data);
    failed = 1;
    #100;
    $finish;
  end
end
endtask

  

endmodule


