`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2015 03:07:16 PM
// Design Name: 
// Module Name: header
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


module header(
    input clk,
    input new_event,              // start over
    input [2:0] BX,                // store BX
    input [6:0] clk_cnt,           // counter for # of clock cycles in processing BX
    input [2:0] BX_pipe,           // if clk_cnt reaches 7'b1, increment BX_pipe
    input [5:0] addr,
    input has_data,
    input [3:0] sel,
    input [5:0] num,
    //output header into datastream
    output reg [44:0] header_stream
);

    always @ (posedge clk) begin
        $display("BX = %h, clk_cnt = %h, sel = %h, num = %h",BX,clk_cnt,sel,num);
        //header_stream <= {5'h0,BX[2:0],1'b0,clk_cnt[6:0],2'b00,sel[3:0],num,2'b0};
        header_stream <= 45'hFFFFFFFFFFF;
    end

endmodule
