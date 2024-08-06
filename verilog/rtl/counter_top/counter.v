module counter #(
	parameter NUM_BITS = 2
)
(
	input 						clk,
	input 						rst, 
	input 						cnt_start,
	input                       cnt_stop,
	input                       cnt_rst,
	output reg [NUM_BITS-1:0] 	cnt_val
);

wire [2:0] cnt_sel;

assign cnt_sel = {cnt_start, cnt_stop, cnt_rst};

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		cnt_val   <= {NUM_BITS{1'b0}};
	end
	else
	begin
	  case (cnt_sel)
	    3'b000,
        3'b001:     cnt_val <= {NUM_BITS{1'b0}};
        3'b010:     cnt_val <= cnt_val;  
        3'b100:     cnt_val <= cnt_val + 1;              
        default:    cnt_val   <= {NUM_BITS{1'bx}};	  //MIAI: Find out how to display X on 7seg, BCD and binary
      endcase
	end
end

endmodule

