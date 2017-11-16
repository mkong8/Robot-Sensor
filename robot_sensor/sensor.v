module lab4(a, b, c, rd2, rd1, rd0, sum, sum1); //top level module
input [3:0]a, b;
input [1:0]c;//input declarations
output wire [6:0]rd2, rd1, rd0;// ld2, ld1, ld0; //digit output declarations
wire [4:0]a1, b1, a2, b2, b1o; //sign extended
output wire [4:0]sum, sum1; //hold variable for sum
wire S1, S2, carry;

	sign_extend(a, a1);
	sign_extend(b, b1);

	ones_complement(b1, b1o);
	
	control(c, S1, S2, carry);
	mux(a1, a1, S2, carry, a2);
	mux(b1, b1o, S1, carry, b2);
	adder(a2, b2, carry, sum);
	assign sum1 = (sum[4] == 1) ? ~sum + 1 : sum;
	readout(sum1, S1, S2, rd0, rd1, rd2);

endmodule

module abs(in, out); //absolute value module
input [4:0]in;
output wire [4:0]out;
wire neg;
	
	assign neg = in[4];
	assign out = (neg) ? ~in : in;
	
endmodule

module control(c, S1, S2, carry); //operation control
	input [1:0]c;
	output wire S1, S2, carry;
	
	assign carry = (~c[1] & c[0]) ? 1 : 0;
	assign S1 = (c[1] & c[0]) ? 1 : 0;
	assign S2 = (c[1] & ~c[0]) ? 1 : 0;
	
endmodule

module mux(in1, in2, S, carry, out); //2-1 MUX
	input [4:0]in1, in2;
	input S, carry;
	output wire [4:0]out;
	
	assign out = (carry) ? in2 :
	(S) ? 5'b00000: in1;
	
endmodule


module sign_extend(in, out); //sign extension module
input [3:0]in;
output wire [4:0]out;

	assign out[0] = in[0];
	assign out[1] = in[1];
	assign out[2] = in[2];
	assign out[3] = in[3];
	assign out[4] = in[3];
	
endmodule

module ones_complement(in, out); //1s' complement module
input [4:0]in;
output wire [4:0]out;

	assign out = ~in;
	
endmodule

module adder(a, b, carry, sum); //4-bit adder module
input [4:0]a, b;
input wire carry;
output wire [4:0]sum;
wire cin0, cin1, cin2, cin3, cin4, cout0, cout1, cout2, cout3, cout4;

	assign cin0 = carry;
	assign sum[0] = a[0] ^ b[0] ^ cin0; //first bit
	assign cout0 = (a[0] & b[0]) | ((a[0] ^ b[0]) & cin0); //first carry
	assign cin1 = cout0;
	assign sum[1] = a[1] ^ b[1] ^ cin1; //second bit
	assign cout1 = (a[1] & b[1]) | ((a[1] ^ b[1]) & cin1); //second carry
	assign cin2 = cout1;
	assign sum[2] = a[2] ^ b[2] ^ cin2; //third bit
	assign cout2 = (a[2] & b[2]) | ((a[2] ^ b[2]) & cin2); //third carry
	assign cin3 = cout2;
	assign sum[3] = a[3] ^ b[3] ^ cin3; //fourth bit
	assign cout3 = (a[3] & b[3]) | ((a[3] ^ b[3]) & cin3); //fourth carry
	assign cin4 = cout3;
	assign sum[4] = a[4] ^ b[4] ^ cin4; //fifth bit
	assign cout4 = (a[4] & b[4]) | ((a[4] ^ b[4]) & cin4); //fifth carry

endmodule

module readout(A, S1, S2, B, C, S);
input[4:0] A;// 4 bit input
input S1, S2;
output[6:0] B, C;// Seven segment output
output[6:0] S;// Sign output
wire[6:0] B;
wire[6:0] S;

/* Defines are used for easy reference to 7 segment bit patterns. */
`define n0 7'b1000000 
`define n1 7'b1111001
`define n2 7'b0100100
`define n3 7'b0110000
`define n4 7'b0011001
`define n5 7'b0010010
`define n6 7'b0000011
`define n7 7'b1111000
`define n8 7'b0000000
`define n9 7'b0011000
`define P 7'b1111111
`define N 7'b0111111

/* The condition operator is used to map the 7 segment bit pattern */

assign B = ((A == 5'b00000) | (A == 5'b01010) | (A == 5'b10110)) ? `n0 : 
((A == 5'b00001) | (A == 5'b11111) | (A == 5'b01011) | (A == 5'b10101)) ? `n1 : 
((A == 5'b00010) | (A == 5'b11110) | (A == 5'b01100) | (A == 5'b10100)) ? `n2 :
((A == 5'b00011) | (A == 5'b11101) | (A == 5'b01101) | (A == 5'b10011)) ? `n3 :
((A == 5'b00100) | (A == 5'b11100) | (A == 5'b01110) | (A == 5'b10010)) ? `n4 :
((A == 5'b00101) | (A == 5'b11011) | (A == 5'b01111) | (A == 5'b10001)) ? `n5 :
((A == 5'b00110) | (A == 5'b11010) | (A == 5'b10000)) ? `n6 :
((A == 5'b00111) | (A == 5'b11001)) ? `n7 :
((A == 5'b01000) | (A == 5'b11000)) ? `n8 : `n9;

assign C = ((A == 5'b00000) | (A == 5'b00001) | (A == 5'b11111) | (A == 5'b00010) 
| (A == 5'b11110) | (A == 5'b00011) | (A == 5'b11101) | (A == 5'b00100) | (A == 5'b11100) 
| (A == 5'b00101) | (A == 5'b11011) | (A == 5'b00110) | (A == 5'b11010) | (A == 5'b00111) 
| (A == 5'b11001) | (A == 5'b01000) | (A == 5'b11000) | (A == 5'b01001) | (A == 5'b10111)) ? `n0 :
`n1;

assign S = (S1 | S2) ? `P :
(A[4] == 0) ? `P : `N;
endmodule
