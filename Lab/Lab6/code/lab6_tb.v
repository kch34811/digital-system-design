/* CSED273 lab6 experiments */
/* lab6_tb.v */

`timescale 1ps / 1fs

module lab6_tb();

    integer Passed;
    integer Failed;

    /* Define input, output and instantiate module */
    ////////////////////////
    reg reset_n_1; 
    reg reset_n_2;
    reg reset_n_3; 
    reg clk_1; 
    reg clk_2; 
    reg clk_3;
    wire[3:0] count_1;
    wire [7:0] count_2; 
    wire [3:0] count_3;
    
    decade_counter DC(
        .reset_n(reset_n_1), 
        .clk(clk_1), 
        .count(count_1)
    );
    
    decade_counter_2digits DC2(
        .reset_n(reset_n_2), 
        .clk(clk_2), 
        .count(count_2)
    );
    
    counter_369 C369(
        .reset_n(reset_n_3), 
        .clk(clk_3), 
        .count(count_3)
    );

    always begin
        #1 clk_1 = ~clk_1;
        clk_2 = ~clk_2;
        clk_3 = ~clk_3;
    end
    ////////////////////////

    initial begin
        clk_1 = 1;
        reset_n_1 = 0;
        clk_2 = 1;
        reset_n_2 = 0;
        clk_3 = 1;
        reset_n_3 = 0;
        
        Passed = 0;
        Failed = 0;

        lab6_1_test;
        lab6_2_test;
        lab6_3_test;

        $display("Lab6 Passed = %0d, Failed = %0d", Passed, Failed);
        $finish;
    end

    /* Implement test task for lab6_1 */
    task lab6_1_test;
        ////////////////////////
        begin
        #1 reset_n_1 = 0;
        #1 reset_n_1 = 1;
        #20;
        #1 reset_n_1 = 0;
        #1 reset_n_1 = 1;
        #10;
        #1 reset_n_1 = 0;
        #1 reset_n_1 = 1;
        #5;
        #1 reset_n_1 = 0;
        #1 reset_n_1 = 1;
        end
        ////////////////////////
    endtask

    /* Implement test task for lab6_2 */
    task lab6_2_test;
        ////////////////////////      
        begin
        #50;
        #1 reset_n_2 = 0;
        #1 reset_n_2 = 1;
        end
        ////////////////////////
    endtask

    /* Implement test task for lab6_3 */
    task lab6_3_test;
        ////////////////////////
        begin
        #150;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #8;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #7;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #6;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #5;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #4;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #3;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #2;
        #1 reset_n_3 = 0;
        #1 reset_n_3 = 1;
        #1;
        #1 reset_n_3 = 0;
        end
    endtask

endmodule