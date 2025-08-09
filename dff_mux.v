module dff_mux (in, sel, clk, enable, rst, out);
parameter N = 18;
input [N-1:0] in;
input sel, clk, enable, rst;
output wire [N-1:0] out;

wire [N-1:0] reg_out;

dff #(.N(N)) D1 (in, clk, enable, rst, reg_out);
mux #(.N(N)) M1 (in, reg_out, sel, out);

endmodule