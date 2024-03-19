/* CSED273 lab2 experiment 1 */
/* lab2_1.v */

/* Unsimplifed equation
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_1(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT cal_gt(outGT, inA, inB);
    CAL_EQ cal_eq(outEQ, inA, inB);
    CAL_LT cal_lt(outLT, inA, inB);
    
endmodule

/* Implement output about "A>B" */
module CAL_GT(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    ////////////////////////
    wire A_1, A_0, B_1, B_0;
    wire tmp1, tmp2, tmp3, tmp4, tmp5, tmp6;

    assign A_1 = inA[1];
    assign A_0 = inA[0];
    assign B_1 = inB[1];
    assign B_0 = inB[0];

    and(tmp1, ~A_1, A_0, ~B_1, ~B_0);
    and(tmp2, A_1, A_0, ~B_1, ~B_0);
    and(tmp3, A_1, A_0, ~B_1, B_0);
    and(tmp4, A_1, A_0, B_1, ~B_0);
    and(tmp5, A_1, ~A_0, ~B_1, ~B_0);
    and(tmp6, A_1, ~A_0, ~B_1, B_0);

    or(outGT, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6);
    ////////////////////////

endmodule

/* Implement output about "A=B" */
module CAL_EQ(
    output wire outEQ,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////
    wire A_1, A_0, B_1, B_0;
    wire tmp1, tmp2, tmp3, tmp4;

    assign A_1 = inA[1];
    assign A_0 = inA[0];
    assign B_1 = inB[1];
    assign B_0 = inB[0];

    and(tmp1, ~A_1, ~A_0, ~B_1, ~B_0);
    and(tmp2, ~A_1, A_0, ~B_1, B_0);
    and(tmp3, A_1, A_0, B_1, B_0);
    and(tmp4, A_1, ~A_0, B_1, ~B_0);
    
    or(outEQ, tmp1, tmp2, tmp3, tmp4);
    ////////////////////////

endmodule

/* Implement output about "A<B" */
module CAL_LT(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////
    wire A_1, A_0, B_1, B_0;
    wire tmp1, tmp2, tmp3, tmp4, tmp5, tmp6;

    assign A_1 = inA[1];
    assign A_0 = inA[0];
    assign B_1 = inB[1];
    assign B_0 = inB[0];

    and(tmp1, ~A_1, ~A_0, ~B_1, B_0);
    and(tmp2, ~A_1, ~A_0, B_1, B_0);
    and(tmp3, ~A_1, ~A_0, B_1, ~B_0);
    and(tmp4, ~A_1, A_0, B_1, B_0);
    and(tmp5, ~A_1, A_0, B_1, ~B_0);
    and(tmp6, A_1, ~A_0, B_1, B_0);

    or(outLT, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6);
    ////////////////////////

endmodule