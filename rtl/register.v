module register
(
  input wire sys_clk,
  input wire sys_rst_n,
  input wire [63:0] cnt,
  input wire wr_en,
  input wire rd_en,
  
  input wire [11:0] addr,
  input wire [31:0] wdata,
  input wire [3:0] pstrb,
  input wire tim_pready,
  input wire halt_ack,
  
  input wire int_st,
  output reg int_en,
  output wire tisr_wr_sel,
  output wire cnt_clr,

  output reg [31:0] rdata,
  output reg timer_en,
  output reg [3:0] div_val,
  output reg div_en,
  output reg halt_req,
  output reg [63:0] tcmp,
  output wire tdr_0_wr_sel,
  output wire tdr_1_wr_sel,
  output wire error
);

parameter ADDR_TCR    = 12'h00;
parameter ADDR_TDR0   = 12'h04;
parameter ADDR_TDR1   = 12'h08;
parameter ADDR_TCMP0  = 12'h0C;
parameter ADDR_TCMP1  = 12'h10;
parameter ADDR_TIER   = 12'h14;
parameter ADDR_TISR   = 12'h18;
parameter ADDR_THCSR  = 12'h1C;

wire tcr_wr_sel;
wire tier_wr_sel;
reg timer_en_pre;
wire err_div_en_change;
wire err_div_val_change;


//write select
assign tcr_wr_sel    = wr_en & (addr == ADDR_TCR);  //
assign tdr_0_wr_sel  = wr_en & (addr == ADDR_TDR0); 
assign tdr_1_wr_sel  = wr_en & (addr == ADDR_TDR1); 
assign tier_wr_sel   = wr_en & (addr == ADDR_TIER); //
assign tisr_wr_sel   = wr_en & (addr == ADDR_TISR); 


//bo sung error
assign err_div_en_change    = timer_en & tcr_wr_sel & pstrb[0] & (wdata[1] != div_en);
assign err_div_val_change   = (timer_en & tcr_wr_sel & pstrb[1] & (wdata[11:8] != div_val)) | (tcr_wr_sel && pstrb[1] && (wdata[11:8] > 4'b1000));

assign error = err_div_en_change || err_div_val_change ;

//write
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    div_en   <= 1'b0;
    timer_en <= 1'b0;
    div_val  <= 4'b0001;
    tcmp     <= 64'hFFFF_FFFF_FFFF_FFFF;
    halt_req <= 1'b0;
    int_en   <= 1'b0;
  end
  else if (wr_en) begin
    case (addr)
      ADDR_TCR: begin
	timer_en <= (~error && pstrb[0]) ? wdata[0] : timer_en; 	
	div_en   <= (~error && pstrb[0]) ? wdata[1] : div_en; 	
	div_val  <= (~error && pstrb[1]) ? wdata[11:8] : div_val; 	
      end
      ADDR_TCMP0: begin
        tcmp[31:24] <= (pstrb[3]) ? wdata[31:24]  : tcmp[31:24];
        tcmp[23:16] <= (pstrb[2]) ? wdata[23:16]  : tcmp[23:16];
        tcmp[15:8]  <= (pstrb[1]) ? wdata[15:8]   : tcmp[15:8];
        tcmp[7:0]   <= (pstrb[0]) ? wdata[7:0]    : tcmp[7:0];
      end     
      ADDR_TCMP1: begin
        tcmp[63:56] <= (pstrb[3]) ? wdata[31:24]  : tcmp[63:56];
        tcmp[55:48] <= (pstrb[2]) ? wdata[23:16]  : tcmp[55:48];
        tcmp[47:40] <= (pstrb[1]) ? wdata[15:8]   : tcmp[47:40];
        tcmp[39:32] <= (pstrb[0]) ? wdata[7:0]    : tcmp[39:32];
      end     
      ADDR_TIER: begin
        int_en <= (pstrb[0]) ? wdata[0] : int_en;
      end
      ADDR_THCSR: begin
        halt_req <= (pstrb[0]) ? wdata[0] : halt_req;
      end
      default: begin
        div_val  <= div_val;
	div_en   <= div_en;
	timer_en <= timer_en;
	tcmp     <= tcmp;
	int_en   <= int_en;
	halt_req <= halt_req;
      end
    endcase
  end
  else begin
    div_val  <= div_val;
    div_en   <= div_en;
    timer_en <= timer_en;
    tcmp     <= tcmp;
    int_en   <= int_en;
    halt_req <= halt_req;
  end
end


//read
always @(*) begin
  if (rd_en && tim_pready) begin
    case (addr)
      ADDR_TCR    : rdata = {20'b0, div_val, 6'b0, div_en, timer_en};
      ADDR_TDR0   : rdata = cnt[31:0];
      ADDR_TDR1   : rdata = cnt[63:32];
      ADDR_TCMP0  : rdata = tcmp[31:0];
      ADDR_TCMP1  : rdata = tcmp[63:32];
      ADDR_TIER   : rdata = {31'b0, int_en};
      ADDR_TISR   : rdata = {31'b0, int_st};
      ADDR_THCSR  : rdata = {30'b0, halt_ack, halt_req};
      default     : rdata = 32'h0000_0000; //read as zero
    endcase
  end
  else begin
    rdata = 32'h0000_0000;
  end
end



//bo sung timer_en changes from H -> L
always @(posedge sys_clk or negedge sys_rst_n) begin
  if(!sys_rst_n)
    timer_en_pre <= 1'b0;
  else
    timer_en_pre <= timer_en;
end

assign cnt_clr = timer_en_pre & ~timer_en;
endmodule





