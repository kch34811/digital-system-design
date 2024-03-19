/* CSED273 lab6 experiment 2 */
/* lab6_2.v */

`timescale 1ps / 1fs

/* Implement 2-decade BCD counter (0-99)
 * You must use decade BCD counter of lab6_1.v */
module decade_counter_2digits(input reset_n, input clk, output [7:0] count);

    ////////////////////////
    wire [3:0] A, B;
    decade_counter COUNTER_A(reset_n, clk, A);
    decade_counter COUNTER__B(reset_n, A[3], B);
    
    assign count [7:4] = B;
    assign count [3:0] = A;
    ////////////////////////
	
endmodule
