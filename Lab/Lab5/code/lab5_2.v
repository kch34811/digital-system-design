/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );

    ////////////////////////
    nor(q, r, q_);
    nor(q_, s, q);
    ////////////////////////

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );

    ////////////////////////
    wire R_tmp, S_tmp, R_master, R_slave, S_master, S_slave, p, p_;
    and(R_tmp, k, q, clk);
    and(S_tmp, j, q_, clk);
    
    assign S_master = S_tmp & reset_n;
    assign R_master = R_tmp | ~reset_n;
    
    srLatch master(S_master, R_master, p, p_);
    
    and(R_slave, p_, ~clk);
    and(S_slave, p, ~clk);
    
    srLatch slave(S_slave, R_slave, q, q_);
    ////////////////////////
    
endmodule