`timescale 1 ns/1 ns

module lab7tb();
reg clk_s;
wire latch_s, pulse_s;

lab7 t1(.clk_old(clk_s), .latch(latch_s),.pulse(pulse_s));

//create a 50Mhz clock --> 20ns period
always begin
clk_s <=1; #10;
clk_s <=0; #10;
end
endmodule