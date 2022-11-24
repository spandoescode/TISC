`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:38:46 11/21/2022
// Design Name:
// Module Name:    lcd_module
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module lcd_module (clk,
                   pipe_state,
                   rst,
                   data,
                   lcd_e,
                   lcd_rw,
                   lcd_rs,
                   SF_CE0);
    input clk;
    input rst;
    input [2:0] pipe_state;
    output wire [3:0] data;   // LCD 4 bit data
    output reg SF_CE0;
    output reg lcd_e;
    output reg lcd_rw;
    output reg lcd_rs;
    
    reg [3:0] lcd_cmd;
    reg [5:0] state = 0;
    reg [2:0] past_data;
	 reg [2:0] current_data;
    
    //reg init_done, disp_done;
    //reg init_done;
    reg [19:0]count = 0;
    
    assign data = lcd_cmd;
    
    initial begin
        past_data = 3'b0;
    end
    
    always @(posedge clk or posedge rst) begin		  
        if (rst) begin
            lcd_e     <= 0;
            //init_done <= 0;
            lcd_rs    <= 0;
            lcd_rw    <= 0;
            SF_CE0    <= 1'b1;  // disable strata enable signal
        end
        else begin
				current_data <= pipe_state;
            case(state)
                0:begin     // IDLE state
                    lcd_e  <= 0;
                    lcd_rw <= 0;
                    lcd_rs <= 0;
                    if (count == 750000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                1:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h3;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                2:begin
                    lcd_e      <= 0;
                    // lcd_cmd <= 4'h3;
                    if (count == 205000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                3:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h3;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                4:begin
                    lcd_e      <= 0;
                    // lcd_cmd <= 4'h3;
                    if (count == 5000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                5:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h3;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                6:begin
                    lcd_e      <= 0;
                    // lcd_cmd <= 4'h3;
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                7:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h2;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                8:begin
                    lcd_e      <= 0;
                    // lcd_cmd <= 4'h3;
                    if (count == 2000) begin
                        count     <= 0;
                        state     <= state + 1;
                        //init_done <= 1;
                    end
                    else
                    count <= count + 1;
                end
                // initialization done
                
                9:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h2;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                10:begin
                    lcd_e <= 0;
                    if (count == 50) begin
                        lcd_e   <= 1;
                        lcd_cmd <= 4'h8;
                        count   <= 0;
                        state   <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                11:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                // end of 8 bit function set command
                12:begin
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                // start of entry mode set command = 06h
                13:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h0;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                14:begin
                    lcd_e <= 0;
                    if (count == 50) begin
                        lcd_e   <= 1;
                        lcd_cmd <= 4'h6;
                        count   <= 0;
                        state   <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                15:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                // end of 8 bit entry mode set command
                
                16:begin
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                // start of display on off command
                
                17:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h0;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                18:begin
                    lcd_e      <= 0;
                    // lcd_cmd <= 4'h0;
                    if (count == 50) begin
                        lcd_e   <= 1;
                        lcd_cmd <= 4'hc;
                        count   <= 0;
                        state   <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                19:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                // end of 8 bit display on off command
                
                20:begin
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                // start of clear display command
                21:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h0;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                22:begin
                    lcd_e <= 0;
                    if (count == 50) begin
                        lcd_e   <= 1;
                        lcd_cmd <= 4'h1;
                        count   <= 0;
                        state   <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                23:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                // end of 8 bit clear display command
                
                24:begin
                    if (count == 82000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                25:begin
                    lcd_e   <= 1;
                    lcd_cmd <= 4'h8;
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                26:begin
                    lcd_e <= 0;
                    if (count == 50) begin
                        lcd_e   <= 1;
                        lcd_cmd <= 4'h0;
                        count   <= 0;
                        state   <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                27:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                28:begin
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                // Display character 1
                
                29:begin
                    lcd_e  <= 1;
                    lcd_rs <= 1;
                    case (past_data)
                        0:lcd_cmd <= 4'h4;
                        1:lcd_cmd <= 4'h4;
                        2:lcd_cmd <= 4'h4;
                        3:lcd_cmd <= 4'h4;
                        4:lcd_cmd <= 4'h4;
                        5:lcd_cmd <= 4'h5;
                    endcase
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                30:begin
                    lcd_e <= 0;
                    if (count == 50) begin
                        lcd_e <= 1;
                        case (past_data)
                            0:lcd_cmd <= 4'h7;
                            1:lcd_cmd <= 4'h9;
                            2:lcd_cmd <= 4'h9;
                            3:lcd_cmd <= 4'h5;
                            4:lcd_cmd <= 4'hD;
                            5:lcd_cmd <= 4'h7;
                        endcase
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                31:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                32:begin
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                // end of 8 bit data transfer
                
                // Display character 0
                
                33:begin
                    lcd_e  <= 1;
                    lcd_rs <= 1;
                    case (past_data)
                        0:lcd_cmd <= 4'h4;
                        1:lcd_cmd <= 4'h4;
                        2:lcd_cmd <= 4'h4;
                        3:lcd_cmd <= 4'h5;
                        4:lcd_cmd <= 4'h4;
                        5:lcd_cmd <= 4'h4;
                    endcase
                    if (count == 12) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                34:begin
                    lcd_e <= 0;
                    if (count == 50) begin
                        lcd_e <= 1;
                        case (past_data)
                            0:lcd_cmd <= 4'hF;
                            1:lcd_cmd <= 4'h6;
                            2:lcd_cmd <= 4'h4;
                            3:lcd_cmd <= 4'h8;
                            4:lcd_cmd <= 4'h5;
                            5:lcd_cmd <= 4'h2;
                        endcase
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                
                35:begin
                    if (count == 12) begin
                        lcd_e <= 0;
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                36:begin
                    if (count == 2000) begin
                        count <= 0;
                        state <= state + 1;
                    end
                    else
                    count <= count + 1;
                end
                
                37: begin
						  lcd_e <= 0;
                    if (past_data != current_data) begin
								lcd_rs <= 0;
								//lcd_rw <= 0;
                        past_data <= current_data;
                        state     <= 6'd19;
                    end
                end
            endcase
            
        end
    end
    
endmodule
    
