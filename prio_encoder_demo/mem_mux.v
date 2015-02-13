// Mux to route data from the port that is currently selected

`timescale 1ns / 1ps

module mem_mux(
    input clk,
    input [3:0] sel,   // binary encoded
    input [44:0] mem_dat00,
    input [44:0] mem_dat01,
    input [44:0] mem_dat02,
    input [44:0] mem_dat03,
    input [44:0] mem_dat04,
    input [44:0] mem_dat05,
    input [44:0] mem_dat06,
    input [44:0] mem_dat07,
    input [44:0] mem_dat08,
    input [44:0] mem_dat09,
    input [44:0] mem_dat10,
    input [44:0] mem_dat11,
    //input [44:0] header_stream,
    
    output reg [44:0] mem_dat_stream                       
);

//////////////////////////////////////////////////////////////////////////
// Implement an 8:1 mux. This works better with with an encoded 'select'
// as compared to individual 'select' signals.
always @ (posedge clk) begin
    case (sel[3:0])
        4'b0000: mem_dat_stream <= mem_dat00;
        4'b0001: mem_dat_stream <= mem_dat01;
        4'b0010: mem_dat_stream <= mem_dat02;
        4'b0011: mem_dat_stream <= mem_dat03;
        4'b0100: mem_dat_stream <= mem_dat04;
        4'b0101: mem_dat_stream <= mem_dat05;
        4'b0110: mem_dat_stream <= mem_dat06;
        4'b0111: mem_dat_stream <= mem_dat07;
        4'b1000: mem_dat_stream <= mem_dat08;
        4'b1001: mem_dat_stream <= mem_dat09;
        4'b1011: mem_dat_stream <= mem_dat10;
        4'b1100: mem_dat_stream <= mem_dat11;
        //4'b1111: mem_dat_stream <= header_stream;
    endcase
end

endmodule
