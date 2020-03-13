module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,					// TODO: isn't RGB 10 bit..?
	 
    input ld_0, ld_1, ld_2,
			 ld_3, ld_4, ld_5,
			 ld_6, ld_7, ld_8,
    input ld_r,
	 
	 input [7:0] s0, s1, s2,				// registers for convolution matrix
					 s3, s4, s5,
					 s6, s7, s8,				// see above TODO
	 
    input [3:0] alu_select_a, alu_select_b,
    output reg [7:0] data_result			// see above TODO
    );
    
    // input registers
    reg [7:0] r0, r1, r2,
				  r3, r4, r5,
				  r6, r7, r8;
				  
	 // BIG TODO: registers for 

    // output of the alu
    reg [7:0] alu_out;
    // alu input muxes
    reg [7:0] alu_a, alu_b;
    
    // Registers with respective input logic
    always @ (posedge clk) begin
        if (!resetn) begin
            r0 <= 8'd0; 
            r1 <= 8'd0; 
            r2 <= 8'd0; 
            r3 <= 8'd0; 
				r4 <= 8'd0; 
				r5 <= 8'd0; 
				r6 <= 8'd0; 
				r7 <= 8'd0; 
				r8 <= 8'd0; 
        end else begin
            if (ld_0)
                r0 <= data_in; 
            if (ld_1)
                r1 <= data_in;
            if (ld_2)
                r2 <= data_in;
				if (ld_3)
                r3 <= data_in;
				if (ld_4)
                r4 <= data_in;
				if (ld_5)
                r5 <= data_in;
				if (ld_6)
                r6 <= data_in;
				if (ld_7)
                r7 <= data_in;
				if (ld_8)
                r8 <= data_in;
        end
    end
 
    // Output result register
    always @ (posedge clk) begin
        if (!resetn) begin
            data_result <= 8'd0; 
        end
        else begin
            if(ld_r)
                data_result <= data_result + alu_a * alu_b;
				else
					 data_result <= data_result;
		  end
    end

    // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            4'd0: alu_a = r0;
            4'd1: alu_a = r1;
            4'd2: alu_a = r2;
            4'd3: alu_a = r3;
			   4'd4: alu_a = r4;
			   4'd5: alu_a = r5;
				4'd6: alu_a = r6;
				4'd7: alu_a = r7;
				4'd8: alu_a = r8;
            default: alu_a = 8'd0;
        endcase

        case (alu_select_b)
            4'd0: alu_b = s0;
            4'd1: alu_b = s1;
            4'd2: alu_b = s2;
            4'd3: alu_b = s3;
			   4'd4: alu_b = s4;
			   4'd5: alu_b = s5;
				4'd6: alu_b = s6;
				4'd7: alu_b = s7;
				4'd8: alu_b = s8;
            default: alu_b = 8'd0;
        endcase
    end
    
endmodule
