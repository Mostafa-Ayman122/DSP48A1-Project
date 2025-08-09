module mux_X (in0, in1, in2, in3, sel, out);
input [47:0] in0, in1;
input [35:0] in2;
input in3;
input [1:0] sel;
output reg [47:0] out;
always@(*) begin
    case (sel) 
        2'b00 : out = in3;
        2'b01 : out = in2;
        2'b10 : out = in1;
        2'b11 : out = in0;
    endcase
end
endmodule
