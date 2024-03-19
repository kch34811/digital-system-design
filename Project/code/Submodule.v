`timescale 1ns / 1ps

// Negative Edge triggered J-K Flip Flop
module edgeTriggeredJKFF(input RESET, input CLK, input J, input K, output reg Q, output reg Q_);    
    initial begin
        Q = 0;
        Q_ = ~Q;
    end
    always @(negedge CLK) begin
        Q  = RESET | (J & ~Q | ~K & Q);
        Q_ = ~RESET & ~Q;     
    end
endmodule

//Ring_Counter - NOT UPDATED
module Ring_Counter(input CLK, input RESET, output [3:0] COUNT);
    wire A_, B_, C_, D_;
    wire A, B, C, D;
    
    edgeTriggeredJKFF D_A(RESET, CLK, COUNT[2], ~COUNT[2], A, A_);
    edgeTriggeredJKFF D_B(RESET, CLK, COUNT[1], ~COUNT[1], B, B_);
    edgeTriggeredJKFF D_C(RESET, CLK, COUNT[0], ~COUNT[0], C, C_);
    edgeTriggeredJKFF D_D(RESET, CLK, ~COUNT[2] | ~COUNT[1] | ~COUNT[0], ~(~COUNT[2] | ~COUNT[1] | ~COUNT[0]),  D, D_);

    assign COUNT[3] = A;
    assign COUNT[2] = B;
    assign COUNT[1] = C;
    assign COUNT[0] = D;   
endmodule

module FSM( 
    input CLK, 
    input RESET,
    input [1:0] I,
    output [3:0] ABCD
    );

    wire [3:0] STATE;
    wire [3:0] STATE_;
    wire J_A, J_B_, J_C, J_D;
    wire K_A, K_B_, K_C, K_D;

    //JK FF
    edgeTriggeredJKFF STATE_A(RESET, CLK, J_A, K_A, STATE[3], STATE_[3]);
    edgeTriggeredJKFF STATE_B(RESET, CLK, J_B, K_B, STATE[2], STATE_[2]);
    edgeTriggeredJKFF STATE_C(RESET, CLK, J_C, K_C, STATE[1], STATE_[1]);
    edgeTriggeredJKFF STATE_D(RESET, CLK, J_D, K_D, STATE[0], STATE_[0]);

    //input of JK FF
    assign J_A = ((~I[1] & ~I[0]) | (~STATE[1] & ~STATE[0]) | (I[0] & (STATE[1] & STATE[0] | ~STATE[2] & ~STATE[0])));
    assign K_A = 1;

    assign J_B = ((~STATE[1] & ~STATE[0]) | (STATE[3] & I[1]));
    assign K_B = ((STATE[3] & I[1]) | (STATE[1] & ~STATE[0] & I[0]));

    assign J_C = ~STATE[0];
    assign K_C = ((STATE[3] & ~STATE[2] & I[1]) | (~STATE[0] & I[0]));

    assign J_D = (~STATE[1] | (~STATE[2] & I[0]));
    assign K_D = ((STATE[3] & ~STATE[2] & I[1]) | I[0]);

    assign ABCD = STATE;

endmodule

module DisplayScore(
    input CLK,
    input [7:0] Enable,
    input [3:0] ABCD,
    output Disp_Buf_0,
    output Disp_Buf_1,
    output Disp_Buf_2,
    output Disp_Buf_3
    );

    parameter ss_  = 8'b11111111;
    parameter ss1 = 8'b10011111;
    parameter ss2 = 8'b00100101;
    parameter ss3 = 8'b00001101;
    parameter ss4 = 8'b10011001;

    wire [0:7] N1, N2, N2_, N3, N4;

    MUX_dis MUX_2(ss2 & Enable, ABCD[2] & (ABCD[1] | ABCD[0]), N2);
    MUX_dis MUX_2_(ss2 & Enable, (~ABCD[1] & ABCD[0]), N2_);
    MUX_dis MUX_3(ss3 & Enable, (ABCD[1] & ~ABCD[0]), N3);
    MUX_dis MUX_4(ss4 & Enable, (ABCD[1] & ABCD[0]), N4);

    assign Disp_Buf_0 = ss_;
    assign Disp_Buf_1 = N1 | N2;
    assign Disp_Buf_2 = ss_;
    assign Disp_Buf_3 = N2_ | N3 | N4;
    
endmodule


module DisplayWinner(
    input CLK,
    input RESET,
    input [7:0] Enable,
    input B,
    output Disp_Buf_0,
    output Disp_Buf_1,
    output Disp_Buf_2,
    output Disp_Buf_3
    );
    
    parameter ssA  = 8'b00010001;
    parameter ssC = 8'b01100011;
    parameter ssD = 8'b10000101;
    parameter ssE = 8'b01100001;
    parameter ssF  = 8'b01110001;
    parameter ssI = 8'b11110011;
    parameter ssL  = 8'b11100011;
    parameter ssM  = 8'b01010111;
    parameter ssN  = 8'b00010011;
    parameter ssP  = 8'b00110001;
    parameter ssT  = 8'b11100001;
    parameter ssU = 8'b10000011;
    parameter ssV = 8'b10001011;
    parameter ssW = 8'b10101011;
    parameter ssZ = 8'b00101101;
    parameter ss_  = 8'b11111111;
    
    wire [3:0] Count_Disp;

    reg [0:7] MUX_0[15:0];
    reg [0:7] MUX_1[15:0];
    reg [0:7] MUX_2[15:0];
    reg [0:7] MUX_3[15:0];

    wire [0:7] M, A, F, I, W, N;
    wire [0:7] C, I_, T, Z, E, N_, W_;

    MUX_dis MUX_M(ssM & Enable, B, M);
    MUX_dis MUX_A(ssA & Enable, B, A);
    MUX_dis MUX_F(ssF & Enable, B, F);
    MUX_dis MUX_I(ssI & Enable, B, I);
    MUX_dis MUX_W(ssW & Enable, B, W);
    MUX_dis MUX_N(ssN& Enable, B, N);

    MUX_dis MUX_C(ssC & Enable, B, C);
    MUX_dis MUX_I_(ssI & Enable, B, I_);
    MUX_dis MUX_T(ssT & Enable, B, T);
    MUX_dis MUX_Z(ssZ & Enable, B, Z);
    MUX_dis MUX_E(ssE & Enable, B, E);
    MUX_dis MUX_N_(ssN & Enable, B, N_);
    MUX_dis MUX_W_(ssW & Enable, B, W_);

    initial begin
        MUX_0[0] <= ss_;        MUX_1[0] <= ss_;        MUX_2[0] <= ss_;        MUX_3[0] <= ss_;
        MUX_0[1] <= ss_;        MUX_1[1] <= ss_;        MUX_2[1] <= ss_;        MUX_3[1] <= M | C;  
        MUX_0[2] <= ss_;        MUX_1[2] <= ss_;        MUX_2[2] <= M | C;      MUX_3[2] <= A | I_;
        MUX_0[3] <= ss_;        MUX_1[3] <= M | C;      MUX_2[3] <= A | I_;     MUX_3[3] <= F | T; 
        MUX_0[4] <= M | C;      MUX_1[4] <= A | I_;     MUX_2[4] <= F | T;      MUX_3[4] <= I | I_;
        MUX_0[5] <= A | I_;     MUX_1[5] <= F | T;      MUX_2[5] <= I | I_;     MUX_3[5] <= A | Z;
        MUX_0[6] <= F | T;      MUX_1[6] <= I | I_;     MUX_2[6] <= A | Z;      MUX_3[6] <= ss_ | E;
        MUX_0[7] <= I | I_;     MUX_1[7] <= A | Z;      MUX_2[7] <= ss_ | E;    MUX_3[7] <= W | N_;       
        MUX_0[8] <= A | Z;      MUX_1[8] <= ss_ | E;    MUX_2[8] <= W | N_;     MUX_3[8] <= I | ss_;
        MUX_0[9] <= ss_ | E;    MUX_1[9] <= W | N_;     MUX_2[9] <= I | ss_;    MUX_3[9] <= N | W_;
        MUX_0[10] <= W | N_;    MUX_1[10] <= I | ss_;   MUX_2[10] <= N | W_;    MUX_3[10] <= ss_ | I_;
        MUX_0[11] <= I | ss_;   MUX_1[11] <= N | W_;    MUX_2[11] <= ss_ | I_;  MUX_3[11] <= ss_ | N_;
        MUX_0[12] <= N | W_;    MUX_1[12] <= ss_ | I_;  MUX_2[12] <= ss_ | N_;  MUX_3[12] <= ss_;
        MUX_0[13] <= ss_ | I_;  MUX_1[13] <= ss_ | N_;  MUX_2[13] <= ss_;       MUX_3[13] <= ss_;
        MUX_0[14] <= ss_ | N_;  MUX_1[14] <= ss_;       MUX_2[14] <= ss_;       MUX_3[14] <= ss_;
        MUX_0[15] <= ss_;       MUX_1[15] <= ss_;       MUX_2[15] <= ss_;       MUX_3[15] <= ss_;
    end   
    
    hexa_8 Counter (RESET, CLK, Count_Disp); 
    MUX_16to1 ss_DispBuf_0_MUX (MUX_0[0], MUX_0[1], MUX_0[2], MUX_0[3], MUX_0[4], MUX_0[5], MUX_0[6], MUX_0[7], MUX_0[8], MUX_0[9], MUX_0[10], MUX_0[11], MUX_0[12], MUX_0[13], MUX_0[14], MUX_0[15], Count_Disp, Disp_Buf_0); 
    MUX_16to1 ss_DispBuf_1_MUX (MUX_1[0], MUX_1[1], MUX_1[2], MUX_1[3], MUX_1[4], MUX_1[5], MUX_1[6], MUX_1[7], MUX_1[8], MUX_1[9], MUX_1[10], MUX_1[11], MUX_1[12], MUX_1[13], MUX_1[14], MUX_1[15], Count_Disp, Disp_Buf_1);
    MUX_16to1 ss_DispBuf_2_MUX (MUX_2[0], MUX_2[1], MUX_2[2], MUX_2[3], MUX_2[4], MUX_2[5], MUX_2[6], MUX_2[7], MUX_2[8], MUX_2[9], MUX_2[10], MUX_2[11], MUX_2[12], MUX_2[13], MUX_2[14], MUX_2[15], Count_Disp, Disp_Buf_2);
    MUX_16to1 ss_DispBuf_3_MUX (MUX_3[0], MUX_3[1], MUX_3[2], MUX_3[3], MUX_3[4], MUX_3[5], MUX_3[6], MUX_3[7], MUX_3[8], MUX_3[9], MUX_3[10], MUX_3[11], MUX_3[12], MUX_3[13], MUX_3[14], MUX_3[15], Count_Disp, Disp_Buf_0);    


endmodule

module DisplayInvalid(
    input CLK,
    input RESET,
    input [7:0] Enable,
    output Disp_Buf_0,
    output Disp_Buf_1,
    output Disp_Buf_2,
    output Disp_Buf_3
    );
    
    wire ssA  = 8'b00010001 & Enable;
    wire ssD = 8'b10000101 & Enable;
    wire ssI = 8'b11110011 & Enable;
    wire ssL  = 8'b11100011 & Enable;
    wire ssN  = 8'b00010011 & Enable;
    wire ssV = 8'b10001011 & Enable;
    wire ss_  = 8'b11111111 & Enable;
    
    wire [3:0] Count_Disp;

    reg [0:7] MUX_0[15:0];
    reg [0:7] MUX_1[15:0];
    reg [0:7] MUX_2[15:0];
    reg [0:7] MUX_3[15:0];

    initial begin
        MUX_0[0] <= ss_;  MUX_1[0] <= ss_;  MUX_2[0] <= ss_;  MUX_3[0] <= ss_;
        MUX_0[1] <= ss_;  MUX_1[1] <= ss_;  MUX_2[1] <= ss_;  MUX_3[1] <= ssI;  
        MUX_0[2] <= ss_;  MUX_1[2] <= ss_;  MUX_2[2] <= ssI;  MUX_3[2] <= ssN;
        MUX_0[3] <= ss_;  MUX_1[3] <= ssI;  MUX_2[3] <= ssN;  MUX_3[3] <= ssV; 
        MUX_0[4] <= ssI;  MUX_1[4] <= ssN;  MUX_2[4] <= ssV;  MUX_3[4] <= ssA;
        MUX_0[5] <= ssN;  MUX_1[5] <= ssV;  MUX_2[5] <= ssA;  MUX_3[5] <= ssL;
        MUX_0[6] <= ssV;  MUX_1[6] <= ssA;  MUX_2[6] <= ssL;  MUX_3[6] <= ssI;
        MUX_0[7] <= ssA;  MUX_1[7] <= ssL;  MUX_2[7] <= ssI;  MUX_3[7] <= ssD;
        MUX_0[8] <= ssL;  MUX_1[8] <= ssI;  MUX_2[8] <= ssD;  MUX_3[8] <= ss_;
        MUX_0[9] <= ssI;  MUX_1[9] <= ssD;  MUX_2[9] <= ss_;  MUX_3[9] <= ss_;
        MUX_0[10] <= ssD; MUX_1[10] <= ss_; MUX_2[10] <= ss_; MUX_3[10] <= ss_;
        MUX_0[11] <= ss_; MUX_1[11] <= ss_; MUX_2[11] <= ss_; MUX_3[11] <= ss_;
        MUX_0[12] <= ss_; MUX_1[12] <= ss_; MUX_2[12] <= ss_; MUX_3[12] <= ss_;
        MUX_0[13] <= ss_; MUX_1[13] <= ss_; MUX_2[13] <= ss_; MUX_3[13] <= ss_;
        MUX_0[14] <= ss_; MUX_1[14] <= ss_; MUX_2[14] <= ss_; MUX_3[14] <= ss_;
        MUX_0[15] <= ss_; MUX_1[15] <= ss_; MUX_2[15] <= ss_; MUX_3[15] <= ss_; 
    end   

    hexa_8 Counter (RESET, CLK, Count_Disp); 
    MUX_16to1 ss_DispBuf_0_MUX (MUX_0[0], MUX_0[1], MUX_0[2], MUX_0[3], MUX_0[4], MUX_0[5], MUX_0[6], MUX_0[7], MUX_0[8], MUX_0[9], MUX_0[10], MUX_0[11], MUX_0[12], MUX_0[13], MUX_0[14], MUX_0[15], Count_Disp, Disp_Buf_0); 
    MUX_16to1 ss_DispBuf_1_MUX (MUX_1[0], MUX_1[1], MUX_1[2], MUX_1[3], MUX_1[4], MUX_1[5], MUX_1[6], MUX_1[7], MUX_1[8], MUX_1[9], MUX_1[10], MUX_1[11], MUX_1[12], MUX_1[13], MUX_1[14], MUX_1[15], Count_Disp, Disp_Buf_1);
    MUX_16to1 ss_DispBuf_2_MUX (MUX_2[0], MUX_2[1], MUX_2[2], MUX_2[3], MUX_2[4], MUX_2[5], MUX_2[6], MUX_2[7], MUX_2[8], MUX_2[9], MUX_2[10], MUX_2[11], MUX_2[12], MUX_2[13], MUX_2[14], MUX_2[15], Count_Disp, Disp_Buf_2);
    MUX_16to1 ss_DispBuf_3_MUX (MUX_3[0], MUX_3[1], MUX_3[2], MUX_3[3], MUX_3[4], MUX_3[5], MUX_3[6], MUX_3[7], MUX_3[8], MUX_3[9], MUX_3[10], MUX_3[11], MUX_3[12], MUX_3[13], MUX_3[14], MUX_3[15], Count_Disp, Disp_Buf_0);    
       
endmodule


module Display(
    input CLK,
    input RESET,
    input [0:7] ssDispBuf_0,
    input [0:7] ssDispBuf_1,
    input [0:7] ssDispBuf_2,
    input [0:7] ssDispBuf_3,
    output [3:0] ssSel, // 7seg Selector
    output [0:7] ssDisp // 7seg Display
    );
    
    Ring_Counter rc(CLK, RESET, ssSel);
    MUX_4to1 ss_Sel_MUX (ssDispBuf_0, ssDispBuf_1, ssDispBuf_2, ssDispBuf_3, ssSel, ssDisp);

endmodule

module MUX_4to1(input [0:7] D_0, input [0:7] D_1, input [0:7] D_2, input [0:7] D_3, input [3:0] S, output [0:7] Y);
    assign Y[0] = (~S[0] & D_0[0]) | (~S[1] & D_1[0]) | (~S[2] & D_2[0]) | (~S[3] & D_3[0]);
    assign Y[1] = (~S[0] & D_0[1]) | (~S[1] & D_1[1]) | (~S[2] & D_2[1]) | (~S[3] & D_3[1]);
    assign Y[2] = (~S[0] & D_0[2]) | (~S[1] & D_1[2]) | (~S[2] & D_2[2]) | (~S[3] & D_3[2]);
    assign Y[3] = (~S[0] & D_0[3]) | (~S[1] & D_1[3]) | (~S[2] & D_2[3]) | (~S[3] & D_3[3]);
    assign Y[4] = (~S[0] & D_0[4]) | (~S[1] & D_1[4]) | (~S[2] & D_2[4]) | (~S[3] & D_3[4]);
    assign Y[5] = (~S[0] & D_0[5]) | (~S[1] & D_1[5]) | (~S[2] & D_2[5]) | (~S[3] & D_3[5]);
    assign Y[6] = (~S[0] & D_0[6]) | (~S[1] & D_1[6]) | (~S[2] & D_2[6]) | (~S[3] & D_3[6]);
    assign Y[7] = (~S[0] & D_0[7]) | (~S[1] & D_1[7]) | (~S[2] & D_2[7]) | (~S[3] & D_3[7]);
endmodule

module MUX_4to1_8bit(input[0:7] i0, input[0:7] i1, input[0:7] i2, input[0:7] i3, input[0:1] s, input enable, output [0:7] out);
    assign out[0] = enable & (~s[0] & (~s[1] & i0[0] | s[1] & i1[0]) | s[0] & (~s[1] & i2[0] | s[1] & i3[0]));
    assign out[1] = enable & (~s[0] & (~s[1] & i0[1] | s[1] & i1[1]) | s[0] & (~s[1] & i2[1] | s[1] & i3[1]));
    assign out[2] = enable & (~s[0] & (~s[1] & i0[2] | s[1] & i1[2]) | s[0] & (~s[1] & i2[2] | s[1] & i3[2]));
    assign out[3] = enable & (~s[0] & (~s[1] & i0[3] | s[1] & i1[3]) | s[0] & (~s[1] & i2[3] | s[1] & i3[3]));
    assign out[4] = enable & (~s[0] & (~s[1] & i0[4] | s[1] & i1[4]) | s[0] & (~s[1] & i2[4] | s[1] & i3[4]));
    assign out[5] = enable & (~s[0] & (~s[1] & i0[5] | s[1] & i1[5]) | s[0] & (~s[1] & i2[5] | s[1] & i3[5]));
    assign out[6] = enable & (~s[0] & (~s[1] & i0[6] | s[1] & i1[6]) | s[0] & (~s[1] & i2[6] | s[1] & i3[6]));
    assign out[7] = enable & (~s[0] & (~s[1] & i0[7] | s[1] & i1[7]) | s[0] & (~s[1] & i2[7] | s[1] & i3[7]));
endmodule

module MUX_dis(input [0:7] D, input S, output [0:7] Y);
    assign Y[0] = D[0] & S;
    assign Y[1] = D[1] & S;
    assign Y[2] = D[2] & S;
    assign Y[3] = D[3] & S;
    assign Y[4] = D[4] & S;
    assign Y[5] = D[5] & S;
    assign Y[6] = D[6] & S;
    assign Y[7] = D[7] & S;
endmodule

module MUX_16to1(   input [0:7] D_0, 
                    input [0:7] D_1,
                    input [0:7] D_2,
                    input [0:7] D_3,
                    input [0:7] D_4,
                    input [0:7] D_5,
                    input [0:7] D_6,
                    input [0:7] D_7,
                    input [0:7] D_8,
                    input [0:7] D_9,
                    input [0:7] D_10,
                    input [0:7] D_11,
                    input [0:7] D_12,
                    input [0:7] D_13,
                    input [0:7] D_14,
                    input [0:7] D_15,
                    input [3:0] S, output [0:7] Y);

    assign Y[0] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[0]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[0]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[0]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[0]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[0]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[0]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[0]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[0]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[0]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[0]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[0]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[0]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[0]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[0]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[0]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[0]); 
    
    assign Y[1] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[1]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[1]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[1]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[1]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[1]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[1]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[1]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[1]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[1]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[1]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[1]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[1]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[1]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[1]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[1]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[1]); 

    assign Y[2] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[2]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[2]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[2]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[2]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[2]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[2]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[2]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[2]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[2]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[2]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[2]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[2]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[2]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[2]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[2]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[2]); 

    assign Y[3] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[3]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[3]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[3]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[3]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[3]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[3]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[3]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[3]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[3]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[3]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[3]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[3]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[3]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[3]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[3]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[3]); 

    assign Y[4] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[4]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[4]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[4]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[4]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[4]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[4]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[4]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[4]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[4]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[4]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[4]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[4]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[4]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[4]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[4]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[4]); 

    assign Y[5] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[5]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[5]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[5]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[5]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[5]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[5]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[5]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[5]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[5]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[5]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[5]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[5]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[5]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[5]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[5]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[5]); 

    assign Y[6] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[6]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[6]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[6]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[6]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[6]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[6]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[6]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[6]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[6]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[6]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[6]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[6]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[6]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[6]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[6]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[6]); 

    assign Y[7] = (~S[3] & ~S[2] & ~S[1] & ~S[0] & D_0[7]) |
            (~S[3] & ~S[2] & ~S[1] & S[0] & D_1[7]) |
            (~S[3] & ~S[2] & S[1] & ~S[0] & D_2[7]) |
            (~S[3] & ~S[2] & S[1] & S[0] & D_3[7]) |
            (~S[3] & S[2] & ~S[1] & ~S[0] & D_4[7]) |
            (~S[3] & S[2] & ~S[1] & S[0] & D_5[7]) |
            (~S[3] & S[2] & S[1] & ~S[0] & D_6[7]) |
            (~S[3] & S[2] & S[1] & S[0] & D_7[7]) |
            (S[3] & ~S[2] & ~S[1] & ~S[0] & D_8[7]) |
            (S[3] & ~S[2] & ~S[1] & S[0] & D_9[7]) |
            (S[3] & ~S[2] & S[1] & ~S[0] & D_10[7]) |
            (S[3] & ~S[2] & S[1] & S[0] & D_11[7]) |
            (S[3] & S[2] & ~S[1] & ~S[0] & D_12[7]) |
            (S[3] & S[2] & ~S[1] & S[0] & D_13[7]) |
            (S[3] & S[2] & S[1] & ~S[0] & D_14[7]) |
            (S[3] & S[2] & S[1] & S[0] & D_15[7]); 

endmodule

module hexa_counter(input reset_n, input clk, output [3:0] count);
    
    //MSB
    edgeTriggeredJKFF JKFF_3(
        .RESET(reset_n), 
        .CLK(clk), 
        .J(count[2] && count[1] && count[0]), 
        .K(count[2] && count[1] && count[0]), 
        .Q(count[3]), 
        .Q_());
       
    edgeTriggeredJKFF JKFF_2(
        .RESET(reset_n), 
        .CLK(clk), 
        .J(count[1] && count[0]), 
        .K(count[1] && count[0]), 
        .Q(count[2]), 
        .Q_());
    
    edgeTriggeredJKFF JKFF_1(
        .RESET(reset_n), 
        .CLK(clk), 
        .J(count[0]), 
        .K(count[0]), 
        .Q(count[1]), 
        .Q_());
    
    edgeTriggeredJKFF JKFF_0(
        .RESET(reset_n), 
        .CLK(clk), 
        .J(1), 
        .K(1), 
        .Q(count[0]), 
        .Q_());

endmodule

module hexa_2 (input reset_n, input clk, output [7:0] count);

    hexa_counter hex0(reset_n, clk, count[3:0]);
    hexa_counter hex1(reset_n, clk & reset_n | count[3] & ~reset_n, count[7:4]);

endmodule

module hexa_4 (input reset_n, input clk, output [15:0] count);
    
    hexa_2 hex0(reset_n, clk, count[7:0]);
    hexa_2 hex1(reset_n,  clk & reset_n | count[7] & ~reset_n, count[15:8]);

endmodule

module hexa_8 (input reset_n, input clk, output [3:0] count_out);
    wire [31:0] count;
    hexa_4 hex0(reset_n, clk, count[15:0]);
    hexa_4 hex1(reset_n,  clk & reset_n | count[15] & ~reset_n, count[31:16]);
    assign count_out = count[31:28];
endmodule