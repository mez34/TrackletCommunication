`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2015 12:17:48 PM
// Design Name: 
// Module Name: chop_data_stream
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


module chop_data_stream(
    input clk,
    input reset,
    input no_data,
    input [47:0] data_in,
    
    output reg [15:0] data_out
);
    reg [47:0] data_dly1,data_dly2,data_dly3;
    reg [1:0] count;

    reg [2:0] state, nextstate;
    
    parameter [2:0] init = 3'h0,
                    head = 3'h4,
                    dat1 = 3'h1,
                    dat2 = 3'h3,
                    dat3 = 3'h2;

    //split data with a FSM
    always @ (posedge clk) begin
        if (reset) begin
            state <= init;
        end
        else state <= nextstate;
    end

    always @ (nextstate,data_in) begin
        case (state)
            init : if (data_in[47:32]==4'hF) nextstate <= start;
                   else if (data_in[47:32]==4'h0) nextstate <= init;
                   else nextstate <= dat1;
            start : nextstate <= init;
            dat1 : nextstate <= dat2;
            dat2 : nextstate <= dat3;
            dat3 : nextstate <= init;
        endcase
    end
    
    always @ (state) begin
        case (state)
            init : data_out <= 16'h0000;
            start : data_out <= {4'hF,data_in[47:44],9'h000};
            dat1 : data_out <= data_in[47:32];
            dat2 : data_out <= data_in[31:16];
            dat3 : data_out <= data_in[15:0];
            default data_out <= 16'h0000;
        endcase
    end


    /* always @ (posedge clk) begin
        if (reset) begin
            data_out <= 16'h0000;
            count <= 2'b11;
        end
        else begin
            if (no_data) begin
                data_out <= 16'h0000;
                count <= 2'b11;
            end
            else begin
                if (data_in[47:44]==4'hF) begin
                    count <= 2'b11;
                    data_out <= {4'hF,data_in[43:41],9'b0};
                end
                else begin
                    data_dly1 <= data_in;
                    data_dly2 <= data_dly1;
                    data_dly3 <= data_dly2;
                    count <= count + 1'b1;
                    if (count == 2'b00) data_out <= data_in[47:32];
                    if (count == 2'b01) data_out <= data_dly1[31:16];
                    if (count == 2'b10) data_out <= data_dly2[15:0];
                end
            end
        end
    end */

endmodule
