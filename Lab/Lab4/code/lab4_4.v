/* CSED273 lab4 experiment 4 */
/* lab4_4.v */

/* Implement 5x3 Binary Mutliplier
 * You must use lab4_2 module in lab4_2.v
 * You cannot use fullAdder or halfAdder module directly
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module lab4_4(
    input [4:0]in_a,
    input [2:0]in_b,
    output [7:0]out_m
    );

    ////////////////////////
    wire tmp;
    wire [4:0]tmp_0;
    wire [4:0]tmp_1;
    wire [4:0]tmp_2;
    wire [4:0]tmp_3;
    wire [4:0]tmp_4;
    wire [4:0]tmp_5;

    assign tmp_0[4] = 0;
    assign tmp_0[3] = in_a[4] & in_b[0];
    assign tmp_0[2] = in_a[3] & in_b[0];
    assign tmp_0[1] = in_a[2] & in_b[0];
    assign tmp_0[0] = in_a[1] & in_b[0];
    
    assign tmp_1[4] = in_a[4] & in_b[1];
    assign tmp_1[3] = in_a[3] & in_b[1];
    assign tmp_1[2] = in_a[2] & in_b[1];
    assign tmp_1[1] = in_a[1] & in_b[1];
    assign tmp_1[0] = in_a[0] & in_b[1];

    lab4_2 RA_1(tmp_0, tmp_1, 0, tmp_2, tmp);

    assign tmp_3[4] = tmp;  
    assign tmp_3[3:0] = tmp_2[4:1];

    assign tmp_4[4] = in_a[4] & in_b[2];  
    assign tmp_4[3] = in_a[3] & in_b[2];
    assign tmp_4[2] = in_a[2] & in_b[2];
    assign tmp_4[1] = in_a[1] & in_b[2];
    assign tmp_4[0] = in_a[0] & in_b[2];
     
    lab4_2 RA_2(tmp_3, tmp_4, 0, tmp_5, out_m[7]);

    assign out_m[6] = tmp_5[4];
    assign out_m[5] = tmp_5[3];
    assign out_m[4] = tmp_5[2];
    assign out_m[3] = tmp_5[1];
    assign out_m[2] = tmp_5[0];
    assign out_m[1] = tmp_2[0]; 
    and(out_m[0], in_a[0], in_b[0]);    
    ////////////////////////
    
endmodule