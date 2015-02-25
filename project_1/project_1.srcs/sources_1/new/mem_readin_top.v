`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2015 02:18:28 PM
// Design Name: 
// Module Name: mem_readin_top
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

module mem_readin_top(
    input clk,                    // main clock
    input new_event,              // start over
    input [51:0] data_residuals   // data out from neighboring sector, from FIFO (would be residuals)
);
    reg [3:0] memory_addr;
    reg [4:0] write_addr;
    reg new_event_dly1, new_event_dly2;
    
    //wr_en (write enables for the 12 memories) & write_addr (write addresses for the 12 memories) & item counter for each memory
    reg wr_en_mem00, wr_en_mem01, wr_en_mem02, wr_en_mem03, wr_en_mem04, wr_en_mem05, wr_en_mem06, wr_en_mem07, wr_en_mem08, wr_en_mem09, wr_en_mem10, wr_en_mem11;
    reg [4:0] write_addr00, write_addr01, write_addr02, write_addr03, write_addr04, write_addr05, write_addr06, write_addr07, write_addr08, write_addr09, write_addr10, write_addr11;
    reg [5:0] num_items00, num_items01, num_items02, num_items03, num_items04, num_items05, num_items06, num_items07, num_items08, num_items09, num_items10, num_items11;
    
    always @ (posedge clk) begin //delay initalization
        new_event_dly1 <= new_event;
        new_event_dly2 <= new_event_dly1;
        $display ("BX: %b",data_residuals[51:49]);
        $display ("SEL: %b",data_residuals[48:45]);
        $display ("data: %h",data_residuals[44:0]);
        $display ("wr_en_mem00: %b",wr_en_mem00);
        $display ("write_addr00: %b",write_addr00);
    end
    
        
    always @ (posedge clk) begin
        if (new_event_dly2) begin // initialize variables 
            // set all item counters to zero
            num_items00 <= 6'b0;
            num_items01 <= 6'b0;
            num_items02 <= 6'b0;
            num_items03 <= 6'b0;
            num_items04 <= 6'b0;
            num_items05 <= 6'b0;
            num_items06 <= 6'b0;
            num_items07 <= 6'b0;
            num_items08 <= 6'b0;
            num_items09 <= 6'b0;
            num_items10 <= 6'b0;
            num_items11 <= 6'b0;
            // set all write enables to zero  
            wr_en_mem00 <= 1'b0;
            wr_en_mem01 <= 1'b0;
            wr_en_mem02 <= 1'b0;
            wr_en_mem03 <= 1'b0;
            wr_en_mem04 <= 1'b0;
            wr_en_mem05 <= 1'b0;
            wr_en_mem06 <= 1'b0;
            wr_en_mem07 <= 1'b0;
            wr_en_mem08 <= 1'b0;
            wr_en_mem09 <= 1'b0;
            wr_en_mem10 <= 1'b0;
            wr_en_mem11 <= 1'b0;
            // set all write addresses to zero      
            write_addr00 <= 5'b0;
            write_addr01 <= 5'b0;
            write_addr02 <= 5'b0;
            write_addr03 <= 5'b0;
            write_addr04 <= 5'b0;
            write_addr05 <= 5'b0;
            write_addr06 <= 5'b0;
            write_addr07 <= 5'b0;
            write_addr08 <= 5'b0;
            write_addr09 <= 5'b0;
            write_addr10 <= 5'b0;
            write_addr11 <= 5'b0;
        end
    end
    
    always @ (posedge clk) begin
        // use the 4 bits containing memory information and set a write enable for the memory it should be sent to
        // also increment the write_addr for that memory so that data does not overwrite itself 
        case (data_residuals[48:45])
             4'b0001: begin 
                wr_en_mem00 <= 1'b1;
                write_addr00 <= write_addr00 + 1'b1;
                num_items00 <= num_items00 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b0010: begin
                wr_en_mem01 <= 1'b1;
                write_addr01 <= write_addr01 + 1'b1;
                num_items01 <= num_items01 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b0011: begin
                wr_en_mem02 <= 1'b1;
                write_addr02 <= write_addr02 + 1'b1;
                num_items02 <= num_items02 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b0100: begin
                wr_en_mem03 <= 1'b1;
                write_addr03 <= write_addr03 + 1'b1;
                num_items03 <= num_items03 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b0101: begin
                wr_en_mem04 <= 1'b1;
                write_addr04 <= write_addr04 + 1'b1;
                num_items04 <= num_items04 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b0110: begin
                wr_en_mem05 <= 1'b1;
                write_addr05 <= write_addr05 + 1'b1;
                num_items05 <= num_items05 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b0111: begin
                wr_en_mem06 <= 1'b1;
                write_addr06 <= write_addr06 + 1'b1;
                num_items06 <= num_items06 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b1000: begin
                wr_en_mem07 <= 1'b1;
                write_addr07 <= write_addr07 + 1'b1;
                num_items07 <= num_items07 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b1001: begin
                wr_en_mem08 <= 1'b1;
                write_addr08 <= write_addr08 + 1'b1;
                num_items08 <= num_items08 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b1011: begin
                wr_en_mem09 <= 1'b1;
                write_addr09 <= write_addr09 + 1'b1;
                num_items09 <= num_items09 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b1100: begin
                wr_en_mem10 <= 1'b1;
                write_addr10 <= write_addr10 + 1'b1;
                num_items10 <= num_items10 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
             4'b1101: begin
                wr_en_mem11 <= 1'b1;
                write_addr11 <= write_addr11 + 1'b1;
                num_items11 <= num_items11 + 1'b1;
                // set other memory write enables to zero.
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
             end
             default begin
                num_items00 <= 6'b0;
                num_items01 <= 6'b0;
                num_items02 <= 6'b0;
                num_items03 <= 6'b0;
                num_items04 <= 6'b0;
                num_items05 <= 6'b0;
                num_items06 <= 6'b0;
                num_items07 <= 6'b0;
                num_items08 <= 6'b0;
                num_items09 <= 6'b0;
                num_items10 <= 6'b0;
                num_items11 <= 6'b0;
                write_addr00 <= 5'b0;
                write_addr01 <= 5'b0;
                write_addr02 <= 5'b0;
                write_addr03 <= 5'b0;
                write_addr04 <= 5'b0;
                write_addr05 <= 5'b0;
                write_addr06 <= 5'b0;
                write_addr07 <= 5'b0;
                write_addr08 <= 5'b0;
                write_addr09 <= 5'b0;
                write_addr10 <= 5'b0;
                write_addr11 <= 5'b0;
                wr_en_mem00 <= 1'b0;
                wr_en_mem01 <= 1'b0;
                wr_en_mem02 <= 1'b0;
                wr_en_mem03 <= 1'b0;
                wr_en_mem04 <= 1'b0;
                wr_en_mem05 <= 1'b0;
                wr_en_mem06 <= 1'b0;
                wr_en_mem07 <= 1'b0;
                wr_en_mem08 <= 1'b0;
                wr_en_mem09 <= 1'b0;
                wr_en_mem10 <= 1'b0;
                wr_en_mem11 <= 1'b0;
             end
        endcase
    end

    //////////////////////////////////////////////////////////////
    // write out the data from data_stream to memory
    memory storeinMem00( .output_data(final_residuals), .clock(clk), .write_address(write_addr00), .write_enable(wr_en_mem00), 
        .read_address(5'b00000), .input_data({data_residuals[51:49],data_residuals[44:0]}) );
/*    memory storeinMem01( .output_data(final_residuals), .clock(clk), .write_address(write_addr01), .write_enable(wr_en_mem01), 
        .read_address(5'b00000), .input_data({data_residuals[51:49],data_residuals[44:0]}) );
    memory storeinMem02( .output_data(final_residuals), .clock(clk), .write_address(write_addr02), .write_enable(wr_en_mem02), 
        .read_address(5'b00000), .input_data({data_residuals[51:49],data_residuals[44:0]}) );
*/

        
endmodule
