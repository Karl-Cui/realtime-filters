module row_buffer(kernel, dataIn, clk, reset_n);

  parameter rowWidth = 640;
  parameter kernelSize = 7;
  parameter bitsPerPixel = 10;
  parameter pixelsPerKernel = kernelSize * kernelSize;
  parameter bitsPerKernelRow = kernelSize * bitsPerPixel;
  parameter bitsPerKernel = pixelsPerKernel * bitsPerPixel;
  
  input [bitsPerPixel - 1:0] dataIn;
  input clk, reset_n, enable;
  
  output reg [bitsPerKernel - 1:0] kernel;

  reg [rowWidth * bitsPerPixel * kernelSize - 1: 0] shiftReg;

  always @(posedge clk) begin
    if (reset_n == 0) begin
      shiftReg <= {(rowWidth * bitsPerPixel * kernelSize){1'b0}};
      kernel <= 0;
    end 
    else if (enable == 1) begin 
      shiftReg <= shiftReg << bitsPerPixel;
      shiftReg <= shiftReg + dataIn;

      // Only output the pixels within the kernel window
      for (i = 0; i < kernelSize; i = i + 1) begin
        kernel[bitsPerKernel - i * bitsPerKernelRow - 1 : bitsPerKernel - (i + 1) * bitsPerKernelRow] <= shiftReg[kernelSize * bitsPerPixel + i * rowWidth * bitsPerPixel - 1: (i * rowWidth * bitsPerPixel)];
      end
    end
    else begin
      shiftReg <= shiftReg;
      kernel <= kernel;
    end
  end
	 
endmodule // row_buffer