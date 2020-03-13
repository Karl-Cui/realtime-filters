module datapath(red_out, green_out, blue_out, reset_n, clk, red_in, green_in, blue_in);

    input [7:0] red_in, green_in, blue_in;
    output [7:0] red_out, green_out, blue_out;

    // This module calculates the final pixel values
    conv c0(
        .red_out(red_out),
        .green_out(green_out),
        .blue_out(blue_out),
        .reset_n(reset_n),
        .enable(),
        .red_in(),
        .green_in(),
        .blue_in(),
        .kernel(),
        .divisor()
    );

    // This module chooses a kernel
    kernel_lut lut(
        .kernel(),
        .divisor(),
        .select()
    );

    // These modules provide the current pixels to act up upon
    row_buffer rRed(
        .kernel(),
        .dataIn(),
        .clk(clk),
        .reset_n(reset_n)
    );
    
    row_buffer rGreen(
        .kernel(),
        .dataIn(),
        .clk(clk),
        .reset_n(reset_n)
    );

    row_buffer rBlue(
        .kernel(),
        .dataIn(),
        .clk(clk),
        .reset_n(reset_n)
    );

endmodule
