/* CSED273 lab4 experiment 2 */
/* lab4_2.v */

/* Implement 5-Bit Ripple Adder
 * You must use fullAdder module in lab4_1.v
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module lab4_2(
    input [4:0] in_a,
    input [4:0] in_b,
    input in_c,
    output [4:0] out_s,
    output out_c
    );

    ////////////////////////
    wire temp[3:0];
    fullAdder fA1(in_a[0],in_b[0],in_c,out_s[0],temp[0]);
    fullAdder fA2(in_a[1],in_b[1],temp[0],out_s[1],temp[1]);
    fullAdder fA3(in_a[2],in_b[2],temp[1],out_s[2],temp[2]);
    fullAdder fA4(in_a[3],in_b[3],temp[2],out_s[3],temp[3]);
    fullAdder fA5(in_a[4],in_b[4],temp[3],out_s[4],out_c);
    ////////////////////////

endmodule