/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    ////////////////////////
    wire c_1, c_2, c_3;
    fullAdder fA_1(x[0], y[0], c_in, out[0], c_1);
    fullAdder fA_2(x[1], y[1], c_1, out[1], c_2);
    fullAdder fA_3(x[2], y[2], c_2, out[2], c_3);
    fullAdder fA_4(x[3], y[3], c_3, out[3], c_out);
    ////////////////////////

endmodule

/* Implement arithmeticUnit with adder module
 * You must use one adder module.
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    wire [3:0] A;
    assign A[0] = (y[0] & select[1]) | (~y[0] & select[2]); 
    assign A[1] = (y[1] & select[1]) | (~y[1] & select[2]); 
    assign A[2] = (y[2] & select[1]) | (~y[2] & select[2]); 
    assign A[3] = (y[3] & select[1]) | (~y[3] & select[2]);
    adder ADDER_1(x[3:0], A[3:0], select[0], out[3:0], c_out);
    ////////////////////////

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    ////////////////////////
    wire [1:0] tmp;
    mux2to1 MUX2to1_1(in[1:0], select[0], tmp[0]);
    mux2to1 MUX2to1_2(in[3:2], select[0], tmp[1]);
    mux2to1 MUX2to1_3(tmp[1:0], select[1], out);
    ////////////////////////

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    ////////////////////////
    wire [3:0] D0, D1, D2, D3;
    assign D0[3] = ~x[0];
    assign D0[2] = x[0] ^ y[0];
    assign D0[1] = x[0] | y[0];
    assign D0[0] = x[0] & y[0];
    mux4to1 MUX4to1_1(D0[3:0], select[1:0], out[0]);
    
    assign D1[3] = ~x[1];
    assign D1[2] = x[1] ^ y[1];
    assign D1[1] = x[1] | y[1];
    assign D1[0] = x[1] & y[1];
    mux4to1 MUX4to1_2(D1[3:0], select[1:0], out[1]);
    
    assign D2[3] = ~x[2];
    assign D2[2] = x[2] ^ y[2];
    assign D2[1] = x[2] | y[2];
    assign D2[0] = x[2] & y[2];
    mux4to1 MUX4to1_3(D2[3:0], select[1:0], out[2]);
    
    assign D3[3] = ~x[3];
    assign D3[2] = x[3] ^ y[3];
    assign D3[1] = x[3] | y[3];
    assign D3[0] = x[3] & y[3];
    mux4to1 MUX4to1_4(D3[3:0], select[1:0], out[3]);
    ////////////////////////

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    ////////////////////////
    or(out, in[0] & ~select, in[1] & select);
    ////////////////////////

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    wire [3:0] aU_out, lU_out;
    arithmeticUnit aU(x[3:0], y[3:0], select[2:0], aU_out[3:0], c_out);
    logicUnit lU(x[3:0], y[3:0], select[1:0], lU_out[3:0]);
    quad QUAD_1(aU_out[3:0], lU_out[3:0], select[3], out[3:0]);
    ////////////////////////

endmodule

module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

    ////////////////////////
    xor(out_s, in_a, in_b);
    and(out_c, in_a, in_b);
    ////////////////////////

endmodule

module fullAdder(
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );

    ////////////////////////
    wire tmp_s, tmp_c, tmp;
    halfAdder hA1(in_a, in_b, tmp_s, tmp_c);
    halfAdder hA2(tmp_s, in_c, out_s, tmp);
    or(out_c, tmp, tmp_c);
    ////////////////////////

endmodule

module quad(
    input [3:0] D0,
    input [3:0] D1,
    input S,
    output [3:0] Q);
    
    wire [1:0] tmp_0, tmp_1, tmp_2, tmp_3;
    assign tmp_0[0] = D0[0];
    assign tmp_0[1] = D1[0];
    assign tmp_1[0] = D0[1];
    assign tmp_1[1] = D1[1];
    assign tmp_2[0] = D0[2];
    assign tmp_2[1] = D1[2];
    assign tmp_3[0] = D0[3];
    assign tmp_3[1] = D1[3];
    
    mux2to1 MUX2to1_4(tmp_0[1:0], S, Q[0]);
    mux2to1 MUX2to1_5(tmp_1[1:0], S, Q[1]);
    mux2to1 MUX2to1_6(tmp_2[1:0], S, Q[2]);
    mux2to1 MUX2to1_7(tmp_3[1:0], S, Q[3]);
endmodule