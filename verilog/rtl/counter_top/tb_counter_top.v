//Testbench 
`timescale 1ns/1ns

module  tb_counter_top;

parameter TB_NUM_BITS = 4;
parameter TB_NUM_BCDS = (TB_NUM_BITS > 3) ? 2 : 1;
parameter TB_NUM_DISP = TB_NUM_BCDS;

reg     tb_clk;       
reg     tb_rst;
reg     tb_cnt_start;
reg     tb_cnt_stop;
reg     tb_cnt_rst;
reg     tb_disp_tgl;

//wire [TB_NUM_BITS-1:0]      tb_cnt_val;
//wire [(TB_NUM_BCDS*4)-1:0]  tb_bcd_val;
//wire [(TB_NUM_DISP*7)-1:0]  tb_disp_val;
wire [(2*7)-1:0] tb_disp_val;

//Module Instantiations

/*
counter #(
  .NUM_BITS   (TB_NUM_BITS)
) u_counter_0 (
  .clk          (tb_clk),
  .rst          (tb_rst),
  .cnt_start    (tb_cnt_start),
  .cnt_stop     (tb_cnt_stop),
  .cnt_rst      (tb_cnt_rst),
  .cnt_val      (tb_cnt_val)
);

binary2bcd #(
    .NUM_BITS   (TB_NUM_BITS),
    .NUM_BCDS   (TB_NUM_BCDS)
) u_bin2bcd_0 (
    .bin_in     (tb_cnt_val),
    .bcd_out    (tb_bcd_val)
);

disp_7seg #(
    .NUM_BCDS    (TB_NUM_BCDS),
    .NUM_DISP    (TB_NUM_DISP)
) u_disp_0 (
  .clk          (tb_clk),
  .rst          (tb_rst),
  .bcd_in       (tb_bcd_val),
  .disp_tgl     (tb_disp_tgl),
  .disp_out     (tb_disp_val)
);
*/

counter_top #(
  .TOP_NUM_BITS   (TB_NUM_BITS),
  .TOP_NUM_BCDS   (TB_NUM_BCDS),
  .TOP_NUM_DISP   (TB_NUM_DISP)
) u_counter_0 (
  .clk          (tb_clk),
  .rst          (tb_rst),
  .cnt_start    (tb_cnt_start),
  .cnt_stop     (tb_cnt_stop),
  .cnt_rst      (tb_cnt_rst),
  .disp_tgl     (tb_disp_tgl),
  .disp_val     (tb_disp_val)
);

initial 
begin
	#0 tb_clk = 1'b0; tb_rst = 1'b0; 
    #5 tb_clk = 1'b0; tb_rst = 1'b1;
	#5 tb_clk = 1'b1; tb_rst = 1'b0; tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0; tb_disp_tgl = 1'b0;
end

always
begin
  #5 tb_clk  = ~tb_clk;
end

initial
begin
  //Run the counter from 0 to 63, then reset the counter to 0
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #600 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b1;
  
  //Run the counter from 0 to 63, then reset the counter to 0
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0; tb_disp_tgl = 1'b1;
  #600 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b1; tb_disp_tgl = 1'b0;
   
  //Start coutner from 0, Stop counter and check if its holding the value,
  //resume the counter from hold value and then reset to 0
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b1; tb_cnt_rst = 1'b0;
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;  
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b1;
   
  //Start coutner from 0, Stop counter and check if its holding the value,
  //reset the counter to 0 after hold for few cycles. 
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b1; tb_cnt_rst = 1'b0;
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b1; 
  
  //Start counter from 0, then give invalid controls, the output should go to [-,-] on 7seg.
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #100 tb_cnt_start = 1'b1; tb_cnt_stop = 1'b1; tb_cnt_rst = 1'b0;
  //Resume from the invalid counter state without reset and check display
  #100 tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #500 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b1; tb_cnt_rst = 1'b0;  
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b1;
  
  //Start counter from 0, then give invalid controls, the output should go to [-,-] on 7seg.
  #50  tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b1; tb_cnt_rst = 1'b1;
  //Resume from the invalid counter state with reset and check display
  #100 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b1;
  #500 tb_cnt_start = 1'b1; tb_cnt_stop = 1'b0; tb_cnt_rst = 1'b0;
  #500 tb_cnt_start = 1'b0; tb_cnt_stop = 1'b1; tb_cnt_rst = 1'b0;
  
end

initial
begin
  #20000;
  $finish;
end

endmodule
