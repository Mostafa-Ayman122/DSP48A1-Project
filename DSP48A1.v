module DSP48A1 (A,B,C,D,CARRYIN,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,
                CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,
                BCIN,PCIN,BCOUT,M,P,PCOUT,CARRY_OUT,CARRY_OUT_F);
//inputs declaration
input [17:0] A, B, D, BCIN;
input [47:0] C, PCIN;
input [7:0] OPMODE;
input CARRYIN, CLK, CEA, CEB, CEC, CED, CEM, CECARRYIN, CEOPMODE,
      CEP, RSTA, RSTB, RSTC, RSTCARRYIN, RSTD,
      RSTM, RSTOPMODE, RSTP;
//outputs declaration
output [17:0] BCOUT;
output [35:0] M;
output [47:0] P, PCOUT;
output CARRY_OUT, CARRY_OUT_F;
//parameters declaration
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1; 
parameter PREG = 1;
parameter CARRYINREG = 1; 
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";   // "OPMODE5" or "CARRYIN"
parameter B_INPUT = "DIRECT";       // "DIRECT" or "CASCADE"
//internal signals declaration
wire [17:0] B0_out, A0_out, D_out, B1_in, A1_out;
reg [17:0] B0_in, adder_out;
wire [35:0] M_out;
wire [47:0] C_out , D_A_B_conc, mux_X_out, mux_Z_out;
reg [47:0] P_in;
wire [7:0] OPMODE_out;
wire CIN;
reg CIN_in, CYO_in;

//B_input mux
always@(*)begin
    case (B_INPUT)
        "DIRECT" : B0_in = B;
        "CASCADE": B0_in = BCIN;
        default  : B0_in = 0;
    endcase
end
//first stage multiplixers
dff_mux M1 (D, DREG, CLK, CED, RSTD, D_out);
dff_mux M2 (B0_in, B0REG, CLK, CEB, RSTD, B0_out);
dff_mux M3 (A, A0REG, CLK, CEA, RSTD, A0_out);
dff_mux #(.N(48)) M4 (C, CREG, CLK, CEC, RSTD, C_out);
//OPMODE mux
dff_mux #(.N(8)) M5 (OPMODE, OPMODEREG, CLK, CEOPMODE, RSTOPMODE, OPMODE_out);
//Pre_adder_subtractor
always@(*) begin
    if(~OPMODE_out[6])
        adder_out = D_out + B0_out;
    else
        adder_out = D_out - B0_out;
end
//second stage for A and B multiplixer
mux m1 (B0_out, adder_out, OPMODE_out[4], B1_in);
dff_mux M6 (A0_out, A1REG, CLK, CEA, RSTA, A1_out);
dff_mux M7 (B1_in, B1REG, CLK, CEB, RSTB, BCOUT);

//Multiplier Operation
assign M_out = BCOUT * A1_out;
//Multiplier mux
dff_mux #(.N(36)) M8 (M_out, MREG, CLK, CEM, RSTM, M);

//Carry in select adder
always@(*) begin
    case (CARRYINSEL)
        "OPMODE5" : CIN_in = OPMODE_out[5];
        "CARRYIN" : CIN_in = CARRYIN;
    endcase
end
//carry in mux
dff_mux #(.N(1)) M9 (CIN_in, CARRYINREG, CLK, CECARRYIN, RSTCARRYIN, CIN);
//concatenated signal of D, A and B
assign D_A_B_conc = {D[11:0], A[17:0], B[17:0]};
// mux X instantiation
mux_X m2 (D_A_B_conc, PCOUT, M, 0, OPMODE_out[1:0], mux_X_out);
// mux Z instantiation
mux_Z m3 (C_out, PCOUT, PCIN, 0, OPMODE_out[3:2], mux_Z_out);

//Post adder operation
always@(*) begin
    if(~OPMODE_out[7])
        {CYO_in, P_in} = mux_X_out + mux_Z_out + CIN;
    else
        {CYO_in, P_in} = mux_Z_out - (mux_X_out + CIN);
end
//carry out mux
dff_mux #(.N(1)) M10 (CYO_in, CARRYOUTREG, CLK, CECARRYIN, RSTCARRYIN, CARRY_OUT);
assign CARRY_OUT_F = CARRY_OUT;
//output p mux
dff_mux #(.N(48)) M11 (P_in, PREG, CLK, CEP, RSTP, P);
assign PCOUT = P;

endmodule