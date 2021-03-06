`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2015 04:14:06 PM
// Design Name: 
// Module Name: ProjTransceiver
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


module ProjTransceiver(
   input clk,
   input reset,
   //input en_proc, //what is this?
   // programming interface
   // inputs
   /* input wire io_clk, // programming clock
    input wire io_sel, // this module has been selected for an I/O operation
    input wire io_sync, // start the I/O operation
    input wire [23:0] io_addr, // slave address, memory or register. Top 16 bits already consumed.
    input wire io_rd_en, // this is a read operation
    input wire io_wr_en, // this is a write operation
    input wire [31:0] io_wr_data, // data to write for write operations*/
    // outputs
    //output wire [31:0] io_rd_data, // data returned for read operations
    //output wire io_rd_ack, // 'read' data from this module is ready
    //clocks
    input wire [2:0] BX,
    input wire first_clk,   // actual reset
    //input wire not_first_clk,
    input start,
    output reg done,
    
    input [5:0] number_in1,
    output [5:0] read_add1,
    input [53:0] input_L1L2_1,
    input [5:0] number_in2,
    output [5:0] read_add2,
    input [53:0] input_L1L2_2,
    input [5:0] number_in3,
    output [5:0] read_add3,
    input [53:0] input_L1L2_3,
    input [5:0] number_in4,
    output [5:0] read_add4,
    input [53:0] input_L1L2_4,
    input [5:0] number_in5,
    output [5:0] read_add5,
    input [53:0] input_L3L4_1,
    input [5:0] number_in6,
    output [5:0] read_add6,
    input [53:0] input_L3L4_2,
    input [5:0] number_in7,
    output [5:0] read_add7,
    input [53:0] input_L3L4_3,
    input [5:0] number_in8,
    output [5:0] read_add8,
    input [53:0] input_L3L4_4,
    input [5:0] number_in9,
    output [5:0] read_add9,
    input [53:0] input_L5L6_1,
    input [5:0] number_in10,
    output [5:0] read_add10,
    input [53:0] input_L5L6_2,
    input [5:0] number_in11,
    output [5:0] read_add11,
    input [53:0] input_L5L6_3,
    input [5:0] number_in12,
    output [5:0] read_add12,
    input [53:0] input_L5L6_4,
    
    output [53:0] output_L1L2_1,
    output [53:0] output_L1L2_2,
    output [53:0] output_L1L2_3,
    output [53:0] output_L1L2_4,
    output [53:0] output_L3L4_1,
    output [53:0] output_L3L4_2,
    output [53:0] output_L3L4_3,
    output [53:0] output_L3L4_4,
    output [53:0] output_L5L6_1,
    output [53:0] output_L5L6_2,
    output [53:0] output_L5L6_3,
    output [53:0] output_L5L6_4
);


    parameter [7:0] n_hold = 8'd3;
    reg [6:0] clk_cnt;
    reg [2:0] BX_pipe;
    reg first_clk_pipe;
    
    wire done_sending_proj;
    
    wire valid;
    reg valid_dly;
    wire [47:0] mem_dat_stream; //priority encoded data stream from the 12 memories
    reg [47:0] mem_dat_stream_dly;
    wire [47:0] data_output_fifo1;    //same memory stream but now coming from the 1st FIFO
    reg [47:0] data_output_fifo1_dly;
    wire [47:0] data_output_fifo2;    //same memory stream but not coming from the 2nd FIFO
    
    wire [3:0] output_BX;
    wire sent_BX;

    // FIFO internal outputs
    reg fifo_rst;                // reset fifo after each new_event
    reg fifo_rst1;               // hold fifo reset
    reg fifo_rst2;               // hold fifo reset
    reg fifo_rst3;               // hold fifo reset
    reg fifo_rst4;               // hold fifo reset
    reg fifo_rst5;               // hold fifo reset
    reg FIFO_wr_en;              // FIFO write enable from valid
    reg FIFO_rd_en;              // FIFO read enable (always valid after reset)
    reg fifo_rst_dly1;
    reg fifo_rst_dly2;
    wire FIFO1_EMPTY,FIFO1_FULL;
    
    //2nd FIFO internal connects
    reg FIFO_wr_en_2;
    wire FIFO2_EMPTY,FIFO2_FULL;


    mem_readout_top_2 send_proj(
        .clk(clk),                  // main clock
        .reset(reset),              // synchronously negated active-hi reset  RESET IS ACTUALLY START OF BX
        .BX(BX),                    // BX number
        .clk_cnt(clk_cnt),          // clock cylces gone by in BX
        .BX_pipe(BX_pipe),
        
        .number_in1(number_in1),          // starting number of items for this memory
        .number_in2(number_in2),          // starting number of items for this memory
        .number_in3(number_in3),          // starting number of items for this memory
        .number_in4(number_in4),          // starting number of items for this memory
        .number_in5(number_in5),          // starting number of items for this memory
        .number_in6(number_in6),          // starting number of items for this memory
        .number_in7(number_in7),          // starting number of items for this memory
        .number_in8(number_in8),          // starting number of items for this memory
        .number_in9(number_in9),          // starting number of items for this memory
        .number_in10(number_in10),          // starting number of items for this memory
        .number_in11(number_in11),          // starting number of items for this memory
        .number_in12(number_in12),          // starting number of items for this memory
        
        .input_L1L2_1(input_L1L2_1[43:0]),     
        .input_L1L2_2(input_L1L2_2[43:0]),     
        .input_L1L2_3(input_L1L2_3[43:0]),     
        .input_L1L2_4(input_L1L2_4[43:0]),     
        .input_L3L4_1(input_L3L4_1[43:0]),     
        .input_L3L4_2(input_L3L4_2[43:0]),     
        .input_L3L4_3(input_L3L4_3[43:0]),     
        .input_L3L4_4(input_L3L4_4[43:0]),  
        .input_L5L6_1(input_L5L6_1[43:0]),
        .input_L5L6_2(input_L5L6_2[43:0]),
        .input_L5L6_3(input_L5L6_3[43:0]),
        .input_L5L6_4(input_L5L6_4[43:0]),   
        
        .read_add1(read_add1),          // lower part of memory address
        .read_add2(read_add2),          // lower part of memory address
        .read_add3(read_add3),          // lower part of memory address
        .read_add4(read_add4),          // lower part of memory address
        .read_add5(read_add5),          // lower part of memory address
        .read_add6(read_add6),          // lower part of memory address
        .read_add7(read_add7),          // lower part of memory address
        .read_add8(read_add8),          // lower part of memory address
        .read_add9(read_add9),          // lower part of memory address
        .read_add10(read_add10),          // lower part of memory address
        .read_add11(read_add11),          // lower part of memory address
        .read_add12(read_add12),          // lower part of memory address
        
        .mem_dat_stream(mem_dat_stream),
        .valid(valid),
        .send_BX(send_BX),
        .none(done_sending_proj)                 // no more items
    );


    always @ (posedge clk) begin
        //if (first_clk) FIFO_wr_en <= 1'b0;
        fifo_rst1 <= first_clk;
        fifo_rst2 <= fifo_rst1;
        fifo_rst3 <= fifo_rst2;
        fifo_rst4 <= fifo_rst3;
        fifo_rst5 <= fifo_rst4;
        fifo_rst <= ( first_clk || fifo_rst1 || fifo_rst2 || fifo_rst3 || fifo_rst4 || fifo_rst5 );
        fifo_rst_dly1 <= fifo_rst;
        fifo_rst_dly2 <= fifo_rst_dly1;
        valid_dly <= valid;
        FIFO_wr_en <= (valid_dly || send_BX);        //delay on the valid signal because data is off by one clock tick
       // if (!first_clk) FIFO_wr_en <= (valid_dly || send_BX);        //delay on the valid signal because data is off by one clock tick
        FIFO_rd_en <= (!fifo_rst && !fifo_rst_dly1 && !fifo_rst_dly2);
        mem_dat_stream_dly <= mem_dat_stream;
        data_output_fifo1_dly <= data_output_fifo1;
        
        if ( data_output_fifo1[47:44] != 4'b0000 ) FIFO_wr_en_2 <= 1'b1;
        else FIFO_wr_en_2 <= 1'b0;
    end

    /////////////////////////////////////////////////////////////////////
    // send the mem_dat_stream to a dualclock FIFO
    fifo_projection_out fifo1(
        .rst(fifo_rst),                             // 1 bit in data reset
        .wr_clk(clk),                               // 1 bit in write clock
        .rd_clk(clk),                               // 1 bit in read clock
        .din(mem_dat_stream_dly),                   // 48 bit in data into FIFO
        .wr_en(FIFO_wr_en),                         // 1 bit in write enable
        .rd_en(FIFO_rd_en),                         // 1 bit in read enable
        .dout(data_output_fifo1),                         // 48 bit out data out of FIFO
        .full(FIFO1_FULL),                           // 1 bit out FIFO full signal
        .empty(FIFO1_EMPTY)                          // 1 bit out FIFO empty signal
     );
      
     fifo_projection_out fifo2(
         .rst(fifo_rst),                             // 1 bit in data reset
         .wr_clk(clk),                               // 1 bit in write clock
         .rd_clk(clk),                               // 1 bit in read clock
         .din(data_output_fifo1_dly),               // 48 bit in data into FIFO
         .wr_en(FIFO_wr_en_2),                       // 1 bit in write enable
         .rd_en(FIFO_rd_en),                         // 1 bit in read enable
         .dout(data_output_fifo2),                   // 48 bit out data out of FIFO
         .full(FIFO2_FULL),                          // 1 bit out FIFO full signal
         .empty(FIFO2_EMPTY)                         // 1 bit out FIFO empty signal
      );      



    mem_readin_top get_resid(
        .clk(clk),
        .reset(reset),
        .data_residuals(data_output_fifo2),
        .datanull(FIFO2_EMPTY),
        
        .output_BX(output_BX),
        .send_BX(BX_sent),
        
        .output_L1L2_1(output_L1L2_1), //returning residuals for this memory
        .output_L1L2_2(output_L1L2_2), //returning residuals for this memory
        .output_L1L2_3(output_L1L2_3), //returning residuals for this memory
        .output_L1L2_4(output_L1L2_4), //returning residuals for this memory
        .output_L3L4_1(output_L3L4_1), //returning residuals for this memory
        .output_L3L4_2(output_L3L4_2), //returning residuals for this memory
        .output_L3L4_3(output_L3L4_3), //returning residuals for this memory
        .output_L3L4_4(output_L3L4_4), //returning residuals for this memory
        .output_L5L6_1(output_L5L6_1), //returning residuals for this memory        
        .output_L5L6_2(output_L5L6_2), //returning residuals for this memory  
        .output_L5L6_3(output_L5L6_3), //returning residuals for this memory  
        .output_L5L6_4(output_L5L6_4) //returning residuals for this memory 
        
    );








    
    initial begin
        clk_cnt = 7'b0;
        BX_pipe = 3'b111;
    end
    
    /*always @(posedge clk) begin
        if(en_proc)
        clk_cnt <= clk_cnt + 1'b1;
        else begin
        clk_cnt <= 7'b0;
        BX_pipe <= 3'b111;
        end
        if(start) begin
        BX_pipe <= BX_pipe + 1'b1;
        first_clk_pipe <= 1'b1;
        end
        else begin
        first_clk_pipe <= 1'b0;
        end
    end */
    
    reg [n_hold:0] hold;
    
    always @(posedge clk) begin
        hold[0] <= start;
        hold[n_hold:1] <= hold[n_hold-1:0];
        done <= hold[n_hold];
    end
    
    reg [2:0] test_hold1;
    reg [2:0] test_hold2;
    reg [2:0] test_hold3;
    reg [2:0] test_hold4;
    reg [2:0] test_hold5;
    reg [2:0] test_hold6;
    reg [2:0] test_hold7;
    reg [2:0] test_hold8;
    reg [2:0] test_hold9;
    
    always @(posedge clk) begin
        test_hold1 <= BX_pipe;
        test_hold2 <= test_hold1;
        test_hold3 <= test_hold2;
        test_hold4 <= test_hold3;
        test_hold5 <= test_hold4;
        test_hold6 <= test_hold5;
        test_hold7 <= test_hold6;
        test_hold8 <= test_hold7;
        test_hold9 <= test_hold8;
    end
    

endmodule
