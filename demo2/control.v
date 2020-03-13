module control(
    input clk,
    input resetn,
    input go,

    output reg  ld_0, ld_1, ld_2,
					 ld_3, ld_4, ld_5,
					 ld_6, ld_7, ld_8,
					 
					 ld_r,		// r for result
					 
    output reg [3:0] alu_select_a,		// alu_select_a selects from matrix of pixels
							alu_select_b		// alu_select_b selects from convolution matrix
    
	 // do not need alu_op because all the operations are multiplication followed by addition
    );

	 reg [3:0] counter;
    reg [4:0] current_state, next_state; 
    
    localparam  S_LOAD_0        = 5'd0,
                S_LOAD_0_WAIT   = 5'd1,
                S_LOAD_1        = 5'd2,
                S_LOAD_1_WAIT   = 5'd3,
                S_LOAD_2        = 5'd4,
                S_LOAD_2_WAIT   = 5'd5,
                S_LOAD_3        = 5'd6,
                S_LOAD_3_WAIT   = 5'd7,
					 S_LOAD_4        = 5'd8,
                S_LOAD_4_WAIT   = 5'd9,
					 S_LOAD_5        = 5'd10,
                S_LOAD_5_WAIT   = 5'd11,
					 S_LOAD_6        = 5'd12,
                S_LOAD_6_WAIT   = 5'd13,
					 S_LOAD_7        = 5'd14,
                S_LOAD_7_WAIT   = 5'd15,
					 S_LOAD_8        = 5'd16,
                S_LOAD_8_WAIT   = 5'd17,
                S_CYCLE_CALC    = 5'd18;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
					 S_LOAD_0: next_state = go ? S_LOAD_0_WAIT : S_LOAD_0; // Loop in current state until value is input
                S_LOAD_0_WAIT: next_state = go ? S_LOAD_0_WAIT : S_LOAD_1; // Loop in current state until go signal goes low
                S_LOAD_1: next_state = go ? S_LOAD_1_WAIT : S_LOAD_1; // Loop in current state until value is input
                S_LOAD_1_WAIT: next_state = go ? S_LOAD_1_WAIT : S_LOAD_2; // Loop in current state until go signal goes low
                S_LOAD_2: next_state = go ? S_LOAD_2_WAIT : S_LOAD_2; // Loop in current state until value is input
                S_LOAD_2_WAIT: next_state = go ? S_LOAD_2_WAIT : S_LOAD_3; // Loop in current state until go signal goes low
                S_LOAD_3: next_state = go ? S_LOAD_3_WAIT : S_LOAD_3; // Loop in current state until value is input
                S_LOAD_3_WAIT: next_state = go ? S_LOAD_3_WAIT : S_LOAD_4; // Loop in current state until go signal goes low
					 S_LOAD_4: next_state = go ? S_LOAD_4_WAIT : S_LOAD_4; // Loop in current state until value is input
                S_LOAD_4_WAIT: next_state = go ? S_LOAD_4_WAIT : S_LOAD_5; // Loop in current state until go signal goes low
					 S_LOAD_5: next_state = go ? S_LOAD_5_WAIT : S_LOAD_5; // Loop in current state until value is input
                S_LOAD_5_WAIT: next_state = go ? S_LOAD_5_WAIT : S_LOAD_6; // Loop in current state until go signal goes low
					 S_LOAD_6: next_state = go ? S_LOAD_6_WAIT : S_LOAD_6; // Loop in current state until value is input
                S_LOAD_6_WAIT: next_state = go ? S_LOAD_6_WAIT : S_LOAD_7; // Loop in current state until go signal goes low
					 S_LOAD_7: next_state = go ? S_LOAD_7_WAIT : S_LOAD_7; // Loop in current state until value is input
                S_LOAD_7_WAIT: next_state = go ? S_LOAD_7_WAIT : S_LOAD_8; // Loop in current state until go signal goes low
					 S_LOAD_8: next_state = go ? S_LOAD_8_WAIT : S_LOAD_8; // Loop in current state until value is input
                S_LOAD_8_WAIT: next_state = go ? S_LOAD_8_WAIT : S_CYCLE_CALC; // Loop in current state until go signal goes low
					 S_CYCLE_CALC: next_state = S_CYCLE_CALC;
            default:     next_state = S_LOAD_0;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
	 
        // By default make all our signals 0
		  ld_0 = 1'b0;
        ld_1 = 1'b0;
        ld_2 = 1'b0;
        ld_3 = 1'b0;
        ld_4 = 1'b0;
        ld_5 = 1'b0;
		  ld_6 = 1'b0;
		  ld_7 = 1'b0;
		  ld_8 = 1'b0;
		  ld_r = 1'b0;
        alu_select_a = 4'b0000;
        alu_select_b = 4'b0000;

        case (current_state)
            S_LOAD_0: ld_0 = 1'b1;
            S_LOAD_1: ld_1 = 1'b1;
				S_LOAD_2: ld_2 = 1'b1;
				S_LOAD_3: ld_3 = 1'b1;
				S_LOAD_4: ld_4 = 1'b1;
				S_LOAD_5: ld_5 = 1'b1;
				S_LOAD_6: ld_6 = 1'b1;
				S_LOAD_7: ld_7 = 1'b1;
				S_LOAD_8: ld_8 = 1'b1;
            S_CYCLE_CALC: begin 
                ld_r = 1'b1; // store result in r
                alu_select_a = counter;
                alu_select_b = 4'b1000 - counter;
				end
				
				// default: don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn) begin
            current_state <= S_LOAD_0;
				counter <= 4'b0000;
		  end else if (counter == 4'b1001) begin
				current_state <= S_LOAD_0;
				counter <= 4'b0000;
        end else begin
            current_state <= next_state;
				if (current_state == S_CYCLE_CALC)
					counter = counter + 1;
		  end
    end // state_FFS
endmodule
