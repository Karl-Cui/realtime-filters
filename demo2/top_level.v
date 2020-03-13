module top_level(SW, KEY, CLOCK_50, HEX0, HEX1);
	 input [9:0] SW;			// note: currently we are using 8 bit to represent colour
    input [3:0] KEY;
    input CLOCK_50;
    output [6:0] HEX0, HEX1;

    wire resetn;
    wire go;

    wire [7:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];
	 
	 wire ld_0, ld_1, ld_2, ld_3, ld_4, ld_5, ld_6, ld_7, ld_8;
	 wire ld_r;
    wire [3:0]  alu_select_a, alu_select_b;

    control c0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        
        .ld_0(ld_0),
        .ld_1(ld_1),
        .ld_2(ld_2),
        .ld_3(ld_3), 
        .ld_4(ld_4), 
		  .ld_5(ld_5),
		  .ld_6(ld_6),
		  .ld_7(ld_7),
		  .ld_8(ld_8),
		  
		  .ld_r(ld_r),
        
        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b)
    );

	 wire [4:0] s0, s1, s2, s3, s4, s5, s6, s7, s8;
	 
    datapath d0(
        .clk(CLOCK_50),
        .resetn(resetn),

        .ld_0(ld_0),
        .ld_1(ld_1),
        .ld_2(ld_2),
        .ld_3(ld_3), 
        .ld_4(ld_4), 
		  .ld_5(ld_5),
		  .ld_6(ld_6),
		  .ld_7(ld_7),
		  .ld_8(ld_8),
		  
		  .ld_r(ld_r),
		  
		  .s0({3'b000, s0}),			// TODO: fill these with kernel
		  .s1({3'b000, s1}),
		  .s2({3'b000, s2}),
		  .s3({3'b000, s3}),
		  .s4({3'b000, s4}),
		  .s5({3'b000, s5}),
		  .s6({3'b000, s6}),
		  .s7({3'b000, s7}),
		  .s8({3'b000, s8}),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),

        .data_in(SW[7:0]),
        .data_result(data_result)
    );
	 
	 lut lut0(
		  .select(SW[9:8]),
		  .kernel({s0, s1, s2, s3, s4, s5, s6, s7, s8})
	 );
	 
	 hex_decoder H0(
        .hex_digit(data_result[3:0]), 
        .segments(HEX0)
        );
        
    hex_decoder H1(
        .hex_digit(data_result[7:4]), 
        .segments(HEX1)
        );

endmodule
