`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/25 21:42:00
// Design Name: 
// Module Name: hdb3_tb
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


`timescale 1ns / 1ps

module hdb3_tb;

reg i_rst;
reg i_clk;
reg i_data;
wire o_p;
wire o_n;

hdb3 hdb3(
.i_clk (i_clk ),
.i_rst (i_rst ),
.i_data(i_data),
.o_p   (o_p   ),
.o_n   (o_n   ) 
);

  // clk
  initial begin
    i_clk = 1;
    forever #244 i_clk = ~i_clk;  //2.048Mhz, cycle=488ns
  end

  // seq
  reg [64:0] stimulus = 65'b11000010000000011000011100001111001010001100000000000011100001101;

  initial begin
    i_rst = 1'b1;  
    i_data=0;
    #4880;             
    i_rst = 1'b0;
    #488;              
    data;
    data;
    #4880; 
    $finish;  
  end

  task data;
    integer i;
    for (i = 0; i < 65; i = i + 1) begin
      i_data = stimulus[64-i];  
      #488;  
    end
endtask
  
  initial begin
    $monitor("Time = %t, Reset = %b, Input = %b, Output = %b, Output = %b", $time, i_rst, i_data, o_p , o_n);
  end

endmodule
