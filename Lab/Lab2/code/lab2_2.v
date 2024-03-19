/* CSED273 lab2 experiment 2 */
/* lab2_2.v */

/* Simplifed equation by K-Map method
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_2(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT_2 cal_gt2(outGT, inA, inB);
    CAL_EQ_2 cal_eq2(outEQ, inA, inB);
    CAL_LT_2 cal_lt2(outLT, inA, inB);

endmodule

/* Implement output about "A>B" */
module CAL_GT_2(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    ////////////////////////
    wire A_1, A_0, B_1, B_0;
    wire tmp1, tmp2, tmp3;

    assign A_1 = inA[1];
    assign A_0 = inA[0];
    assign B_1 = inB[1];
    assign B_0 = inB[0];

    and(tmp1, A_1, ~B_1);
    and(tmp2, A_0, ~B_1, ~B_0);
    and(tmp3, A_1, A_0, ~B_0);
    
    or(outGT, tmp1, tmp2, tmp3);
    ////////////////////////

endmodule

/* Implement output about "A=B" */
module CAL_EQ_2(
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
module CAL_LT_2(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////
    wire A_1, A_0, B_1, B_0;
    wire tmp1, tmp2, tmp3;

    assign A_1 = inA[1];
    assign A_0 = inA[0];
    assign B_1 = inB[1];
    assign B_0 = inB[0];

    and(tmp1, ~A_1, B_1);
    and(tmp2, ~A_1, ~A_0, B_0);
    and(tmp3, ~A_0, B_1, B_0);
    
    or(outLT, tmp1, tmp2, tmp3);
    ////////////////////////

endmodule