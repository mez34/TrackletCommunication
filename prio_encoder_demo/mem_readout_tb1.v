`timescale 1ns / 1ps

module mem_readout_tb1;

    reg clk;                     // main clock
    //reg reset;                   // synchronously negated active-hi reset
    reg new_event;               // start over
    reg fifo_rst;                // reset fifo after each new_event
    reg fifo_rst1;               // hold fifo reset
    reg fifo_rst2;               // hold fifo reset
    reg fifo_rst3;               // hold fifo reset
    reg fifo_rst4;               // hold fifo reset
    reg [2:0] BX;                // store BX
    reg [6:0] clk_cnt;           // counter for # of clock cycles in processing BX
    reg [2:0] BX_pipe;           // if clk_cnt reaches 7'b1, increment BX_pipe
    
    wire [5:0] items00;          // starting number of items for this memory
    wire [5:0] items01;          // starting number of items for this memory
    wire [5:0] items02;          // starting number of items for this memory
    wire [5:0] items03;          // starting number of items for this memory
    wire [5:0] items04;          // starting number of items for this memory
    wire [5:0] items05;          // starting number of items for this memory
    wire [5:0] items06;          // starting number of items for this memory
    wire [5:0] items07;          // starting number of items for this memory
    wire [5:0] items08;          // starting number of items for this memory
    wire [5:0] items09;          // starting number of items for this memory
    wire [5:0] items10;          // starting number of items for this memory
    wire [5:0] items11;          // starting number of items for this memory
    
    wire [44:0] mem_dat00;       // data from this memory
    wire [44:0] mem_dat01;       // data from this memory
    wire [44:0] mem_dat02;       // data from this memory
    wire [44:0] mem_dat03;       // data from this memory
    wire [44:0] mem_dat04;       // data from this memory
    wire [44:0] mem_dat05;       // data from this memory
    wire [44:0] mem_dat06;       // data from this memory
    wire [44:0] mem_dat07;       // data from this memory
    wire [44:0] mem_dat08;       // data from this memory
    wire [44:0] mem_dat09;       // data from this memory
    wire [44:0] mem_dat10;       // data from this memory
    wire [44:0] mem_dat11;       // data from this memory
    
    reg [5:0] nitems_addr;          // counts number of items in the data
    
    reg [4:0] read_addr00;
    reg [4:0] read_addr01;
    reg [4:0] read_addr02;
    reg [4:0] read_addr03;
    reg [4:0] read_addr04;
    reg [4:0] read_addr05;
    reg [4:0] read_addr06;
    reg [4:0] read_addr07;
    reg [4:0] read_addr08;
    reg [4:0] read_addr09;
    reg [4:0] read_addr10;
    reg [4:0] read_addr11;
    
    wire [5:0] addr00;          // lower part of memory address
    wire [5:0] addr01;          // lower part of memory address
    wire [5:0] addr02;          // lower part of memory address
    wire [5:0] addr03;          // lower part of memory address
    wire [5:0] addr04;          // lower part of memory address
    wire [5:0] addr05;          // lower part of memory address
    wire [5:0] addr06;          // lower part of memory address
    wire [5:0] addr07;          // lower part of memory address
    wire [5:0] addr08;          // lower part of memory address
    wire [5:0] addr09;          // lower part of memory address
    wire [5:0] addr10;          // lower part of memory address
    wire [5:0] addr11;          // lower part of memory address
    
    wire none;                  // no more items
    wire [44:0] header_stream;
    wire [51:0] mem_dat_stream;
    wire [51:0] data_output;
    wire valid;                 // 'mem_dat_stream' has valid data
    
    // FIFO internal outputs
    reg FIFO_rd_en;
    wire FIFO_EMPTY,FIFO_FULL;
    
	// Instantiate the Unit Under Test (UUT)
	mem_readout_top uut(
        .clk(clk),                    // main clock
        //.reset(reset),                  // synchronously negated active-hi reset
        .new_event(fifo_rst4),        // start over
        .BX(BX),                    // BX number
        .clk_cnt(clk_cnt),          // clock cylces gone by in BX
        .BX_pipe(BX_pipe),
        
        .items00(items00),          // starting number of items for this memory
        .items01(items01),          // starting number of items for this memory
        .items02(items02),          // starting number of items for this memory
        .items03(items03),          // starting number of items for this memory
        .items04(items04),          // starting number of items for this memory
        .items05(items05),          // starting number of items for this memory
        .items06(items06),          // starting number of items for this memory
        .items07(items07),          // starting number of items for this memory
        .items08(items08),          // starting number of items for this memory
        .items09(items09),          // starting number of items for this memory
        .items10(items10),          // starting number of items for this memory
        .items11(items11),          // starting number of items for this memory

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

        .addr00(addr00),          // lower part of memory address
        .addr01(addr01),          // lower part of memory address
        .addr02(addr02),          // lower part of memory address
        .addr03(addr03),          // lower part of memory address
        .addr04(addr04),          // lower part of memory address
        .addr05(addr05),          // lower part of memory address
        .addr06(addr06),          // lower part of memory address
        .addr07(addr07),          // lower part of memory address
        .addr08(addr08),          // lower part of memory address
        .addr09(addr09),          // lower part of memory address
        .addr10(addr10),          // lower part of memory address
        .addr11(addr11),          // lower part of memory address
        .mem_dat_stream(mem_dat_stream),
        .valid(valid),
        .none(none)                 // no more items
    );

    reg [5:0] new_event_period;

	initial begin
		// Initialize Inputs
		clk = 0;
		BX = 3'b0;
		clk_cnt = 7'b0;
		BX_pipe = 3'b111;
		FIFO_rd_en = 1'b0;
		//reset = 0;
		/*items00 = 6'b000000;
		items01 = 6'b000001;
		items02 = 6'b011000;
		items03 = 6'b000010;
		items04 = 6'b000000;
		items05 = 6'b000000;
		items06 = 6'b000100;
		items07 = 6'b000000;
		items08 = 6'b001000;
		items09 = 6'b000001;
		items10 = 6'b011000;
		items11 = 6'b000000;*/
        /*mem_dat00 = 45'b0;
		mem_dat01 = 45'b0;
		mem_dat02 = 45'b0;
		mem_dat03 = 45'b0;
		mem_dat04 = 45'b0;
		mem_dat05 = 45'b0;
		mem_dat06 = 45'b0;
		mem_dat07 = 45'b0;
		mem_dat08 = 45'b0;
		mem_dat09 = 45'b0;
		mem_dat10 = 45'b0;
		mem_dat11 = 45'b0;*/
		new_event = 1'b0;
  		new_event_period[5:0] = 0;

        //lowest address to read data
        read_addr00 = 4'h0000;
        read_addr01 = 4'h0000;
        read_addr02 = 4'h0000;
        read_addr03 = 4'h0000;
        read_addr04 = 4'h0000;
        read_addr05 = 4'h0000;
        read_addr06 = 4'h0000;
        read_addr07 = 4'h0000;
        read_addr08 = 4'h0000;
        read_addr09 = 4'h0000;
        read_addr10 = 4'h0000;
        read_addr11 = 4'h0000;
        
        //address where the number of items in the memory is stored, should be last line of memory
        //test memory is line 12 
        nitems_addr = 5'h0000C;
        
		// Wait 100 ns for global reset to finish
		#100;
        
    end

	// Add stimulus here
	// clocks
    always begin
        #5 clk = ~clk;   // 100 MHz
    end
        

    memory #(45,5,"/home/user/project_1/testdata0.txt") getMemDat00( .output_data(mem_dat00), .clock(clk),
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr00), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata1.txt") getMemDat01( .output_data(mem_dat01), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr01), .input_data(45'b0) );         
    memory #(45,5,"/home/user/project_1/testdata2.txt") getMemDat02( .output_data(mem_dat02), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr02), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata3.txt") getMemDat03( .output_data(mem_dat03), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr03), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata4.txt") getMemDat04( .output_data(mem_dat04), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr04), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata5.txt") getMemDat05( .output_data(mem_dat05), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr05), .input_data(45'b0) );         
    memory #(45,5,"/home/user/project_1/testdata6.txt") getMemDat06( .output_data(mem_dat06), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr06), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata7.txt") getMemDat07( .output_data(mem_dat07), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr07), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata8.txt") getMemDat08( .output_data(mem_dat08), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr08), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata9.txt") getMemDat09( .output_data(mem_dat09), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr09), .input_data(45'b0) );         
    memory #(45,5,"/home/user/project_1/testdata10.txt") getMemDat10( .output_data(mem_dat10), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr10), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata11.txt") getMemDat11( .output_data(mem_dat11), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(read_addr11), .input_data(45'b0) );
      
    //numItems count00(.num_items(items00), .clock(clk) );
        
    //count the number of items in the data 
    //number of items is stored in the nitems_addr which is the last line in the RAM
    memory #(45,5,"/home/user/project_1/testdata0.txt") getNumItems00( .output_data(items00), .clock(clk),
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata1.txt") getNumItems01( .output_data(items01), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );         
    memory #(45,5,"/home/user/project_1/testdata2.txt") getNumItems02( .output_data(items02), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata3.txt") getNumItems03( .output_data(items03), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata4.txt") getNumItems04( .output_data(items04), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata5.txt") getNumItems05( .output_data(items05), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );         
    memory #(45,5,"/home/user/project_1/testdata6.txt") getNumItems06( .output_data(items06), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata7.txt") getNumItems07( .output_data(items07), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata8.txt") getNumItems08( .output_data(items08), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata9.txt") getNumItems09( .output_data(items09), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );         
    memory #(45,5,"/home/user/project_1/testdata10.txt") getNumItems10( .output_data(items10), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );
    memory #(45,5,"/home/user/project_1/testdata11.txt") getNumItems11( .output_data(items11), .clock(clk), 
        .write_address(5'b1), .write_enable(1'b0), .read_address(nitems_addr), .input_data(45'b0) );

    //Make the memory read the next address every clock period
    always @ (posedge clk) begin
        read_addr00 <= addr00;
        read_addr01 <= addr01;
        read_addr02 <= addr02;
        read_addr03 <= addr03;
        read_addr04 <= addr04;
        read_addr05 <= addr05;
        read_addr06 <= addr06;
        read_addr07 <= addr07;
        read_addr08 <= addr08;
        read_addr09 <= addr09;
        read_addr10 <= addr10;
        read_addr11 <= addr11;
        fifo_rst1 <= new_event;
        fifo_rst2 <= fifo_rst1;
        fifo_rst3 <= fifo_rst2;
        fifo_rst4 <= fifo_rst3;
        fifo_rst <= ( new_event || fifo_rst1 || fifo_rst2 || fifo_rst3 || fifo_rst4 );
    end

/////////////////////////////////////////////////////////////////////
// send the mem_dat_stream to a dualclock FIFO
fifo_projection_out fifo1(
    .rst(fifo_rst),                            // 1 bit in data reset
    .wr_clk(clk),                               // 1 bit in write clock
    .rd_clk(clk),                               // 1 bit in read clock
    .din(mem_dat_stream),                       // 52 bit in data into FIFO
    .wr_en(valid),                              // 1 bit in write enable
    .rd_en(FIFO_rd_en),                         // 1 bit in read enable
    .dout(data_output),                         // 52 bit out data out of FIFO
    .full(FIFO_FULL),                           // 1 bit out FIFO full signal
    .empty(FIFO_EMPTY)                          // 1 bit out FIFO empty signal
  );

/*  // Make the memory data match the address every clock period  
    always @ (posedge clk) begin
       mem_dat00 <= {4'd00, 2'b0, addr00};
        mem_dat01 <= {4'd01, 2'b0, addr01};
        mem_dat02 <= {4'd02, 2'b0, addr02};
        mem_dat03 <= {4'd03, 2'b0, addr03};
        mem_dat04 <= {4'd04, 2'b0, addr04};
        mem_dat05 <= {4'd05, 2'b0, addr05};
        mem_dat06 <= {4'd06, 2'b0, addr06};
        mem_dat07 <= {4'd07, 2'b0, addr07};
        mem_dat08 <= {4'd08, 2'b0, addr08};
        mem_dat09 <= {4'd09, 2'b0, addr09};
        mem_dat10 <= {4'd10, 2'b0, addr10};
        mem_dat11 <= {4'd11, 2'b0, addr11};
    end*/

                            
    // periodically start a new event
    always @ (posedge clk) begin
        if (new_event_period[5:0] == 6'd45) begin
            FIFO_rd_en <= 1'b1;
        end
        if (new_event_period[5:0] == 6'd50) begin
            new_event <= 1'b1;
            new_event_period <= 6'b0;
        end
        else begin
            new_event <= 1'b0;
            new_event_period[5:0] <= new_event_period[5:0] + 1'b1;
        end
    end
    
    always @ (posedge clk) begin
        if (new_event) begin
            clk_cnt <= 7'b0;
            BX_pipe <= 3'b111;
            BX <= BX + 1'b1;
        end
        else begin
            clk_cnt <= clk_cnt + 1'b1;
        end
        if (clk_cnt == 7'b1) begin
            BX_pipe <= BX_pipe + 1'b1;
        end
    end
    
endmodule
