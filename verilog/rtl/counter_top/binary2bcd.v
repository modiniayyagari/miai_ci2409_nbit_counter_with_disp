module binary2bcd #(
    parameter NUM_BITS = 4,
    parameter NUM_BCDS = (NUM_BITS > 3) ? 2 : 1
)
(
   input      [NUM_BITS-1:0]        bin_in,
   output reg [(NUM_BCDS*4)-1:0]    bcd_out
);
   
integer i;

generate 
if (NUM_BCDS == 1)
begin	
    always @(*)
    begin
        bcd_out=0;		 	
        for (i=0;i<NUM_BITS;i=i+1)                                //Iterate once for each bit in input number
        begin
            if (bcd_out[3:0] >= 5) bcd_out[3:0] = bcd_out[3:0] + 3;		//If any bcd_out digit is >= 5, add three
            bcd_out = {bcd_out[(NUM_BCDS*4)-2:0],bin_in[(NUM_BITS-1)-i]};				        //Shift one bit, and shift in proper bit from input            
        end
    end
end
else if (NUM_BCDS == 2)
begin 
    always @(*)
    begin
        bcd_out=0;		 	
        for (i=0;i<NUM_BITS;i=i+1)                                //Iterate once for each bit in input number
        begin
            if (bcd_out[3:0] >= 5) bcd_out[3:0] = bcd_out[3:0] + 3;		//If any bcd_out digit is >= 5, add three
            if (bcd_out[7:4] >= 5) bcd_out[7:4] = bcd_out[7:4] + 3;
            bcd_out = {bcd_out[(NUM_BCDS*4)-2:0],bin_in[(NUM_BITS-1)-i]};				        //Shift one bit, and shift in proper bit from input            
        end
    end
end

endgenerate

endmodule

