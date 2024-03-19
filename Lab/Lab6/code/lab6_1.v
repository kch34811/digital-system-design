/* CSED273 lab6 experiment 1 */
/* lab6_1.v */

`timescale 1ps / 1fs

/* Implement synchronous BCD decade counter (0-9)
 * You must use JK flip-flop of lab6_ff.v */
module decade_counter(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    wire A, A_, B, B_, C, C_, D, D_;
    edge_trigger_JKFF JK_A(reset_n, B & C & D, D, clk, A, A_);
    edge_trigger_JKFF JK_B(reset_n, C & D, C & D, clk, B, B_);
    edge_trigger_JKFF JK_C(reset_n, A_ & D, D, clk, C, C_);
    edge_trigger_JKFF JK_D(reset_n, 1, 1, clk, D, D_);
    
    assign count[3] = A;
    assign count[2] = B;
    assign count[1] = C;
    assign count[0] = D;
    ////////////////////////
	
endmodule