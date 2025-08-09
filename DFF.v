module dff (d, clk, enable, rst, q);
parameter N = 18;
input [N-1:0] d;
input clk, enable, rst;
output reg [N-1:0] q;

parameter RSTTYPE = "SYNC";  //SYNC or ASYNC

generate
if(RSTTYPE == "SYNC") begin   
    always@(posedge clk)begin
        if(rst)
            q <= 0;
        else if(enable)
            q <= d;
    end
end
else if(RSTTYPE == "ASYNC") begin
     always@(posedge clk , posedge rst)begin
        if(rst)
            q <= 0;
        else if(enable)
            q <= d;
    end
end
endgenerate
endmodule