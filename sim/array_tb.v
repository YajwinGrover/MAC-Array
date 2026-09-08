`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 11:29:01 AM
// Design Name: 
// Module Name: array_tb
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


module array_tb;

reg clk = 0;
reg signed [7:0] a [0:7];
reg signed [63:0] a_flat;
reg signed [7:0] b [0:7];
reg signed [63:0] b_flat;
wire signed [15:0] out [0:7];
wire signed [127:0] out_flat;
always #5 clk = ~clk;
integer i;

always @(*) begin 
    a_flat = {a[7], a[6], a[5], a[4], a[3], a[2], a[1], a[0]};
    b_flat = {b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0]};
end

assign {out[7], out[6], out[5], out[4], out[3], out[2], out[1], out[0]} = out_flat;

MACArray dut (
    .clk(clk),
    .a(a_flat),
    .b(b_flat),
    .out(out_flat)
);

initial begin
    for(i = 0; i < 8; i = i + 1) begin 
        a[i] = i;
        b[i] = (-1)**i * i;
    end
    #100;
    for(i = 0; i < 8; i = i + 1) begin 
        $display("Output[%d]: %d", i, out[i]);
    end
    $finish;
end

endmodule
