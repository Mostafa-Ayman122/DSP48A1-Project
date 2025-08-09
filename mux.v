module mux (in0, in1, sel, out);
parameter N = 18;
input [N-1:0] in0, in1;
input sel;
output reg [N-1:0] out;

always@(*) begin
    case (sel)
        0 : out = in0;
        1 : out = in1;
        default : out = 0;
    endcase
end
endmodule