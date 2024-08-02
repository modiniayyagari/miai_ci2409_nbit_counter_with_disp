module counter_top #(
	parameter TOP_NUM_BITS = 3,
    parameter TOP_NUM_BCDS = (TOP_NUM_BITS > 3) ? 2 : 1,
    parameter TOP_NUM_DISP = TOP_NUM_BCDS
)
(
	input 			   clk,
	input 			   rst, 
	input 			   cnt_start,
	input              cnt_stop,
	input              cnt_rst,
	input              disp_tgl,
	output reg [13:0]  disp_val
);

wire [TOP_NUM_BITS-1:0]      cnt_val;
wire [(TOP_NUM_BCDS*4)-1:0]  bcd_val;
wire [(TOP_NUM_DISP*7)-1:0]  disp_val_pre;

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
  .disp_tgl     (disp_tgl),
  .disp_out     (disp_val_pre)
);

always @(*)
begin
    disp_val = {{(14-(TOP_NUM_DISP*7)){~disp_tgl}},disp_val_pre};
end

endmodule