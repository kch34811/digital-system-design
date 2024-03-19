/* CSED273 lab6 experiment 3 */
/* lab6_3.v */

`timescale 1ps / 1fs

/* Implement 369 game counter (0, 3, 6, 9, 13, 6, 9, 13, 6 ...)
 * You must first implement D flip-flop in lab6_ff.v
 * then you use D flip-flop of lab6_ff.v */
module counter_369(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    wire A, A_, B, B_, C, C_, D, D_;
    edge_trigger_D_FF D_A(reset_n, A ^ B, clk, A, A_);
    edge_trigger_D_FF Db(reset_n, D, clk, B, B_);
    edge_trigger_D_FF Dc(reset_n, ~(A ^ B), clk, C, C_);
    edge_trigger_D_FF Dd(reset_n, D_ | (A & B_), clk, D, D_);
    
    assign count[3] = A;
    assign count[2] = B;
    assign count[1] = C;
    assign count[0] = D;
    ////////////////////////
	
endmodule
