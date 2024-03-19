/* CSED273 lab4 experiment 1 */
/* lab4_1.v */


/* Implement Half Adder
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
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

/* Implement Full Adder
 * You must use halfAdder module
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
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