`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 12:30:22 PM
// Design Name: 
// Module Name: adder_tb
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


module adder_tb;

reg clk = 0;
always #5 clk = ~clk;
reg signed [15:0] a[7:0];
reg signed [127:0] a_flat;
wire signed [18:0] out;

integer i = 0;

always @(*) begin 
    a_flat = {a[7], a[6], a[5], a[4], a[3], a[2], a[1], a[0]};
end

tree_adder dut(
    .clk(clk),
    .a(a_flat),
    .out(out)
);

initial begin
    for(i = 0; i < 8; i=i+1) begin 
        a[i] = (-1)**i * i;
    end
    #100;
    for(i = 0; i < 8; i=i+1) begin 
        $display("Stage 0[%d]: %d", i, dut.level_0[i]);
    end
    for(i = 0; i < 4; i=i+1) begin 
        $display("Stage 1[%d]: %d", i, dut.level_1[i]);
    end
        for(i = 0; i < 2; i=i+1) begin 
        $display("Stage 2[%d]: %d", i, dut.level_2[i]);
    end
    $display("Added: %d", out);
    $finish;
end
endmodule
