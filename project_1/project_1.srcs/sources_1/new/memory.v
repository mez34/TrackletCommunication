`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2015 04:52:44 PM
// Design Name: 
// Module Name: memory
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

module memory #(parameter RAM_WIDTH = 45, parameter RAM_ADDR_BITS=8, parameter INIT_FILE="/home/user/project_1/testdata.txt")(
    //output
    output reg [RAM_WIDTH-1:0] output_data,
    //inputs
    input wire clock,
    input wire [RAM_ADDR_BITS-1:0] write_address,
    input wire write_enable,
    input wire [RAM_ADDR_BITS-1:0] read_address,
    input wire [RAM_WIDTH-1:0] input_data
);

    //parameter INIT_FILE = "/home/user/project_1/testdata.txt";

(* RAM_STYLE="block" *)
reg [RAM_WIDTH-1:0] RAM [(2**RAM_ADDR_BITS)-1:0];

initial begin
    $readmemh(INIT_FILE,RAM,0,2**RAM_ADDR_BITS-1);
end

always @ (posedge clock) begin
    if (write_enable)
        RAM[write_address] <= input_data;
    output_data <= RAM[read_address];
end

endmodule
