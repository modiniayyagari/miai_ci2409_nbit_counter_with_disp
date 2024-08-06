module disp_7seg #(
    parameter NUM_BCDS = 1,
    parameter NUM_DISP = NUM_BCDS
)
(
   input                           clk,
   input                           rst,
   input      [(NUM_BCDS*4)-1:0]   bcd_in,
   //input                           disp_tgl,
   output reg [(NUM_DISP*7)-1:0]   disp_out
);

reg [(NUM_DISP*7)-1:0] disp_out_next;

//MIAI: 7 Segment Display
//MSB to LSB -> a,b,c,d,e,f,g

genvar i;
generate
    for(i=0; i<NUM_DISP; i=i+1)
    begin
        always @(*)
        begin
            case (bcd_in[(i*4)+3:0+(i*4)])
                0 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0000001;
                1 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b1001111;
                2 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0010010;
                3 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0000110;
                4 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b1001100;
                5 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0100100;
                6 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0100000;
                7 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0001111;
                8 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0000000;
                9 : disp_out_next [(i*7)+6:0+(i*7)] = 7'b0000100;            
                default : disp_out_next [(i*7)+6:0+(i*7)] = 7'b1111110; //MIAI: display -, - when not a decimal number.
            endcase
         end        
     end
endgenerate

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        disp_out <= {NUM_DISP{7'b1111110}};         //MIAI: display -, - when is reset state.
    end
    else
    begin
        disp_out <= disp_out_next;
    end
end
    
endmodule

