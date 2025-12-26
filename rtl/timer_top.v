module timer_top
( input wire sys_clk,
  input wire sys_rst_n,
  input wire tim_pwrite,
  input wire tim_psel,
  input wire tim_penable,
  input wire [11:0] tim_paddr,
  input wire [31:0] tim_pwdata,
  input wire [3:0] tim_pstrb,
  input wire dbg_mode,

  output wire [31:0] tim_prdata,
  output wire tim_int,
  output wire tim_pready,
  output wire tim_pslverr
);


//apb_slave
wire wr_en;
wire rd_en;
//counter_control
wire timer_en;
wire [3:0] div_val;
wire div_en;
wire halt_req;
wire halt_ack;
//counter
wire [63:0] cnt;
wire cnt_clr;
wire cnt_en;
wire tdr_0_wr_sel;
wire tdr_1_wr_sel;
//interrupt
wire int_st;
wire int_en;
wire tisr_wr_sel;
wire [63:0] tcmp;


apb_slave u_apb_slave
(
  .sys_clk                  (sys_clk),
  .sys_rst_n                (sys_rst_n),
  .tim_pwrite               (tim_pwrite),
  .tim_psel                 (tim_psel),
  .tim_penable              (tim_penable),
  .tim_pready               (tim_pready),
  .wr_en                    (wr_en),
  .rd_en                    (rd_en)
);

register u_register
(
  .sys_clk                  (sys_clk),
  .sys_rst_n                (sys_rst_n),
  .cnt                      (cnt),
  .wr_en                    (wr_en),
  .rd_en                    (rd_en),
  .addr                     (tim_paddr),
  .wdata                    (tim_pwdata),
  .pstrb                    (tim_pstrb),
  .tim_pready               (tim_pready),
  .halt_ack                 (halt_ack),
  .int_st                   (int_st),    
  .int_en                   (int_en),
  .tisr_wr_sel              (tisr_wr_sel),
  .cnt_clr                  (cnt_clr),
  .rdata                    (tim_prdata),
  .timer_en                 (timer_en),
  .div_val                  (div_val),
  .div_en                   (div_en),
  .halt_req                 (halt_req),
  .tcmp                     (tcmp), 
  .tdr_0_wr_sel             (tdr_0_wr_sel),
  .tdr_1_wr_sel             (tdr_1_wr_sel),
  .error                    (tim_pslverr)
);

counter_control u_counter_control
(
  .sys_clk                  (sys_clk),
  .sys_rst_n                (sys_rst_n),
  .dbg_mode                 (dbg_mode),
  .timer_en                 (timer_en),
  .div_en                   (div_en),
  .halt_req                 (halt_req),
  .div_val                  (div_val),

  .cnt_en                   (cnt_en),
  .halt_ack                 (halt_ack)
);

counter_block u_counter_block
(
  .sys_clk		    (sys_clk),	      
  .sys_rst_n                (sys_rst_n),
  .cnt_en                   (cnt_en),
  .pstrb                    (tim_pstrb),
  .wdata                    (tim_pwdata),
                                              
  .tdr_0_wr_sel             (tdr_0_wr_sel),
  .tdr_1_wr_sel             (tdr_1_wr_sel),
  .cnt_clr                  (cnt_clr),                            
  .cnt                      (cnt)
);

interrupt u_interrupt
(
  .sys_clk		    (sys_clk),	      
  .sys_rst_n                (sys_rst_n),
  .tisr_wr_sel              (tisr_wr_sel),
  .wdata                    (tim_pwdata),
  .pstrb                    (tim_pstrb),
  .cnt                      (cnt),
  .tcmp                     (tcmp), 
  .int_en                   (int_en),
  .int_st                   (int_st),    
  .tim_int                  (tim_int)
);


endmodule
