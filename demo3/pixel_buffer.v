module pixel_buffer(window, dataIn, clk, reset_n);
    
    output [7 * 7 * 10 - 1:0] window;

    input [9:0] dataIn;
    input clk, reset_n;

    reg [7 * 10 - 1: 0] window_row_1, window_row_2, window_row_3, window_row_4, window_row_5, window_row_6, window_row_7;
    reg [9:0] row1Store, row2Store, row3Store, row4Store, row5Store, row6Store;
    wire [9:0] row1Load, row2Load, row3Load, row4Load, row5Load, row6Load;
	 
	assign window = {window_row_1, window_row_2, window_row_3, window_row_4, window_row_5, window_row_6, window_row_7};

    always @(posedge clk) begin
      if (!reset_n) begin
        window_row_1 <= 0;
        window_row_2 <= 0;
        window_row_3 <= 0;
        window_row_4 <= 0;
        window_row_5 <= 0;
        window_row_6 <= 0;
        window_row_7 <= 0;
      end
      else begin
        row1Store <= window_row_1[69:60];
        row2Store <= window_row_2[69:60];
        row3Store <= window_row_3[69:60];
        row4Store <= window_row_4[69:60];
        row5Store <= window_row_5[69:60];
        row6Store <= window_row_6[69:60];
        window_row_1 <= (window_row_1 << 10) + dataIn[9:0];
        window_row_2 <= (window_row_2 << 10) + row1Load[9:0];
        window_row_3 <= (window_row_3 << 10) + row2Load[9:0];
        window_row_4 <= (window_row_4 << 10) + row3Load[9:0];
        window_row_5 <= (window_row_5 << 10) + row4Load[9:0];
        window_row_6 <= (window_row_6 << 10) + row5Load[9:0];
        window_row_7 <= (window_row_7 << 10) + row6Load[9:0];
      end
    end

    Line_Shifter row1(
        .aclr(!reset_n),
        .clken(1'b1),
        .clock(clk),
        .shiftin(row1Store[9:0]),
        .shiftout(row1Load)
    );

    Line_Shifter row2(
        .aclr(!reset_n),
        .clken(1'b1),
        .clock(clk),
        .shiftin(row2Store[9:0]),
        .shiftout(row2Load)
    );

    Line_Shifter row3(
        .aclr(!reset_n),
        .clken(1'b1),
        .clock(clk),
        .shiftin(row3Store[9:0]),
        .shiftout(row3Load)
    );

    Line_Shifter row4(
        .aclr(!reset_n),
        .clken(1'b1),
        .clock(clk),
        .shiftin(row4Store[9:0]),
        .shiftout(row4Load)
    );

    Line_Shifter row5(
        .aclr(!reset_n),
        .clken(1'b1),
        .clock(clk),
        .shiftin(row5Store[9:0]),
        .shiftout(row5Load)
    );

    Line_Shifter row6(
        .aclr(!reset_n),
        .clken(1'b1),
        .clock(clk),
        .shiftin(row6Store[9:0]),
        .shiftout(row6Load)
    );

endmodule
