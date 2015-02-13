// This module merges the data from a set of memories into a single stream.
// A 'valid' bit is asserted along with each word of valid data.
//
// The connections for each memory are (where 'xx' is replaced by sequential numbers):
//  1) (IN)  itemsxx - A register which holds the number of words to read from that memory.
//  2) (OUT) addrxx - The current address from which to read data. This is the low part of the address
//           from a counter. The high part of the address is the crossing number. 
//  3) (IN)  mem_datxx - The data from the current address.
//
// The global connections are:
//  1) (IN) clk - The processing clock responsible for gathering the data
//  2) (IN) new_event - A signal to start processing the next event. It is
//          a pulse with the duration of a single clock period.
//  3) (OUT) mem_dat_stream - A single stream of data from the various memories.
//           The stream is not contiguous; there are gaps
//  4) (OUT) valid - A bit that indicates that the current "mem_dat_stream" value
//           contains valid data.
//  5) (OUT) done - A bit that indicates that there is no more data to process.
//           Currently not asserted if data processing does not finish before the
//           next event.
 
`timescale 1ns / 1ps

module mem_readout_top(
    input clk,                    // main clock
    input new_event,              // start over
    input [2:0] BX,                // store BX
    input [6:0] clk_cnt,           // counter for # of clock cycles in processing BX
    input [2:0] BX_pipe,           // if clk_cnt reaches 7'b1, increment BX_pipe
 
    // A memory block
    input [5:0] items00,          // starting number of items for this memory
    output [5:0] addr00,          // memory address
    input [44:0] mem_dat00,       // contents of this memory
    // A memory block
    input [5:0] items01,          // starting number of items for this memory
    output [5:0] addr01,          // memory address
    input [44:0] mem_dat01,       // contents of this memory
    // A memory block
    input [5:0] items02,          // starting number of items for this memory
    output [5:0] addr02,          // memory address
    input [44:0] mem_dat02,       // contents of this memory
    // A memory block
    input [5:0] items03,          // starting number of items for this memory
    output [5:0] addr03,          // memory address
    input [44:0] mem_dat03,       // contents of this memory
    // A memory block
    input [5:0] items04,          // starting number of items for this memory
    output [5:0] addr04,          // memory address
    input [44:0] mem_dat04,       // contents of this memory
    // A memory block
    input [5:0] items05,          // starting number of items for this memory
    output [5:0] addr05,          // memory address
    input [44:0] mem_dat05,       // contents of this memory
    // A memory block
    input [5:0] items06,          // starting number of items for this memory
    output [5:0] addr06,          // memory address
    input [44:0] mem_dat06,       // contents of this memory
    // A memory block
    input [5:0] items07,          // starting number of items for this memory
    output [5:0] addr07,          // memory address
    input [44:0] mem_dat07,       // contents of this memory
    // A memory block
    input [5:0] items08,          // starting number of items for this memory
    output [5:0] addr08,          // memory address
    input [44:0] mem_dat08,       // contents of this memory
    // A memory block
    input [5:0] items09,          // starting number of items for this memory
    output [5:0] addr09,          // memory address
    input [44:0] mem_dat09,       // contents of this memory
    // A memory block
    input [5:0] items10,          // starting number of items for this memory
    output [5:0] addr10,          // memory address
    input [44:0] mem_dat10,       // contents of this memory
    // A memory block
    input [5:0] items11,          // starting number of items for this memory
    output [5:0] addr11,          // memory address
    input [44:0] mem_dat11,       // contents of this memory

    //output [44:0] header_stream,   // headers for sent data 
    output [51:0] mem_dat_stream, // merged memory data stream
    output reg valid,             // valid data in merged memory stream
    output none                   // no more data

);

// Internal interconnects
wire has_dat00, has_dat01, has_dat02, has_dat03, has_dat04, has_dat05, has_dat06, has_dat07, has_dat08, has_dat09, has_dat10, has_dat11;
wire first_dat;
wire valid00, valid01, valid02, valid03, valid04, valid05, valid06, valid07, valid08, valid09, valid10, valid11;
wire [3:0] sel;
wire [44:0] header_stream;

// When 'new_event' is asserted, terminate the current processing and get
// set up for the new event. This requires that we holdoff on any output
// for several clock periods. 
reg new_event_dly1, new_event_dly2;
always @(posedge clk) begin
    new_event_dly1 <= new_event;
    new_event_dly2 <= new_event_dly1;
end
// Use these clock periods to prepare to process the new event
assign setup = new_event | new_event_dly1 | new_event_dly2;

// connect address and item counters, as well as comparitors, for each memory
prio_support prio_support00(.clk(clk), .initial_count(items00), .init(new_event), .sel(sel00), 
    .setup(setup), .addr(addr00[5:0]), .has_dat(has_dat00), .valid(valid00), .first_dat(first_dat) );
prio_support prio_support01(.clk(clk), .initial_count(items01), .init(new_event), .sel(sel01), 
    .setup(setup), .addr(addr01[5:0]), .has_dat(has_dat01), .valid(valid01), .first_dat(first_dat) );
prio_support prio_support02(.clk(clk), .initial_count(items02), .init(new_event), .sel(sel02), 
    .setup(setup), .addr(addr02[5:0]), .has_dat(has_dat02), .valid(valid02), .first_dat(first_dat) );
prio_support prio_support03(.clk(clk), .initial_count(items03), .init(new_event), .sel(sel03), 
    .setup(setup), .addr(addr03[5:0]), .has_dat(has_dat03), .valid(valid03), .first_dat(first_dat) );
prio_support prio_support04(.clk(clk), .initial_count(items04), .init(new_event), .sel(sel04), 
    .setup(setup), .addr(addr04[5:0]), .has_dat(has_dat04), .valid(valid04), .first_dat(first_dat) );
prio_support prio_support05(.clk(clk), .initial_count(items05), .init(new_event), .sel(sel05), 
    .setup(setup), .addr(addr05[5:0]), .has_dat(has_dat05), .valid(valid05), .first_dat(first_dat) );
prio_support prio_support06(.clk(clk), .initial_count(items06), .init(new_event), .sel(sel06), 
    .setup(setup), .addr(addr06[5:0]), .has_dat(has_dat06), .valid(valid06), .first_dat(first_dat) );
prio_support prio_support07(.clk(clk), .initial_count(items07), .init(new_event), .sel(sel07), 
    .setup(setup), .addr(addr07[5:0]), .has_dat(has_dat07), .valid(valid07), .first_dat(first_dat) );
prio_support prio_support08(.clk(clk), .initial_count(items08), .init(new_event), .sel(sel08), 
    .setup(setup), .addr(addr08[5:0]), .has_dat(has_dat08), .valid(valid08), .first_dat(first_dat) );
prio_support prio_support09(.clk(clk), .initial_count(items09), .init(new_event), .sel(sel09), 
    .setup(setup), .addr(addr09[5:0]), .has_dat(has_dat09), .valid(valid09), .first_dat(first_dat) );
prio_support prio_support10(.clk(clk), .initial_count(items10), .init(new_event), .sel(sel10), 
    .setup(setup), .addr(addr10[5:0]), .has_dat(has_dat10), .valid(valid10), .first_dat(first_dat) );
prio_support prio_support11(.clk(clk), .initial_count(items11), .init(new_event), .sel(sel11), 
    .setup(setup), .addr(addr11[5:0]), .has_dat(has_dat11), .valid(valid11), .first_dat(first_dat) );
       
 
//////////////////////////////////////////////////////////////////////////////////
// connect the priority encoder the will access the next memory that has data
prio_encoder prio_encoder (
    // Inputs:
    .clk(clk),
    //.first_dat(first_dat),
    .has_dat00(has_dat00),
    .has_dat01(has_dat01),
    .has_dat02(has_dat02),
    .has_dat03(has_dat03),
    .has_dat04(has_dat04),
    .has_dat05(has_dat05),
    .has_dat06(has_dat06),
    .has_dat07(has_dat07),
    .has_dat08(has_dat08),
    .has_dat09(has_dat09),
    .has_dat10(has_dat10),
    .has_dat11(has_dat11),
    // Outputs:
    .sel00(sel00),
    .sel01(sel01),
    .sel02(sel02),
    .sel03(sel03),
    .sel04(sel04),
    .sel05(sel05),
    .sel06(sel06),
    .sel07(sel07),
    .sel08(sel08),
    .sel09(sel09),
    .sel10(sel10),
    .sel11(sel11),
    .sel(sel[3:0]),   // binary encoded
    .none(none)       // no more data
);
//////////////////////////////////////////////////////////////////////////////////
// write the header for the datastream
header fullheader(
    .clk(clk),
    .new_event(new_event),
    .BX(BX),
    .clk_cnt(clk_cnt),
    .BX_pipe(BX_pipe),
    .addr(addr00),
    .has_data(has_dat00),
    .sel(sel[3:0]),
    .num(items00),
    //output header into datastream
    .header_stream(header_stream)
);


//////////////////////////////////////////////////////////////////////////////////
// connect a mux to merge the data streams
mem_mux mem_mux(
    .clk(clk),
    .BX(BX),
    .sel(sel[3:0]),   // binary encoded
    .mem_dat00(mem_dat00),
    .mem_dat01(mem_dat01),
    .mem_dat02(mem_dat02),
    .mem_dat03(mem_dat03),
    .mem_dat04(mem_dat04),
    .mem_dat05(mem_dat05),
    .mem_dat06(mem_dat06),
    .mem_dat07(mem_dat07),
    .mem_dat08(mem_dat08),
    .mem_dat09(mem_dat09),
    .mem_dat10(mem_dat10),
    .mem_dat11(mem_dat11),
//    .header_stream(header_stream),
    
    .mem_dat_stream(mem_dat_stream)
);

//////////////////////////////////////////////////////////////////////////////////
// merge the 'valid' bits by 'OR'ing them together. Disable 'valid' during setup.
always @ (posedge clk) begin
    valid <= !setup & (valid00 | valid01 | valid02 | valid03 | valid04 | valid05 | valid06 | valid07 | valid08 | valid09 | valid10 | valid11);
end

 
endmodule