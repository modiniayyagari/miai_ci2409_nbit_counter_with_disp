module upw_tieoffs #(
  parameter NUM_INS = 3,
  parameter NUM_OUTS = 14,
  parameter NUM_IOS = 17
)
(
  `ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
  `endif

  output [NUM_IOS-1:0] out_en
);

//MIAI: Ordering of the pins as per pin_order.cfg
//out_en = OUTPUTS, INPUTs

assign out_en [NUM_INS-1:0] = {NUM_INS{1'b0}};
assign out_en [NUM_IOS-1:NUM_INS] = {NUM_OUTS{1'b1}};

endmodule
