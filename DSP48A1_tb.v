module DSP48A1_tb ();
reg [17:0] A, B, D, BCIN;
reg [47:0] C, PCIN;
reg [7:0] OPMODE;
reg CARRYIN, CLK, CEA, CEB, CEC, CED, CEM, CECARRYIN, CEOPMODE,
      CEP, RSTA, RSTB, RSTC, RSTCARRYIN, RSTD,
      RSTM, RSTOPMODE, RSTP;

wire [17:0] BCOUT_tb;
wire [35:0] M_tb;
wire [47:0] P_tb, PCOUT_tb;
wire CARRY_OUT_tb, CARRY_OUT_F_tb;

DSP48A1 DUT (A,B,C,D,CARRYIN,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,
            RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCIN,PCIN,BCOUT_tb,M_tb,P_tb,PCOUT_tb,CARRY_OUT_tb,CARRY_OUT_F_tb);

initial begin
CLK = 0;
forever #1 CLK = ~CLK;
end

integer i;
initial begin
//Assert reset signals
RSTA = 1;
RSTB = 1;
RSTC = 1;
RSTD = 1;
RSTM = 1;
RSTP = 1;
RSTCARRYIN = 1;
RSTOPMODE = 1;
//randomize the rest of the inputs
for(i=0; i<10; i=i+1) begin
    A = $random;
    B = $random;
    C = $random;
    D = $random;
    BCIN = $random;
    PCIN = $random;
    OPMODE = $random;
    CARRYIN = $random;
    CEA = $random;
    CEB = $random;
    CEC = $random;
    CED = $random;
    CEM = $random;
    CECARRYIN = $random;
    CEOPMODE = $random;
    CEP = $random;
    @(negedge CLK);
    if (P_tb != 0 || PCOUT_tb != 0 || BCOUT_tb != 0 || M_tb != 0 || CARRY_OUT_tb != 0 || CARRY_OUT_F_tb != 0 ) begin
        $display("Error in reset function");
        $stop;
    end
end
//Deassert the resest signals
RSTA = 0;
RSTB = 0;
RSTC = 0;
RSTD = 0;
RSTM = 0;
RSTP = 0;
RSTCARRYIN = 0;
RSTOPMODE = 0;
//assert clock enable signals
CEA = 1;
CEB = 1;
CEC = 1;
CED = 1;
CEM = 1;
CECARRYIN = 1;
CEOPMODE = 1;
CEP = 1;
//Verify path 1
OPMODE = 8'b11011101;
//assert A, B, C, D
A = 20;
B = 10;
C = 350;
D = 25;
for(i=0; i<10; i=i+1) begin
BCIN = $random;
PCIN = $random;
CARRYIN = $random;
repeat(4)@(negedge CLK);
if (P_tb != 'h32 || PCOUT_tb != 'h32 || BCOUT_tb != 'hf || M_tb != 'h12c || CARRY_OUT_tb != 0 || CARRY_OUT_F_tb != 0 ) begin
    $display("Error in path 1 function");
    $stop;
end
end
//Verify path 2
OPMODE = 8'b00010000;
for(i=0; i<10; i=i+1) begin
BCIN = $random;
PCIN = $random;
CARRYIN = $random;
repeat(3)@(negedge CLK);
if (P_tb != 0 || PCOUT_tb != 0 || BCOUT_tb != 'h23 || M_tb != 'h2bc || CARRY_OUT_tb != 0 || CARRY_OUT_F_tb != 0 ) begin
    $display("Error in path 2 function");
    $stop;
end
end
//Verify path 3
OPMODE = 8'b00001010;
for(i=0; i<10; i=i+1) begin
BCIN = $random;
PCIN = $random;
CARRYIN = $random;
repeat(3)@(negedge CLK);
if (P_tb != P_tb || PCOUT_tb !=PCOUT_tb || BCOUT_tb != 'ha || M_tb != 'hc8 || CARRY_OUT_tb != CARRY_OUT_tb || CARRY_OUT_F_tb != CARRY_OUT_F_tb ) begin
    $display("Error in path 3 function");
    $stop;
end
end
//Verify path 4
OPMODE = 8'b10100111;
A = 5;
B = 6;
C = 350;
D = 25;
PCIN = 3000;
for(i=0; i<10; i=i+1) begin
BCIN = $random;
CARRYIN = $random;
repeat(3)@(negedge CLK);
if (P_tb != 'hfe6fffec0bb1 || PCOUT_tb != 'hfe6fffec0bb1 || BCOUT_tb != 'h6 || M_tb != 'h1e || CARRY_OUT_tb != 1 || CARRY_OUT_F_tb != 1 ) begin
    $display("Error in path 4 function");
    $stop;
end
end
$stop;
end
endmodule