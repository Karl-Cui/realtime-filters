module conv(red_out, green_out, blue_out, reset_n, enable, red_in, green_in, blue_in, kernel, divisor);

    input reset_n, enable;
    input [391:0] red_in, green_in, blue_in;  // 391 = 49 * 8 - 1
    input [391:0] kernel;
    input [7:0] divisor;
    output [7:0] red_out, green_out, blue_out;

    reg [15:0] result_red, result_green, result_blue;

    always @(*) begin
      if (reset_n == 0) begin
        result_red = 0;
        result_green = 0;
        result_blue = 0;
      end
      else if (enable == 1) begin
        // Perform convolution on the red channel
        for (i = 392; i >= 8; i = i - 8) begin
          result_red = result_red + kernel[i - 1:i - 8] * red_in[i - 1:i - 8];
        end

        // Perform convolution on the green channel
        for (i = 392; i >= 8; i = i - 8) begin
          result_green = result_green + kernel[i - 1:i - 8] * green_in[i - 1:i - 8];
        end

        // Perform convolution on the blue channel
        for (i = 392; i >= 8; i = i - 8) begin
          result_blue = result_blue + kernel[i - 1:i - 8] * blue_in[i - 1:i - 8];
        end
      end
      else begin
        result_red = 0;
        result_green = 0;
        result_blue = 0;
      end
    end

    // Apply any normalization required
    assign red_out = result_red / divisor;
    assign green_out = result_green / divisor;
    assign blue_out = result_blue / divisor;

endmodule
