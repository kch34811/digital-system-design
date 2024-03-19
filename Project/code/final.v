`timescale 1ns / 1ps

module Final_project(   input [1:0] Switch_Input,
                        input CLK,
                        input Enable,
                        input RESET,
                        output LED_RED_1, LED_RED_2, LED_GREEN_1, LED_GREEN_2, LED_GREEN_3, LED_GREEN_4,
                        output LED_WHITE,
                        output [0:3] ssSel,
                        output [0:7] ssDisp);

    wire [3:0] ABCD;
    wire Display_Score_situ;
    wire Display_Winner_situ;
    wire Display_Invalid_situ;
    wire [7:0] Display_Score_Enable;
    wire [7:0] Display_Winner_Enable;
    wire [7:0] Display_Invalid_Enable;

    wire [0:7] ssDisp_0; 
    wire [0:7] ssDisp_1; 
    wire [0:7] ssDisp_2;
    wire [0:7] ssDisp_3;

    wire [0:7] ssDisp_S_0; 
    wire [0:7] ssDisp_S_1; 
    wire [0:7] ssDisp_S_2;
    wire [0:7] ssDisp_S_3;
    
    wire [0:7] ssDisp_W_0; 
    wire [0:7] ssDisp_W_1; 
    wire [0:7] ssDisp_W_2;
    wire [0:7] ssDisp_W_3;

    wire [0:7] ssDisp_I_0; 
    wire [0:7] ssDisp_I_1; 
    wire [0:7] ssDisp_I_2;
    wire [0:7] ssDisp_I_3;

    assign ssDisp_0 = ssDisp_S_0 & ssDisp_W_0 & ssDisp_I_0;
    assign ssDisp_1 = ssDisp_S_1 & ssDisp_W_1 & ssDisp_I_1;
    assign ssDisp_2 = ssDisp_S_2 & ssDisp_W_2 & ssDisp_I_2;
    assign ssDisp_3 = ssDisp_S_3 & ssDisp_W_3 & ssDisp_I_3;

    FSM fsm(Enable, RESET, Switch_Input, ABCD);

    assign Display_Score_situ = (ABCD[1] | (~ABCD[2] & ABCD[0])) & ~(Switch_Input[1] & Switch_Input[0]);
    assign Display_Winner_situ = ~ABCD[3] & ~ABCD[1] & ~ABCD[0] & ~(Switch_Input[1] & Switch_Input[0]);
    assign Display_Invalid_situ = Switch_Input[1] & Switch_Input[0];
    assign Display_Score_Enable = {Display_Score_situ, Display_Score_situ, Display_Score_situ, Display_Score_situ, Display_Score_situ, Display_Score_situ, Display_Score_situ, Display_Score_situ};
    assign Display_Winner_Enable = {Display_Winner_situ, Display_Winner_situ, Display_Winner_situ, Display_Winner_situ, Display_Winner_situ, Display_Winner_situ, Display_Winner_situ, Display_Winner_situ};
    assign Display_Invalid_Enable = {Display_Invalid_situ, Display_Invalid_situ, Display_Invalid_situ, Display_Invalid_situ, Display_Invalid_situ, Display_Invalid_situ, Display_Invalid_situ, Display_Invalid_situ};

    DisplayScore ds(CLK, Display_Score_Enable, ABCD, ssDisp_S_0, ssDisp_S_1, ssDisp_S_2, ssDisp_S_3);
    DisplayWinner dw(CLK, RESET, Display_Winner_Enable, ABCD[2], ssDisp_W_0, ssDisp_W_1, ssDisp_W_2, ssDisp_W_3);
    DisplayInvalid di(CLK, RESET, Display_Invalid_Enable, ssDisp_I_0, ssDisp_I_1, ssDisp_I_2, ssDisp_I_3);
    
    Display dis(CLK, RESET, ssDisp_0, ssDisp_1, ssDisp_2, ssDisp_3, ssSel, ssDisp);

    //Game termination
    wire mWin, cWin;
    assign mWin = ~ABCD[3] & ~ABCD[2] & ~ABCD[1] & ~ABCD[0];
    assign cWin = ~ABCD[3] & ABCD[2] & ~ABCD[1] & ~ABCD[0];

    //Display of Mafia 
    assign LED_RED_1 = ~cWin;
    assign LED_RED_2 = ~cWin & ABCD[2] | mWin;

    //Display of Citizen
    assign LED_GREEN_1 = ~mWin;
    assign LED_GREEN_2 = ~mWin;
    assign LED_GREEN_3 = ~mWin & ABCD[1] | cWin;
    assign LED_GREEN_4 = ~mWin & ABCD[1] & ABCD[0] | cWin;

    //Display of Day of Night
    assign LED_WHITE = ABCD[3];

endmodule