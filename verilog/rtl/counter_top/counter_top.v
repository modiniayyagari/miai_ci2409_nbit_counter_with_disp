module counter_top #(
	  parameter TOP_NUM_BITS = 3,
    parameter TOP_NUM_BCDS = (TOP_NUM_BITS > 3) ? 2 : 1,
    parameter TOP_NUM_DISP = TOP_NUM_BCDS
)
(
  `ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
  `endif

	input 			   clk,
	input 			   rst, 
	input 			   cnt_start,
	input          cnt_stop,
	input          cnt_rst,
	//input        disp_tgl,
	output [13:0]  disp_val,
  output [16:0]  out_en
);

wire [TOP_NUM_BITS-1:0]      cnt_val;
wire [(TOP_NUM_BCDS*4)-1:0]  bcd_val;
wire [(TOP_NUM_DISP*7)-1:0]  disp_val_pre;

localparam  TOP_NUM_INS       = 3;
localparam  TOP_NUM_OUTS      = 14;
localparam  TOP_NUM_IOS       = 17;

//Module Instantiations
counter #(
  .NUM_BITS   (TOP_NUM_BITS)
) u_counter_0 (
  .clk          (clk),
  .rst          (rst),
  .cnt_start    (cnt_start),
  .cnt_stop     (cnt_stop),
  .cnt_rst      (cnt_rst),
  .cnt_val      (cnt_val)
);

binary2bcd #(
    .NUM_BITS   (TOP_NUM_BITS),
    .NUM_BCDS   (TOP_NUM_BCDS)
) u_bin2bcd_0 (
    .bin_in     (cnt_val),
    .bcd_out    (bcd_val)
);

disp_7seg #(
    .NUM_BCDS    (TOP_NUM_BCDS),
    .NUM_DISP    (TOP_NUM_DISP)
) u_disp_0 (
  .clk          (clk),
  .rst          (rst),
  .bcd_in       (bcd_val),
  //MIAI .disp_tgl     (disp_tgl),
  .disp_out     (disp_val_pre)
);

//MIAI:always @(*)
//MIAI:begin
//MIAI:    disp_val = {{(14-(TOP_NUM_DISP*7)){~disp_tgl}},disp_val_pre};
//MIAI:end

assign disp_val [13:0] = {{(14-(TOP_NUM_DISP*7)){1'b1}},disp_val_pre[(TOP_NUM_DISP*7)-1:0]};

upw_tieoffs #(
  .NUM_INS      (TOP_NUM_INS),
  .NUM_OUTS     (TOP_NUM_OUTS),
  .NUM_IOS      (TOP_NUM_IOS)
) u_upw_tieoff_0 (
  `ifdef USE_POWER_PINS
    	.vccd1(vccd1),	// User area 1 1.8V power
    	.vssd1(vssd1),	// User area 1 digital ground
  `endif
  .out_en     (out_en[16:0])
);

endmodule

