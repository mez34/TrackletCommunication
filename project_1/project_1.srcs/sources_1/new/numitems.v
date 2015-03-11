`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2015 06:12:50 PM
// Design Name: 
// Module Name: numitems
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module statemachine(
    input clk,
    input new_event,
    input [3:0] data_sel
    );
    
    reg wr_en;
    reg [4:0] wr_addr;
    reg [4:0] num_items;
    
    reg [1:0] state, nextstate;
    reg [3:0] data_sel_dly;
    
    parameter [1:0] INIT = 2'b00,
                    hasData = 2'b01,
                    lastData = 2'b10;
    
    always @ (posedge clk) begin
        if (new_event) begin
            state <= INIT;
            data_sel_dly <= 4'b0000;
            num_items <= 4'b0000;
            wr_addr <= 5'b11111;
            wr_en <= 1'b0;
        end
        else begin  //create the state memory
            state <= nextstate;
            data_sel_dly <= data_sel;
        end
    end
    
    always @ (data_sel, state) begin //next-state logic
        case (state)
            INIT :      if (data_sel != 4'b0)           nextstate <= hasData; 
                        //FIXME ASSUMES THAT ALL COMBOS EXCEPT 0000 CORRESPOND TO DATA (NOT TRUE!!)
                        else                            nextstate <= INIT;
            hasData:    if (data_sel == data_sel_dly)   nextstate <= hasData;
                        else                            nextstate <= lastData;
            lastData:   nextstate <= INIT;
            default nextstate <= INIT;
        endcase
    end
    
    always @ (state) begin //output logic
        case (state) 
            INIT :    begin 
                        wr_en <= 1'b0;
                        wr_addr <= 5'b11111;
                        num_items <= 5'b00000;
                      end
            hasData:  begin
                        wr_en <= 1'b1;
                        wr_addr <= wr_addr + 1'b1;
                        num_items <= 5'b00000;
                      end
            lastData: begin
                        wr_en <= 1'b1;
                        wr_addr <= wr_addr + 1'b1;
                        num_items <= wr_addr; //FIXME check that this gives right address or need to add 1
                      end
            default begin
                wr_en <= 1'b0;
                wr_addr <= 5'b11111;
                num_items <= 5'b00000;
            end
        endcase
    end
    
endmodule
