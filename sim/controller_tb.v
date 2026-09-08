`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 09:02:34 PM
// Design Name: 
// Module Name: controller_tb
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


module controller_tb;

reg clk = 0;
always #5 clk = ~clk;
reg reset = 0;

reg signed [255:0] a;
reg signed [255:0] b;

reg start = 0;

wire output_ready;
wire overflow;
wire signed [127:0] dot_product;
wire chain_ready;
wire [2:0] chunk_finished;

assign chain_ready = dut.chain_valid;
assign chunk_finished = dut.chunks_finished;
controller dut(
    .clk(clk),
    .reset(reset),
    .a(a),
    .b(b),
    .start(start),
    .output_ready(output_ready),
    .overflow(overflow),
    .dot_product(dot_product)
);

integer i;
integer expected_output = 0;
initial begin 
    for(i = 0; i < 32; i=i+1)begin 
        a[(i*8) +: 8] = i;
        b[(i*8) +: 8] = -i;
        expected_output = expected_output + (i*-i);
    end
    #100
    start <= 1;
    #50
    start <= 0;
    #100
    
    $display("Expected: %0d", expected_output);
    $display("Recieved: %0d", dot_product);
    $finish;
end
endmodule

