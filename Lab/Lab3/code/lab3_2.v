/* CSED273 lab3 experiment 2 */
/* lab3_2.v */


/* Implement Prime Number Indicator & Multiplier Indicator
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
 
/* 11: out_mul[4], 7: out_mul[3], 5: out_mul[2],
 * 3: out_mul[1], 1: out_mul[0] */
module lab3_2(
    input wire [3:0] in,
    output wire out_prime,
    output wire [4:0] out_mul
    );

    ////////////////////////
    wire [4:0] temp;
    
    and(temp[0], ~in[3], in[1], in[0]);
    and(temp[1], ~in[3], ~in[2], in[1]);
    and(temp[2], ~in[2], in[1], in[0]);
    and(temp[3], in[2], ~in[1], in[0]);
    
    or(out_prime, temp[0], temp[1], temp[2], temp[3]);
    
    assign out_mul[0] = ~in[0];

    wire[4:0] mul_3;
    and(mul_3[0], ~in[3], ~in[2], in[1], in[0]);
    and(mul_3[1], ~in[3], in[2], in[1], ~in[0]);
    and(mul_3[2], in[3], in[2], ~in[1], ~in[0]);
    and(mul_3[3], in[3], in[2], in[1], in[0]);
    and(mul_3[4], in[3], ~in[2], ~in[1], in[0]);
    or(out_mul[1], mul_3[0], mul_3[1], mul_3[2], mul_3[3], mul_3[4]);
    
    wire[2:0] mul_5;
    and(mul_5[0], ~in[3], in[2], ~in[1], in[0]);
    and(mul_5[1], in[3], in[2], in[1], in[0]);
    and(mul_5[2], in[3], ~in[2], in[1], ~in[0]);
    or(out_mul[2], mul_5[0], mul_5[1], mul_5[2]);

    wire[1:0] mul_7;
    and(mul_7[0], ~in[3], in[2], in[1], in[0]);
    and(mul_7[1], in[3], in[2], in[1], ~in[0]);  
    or(out_mul[3], mul_7[0], mul_7[1]); 

    and(out_mul[4], in[3], ~in[2], in[1], in[0]);
    ////////////////////////

endmodule