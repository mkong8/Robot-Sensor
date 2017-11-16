module lab7(clk_old, data, latch, pulse, LEDg, LEDr, state, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, check);
input wire clk_old;
input data;
output reg latch, pulse;
output reg[7:0]LEDg;
output reg LEDr, check;
output reg [6:0]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
wire clk_new, clk_extra, clk2;
reg [8:0]counter_extra;
reg [8:0]counter;
reg [7:0]shiftreg;
reg [2:0]pulse_count;
reg egg;
reg reset;
integer i; //for loop to match LED to button position

output reg [3:0]state;
reg [3:0]next_state;

//easter egg: ruaddl
parameter N = 4'b0000;
parameter Rh = 4'b0001;
parameter R = 4'b0010;
parameter Uh = 4'b0011;
parameter U = 4'b0100;
parameter Ah = 4'b0101;
parameter A = 4'b0110;
parameter Dh = 4'b0111;
parameter D = 4'b1000;
parameter D2h = 4'b1001;
parameter D2 = 4'b1010;
parameter Lh = 4'b1011;
parameter L = 4'b1100;
parameter Sth = 4'b1101;

//extra credit letters
parameter G = 7'b1000010;
parameter O = 7'b0100011;
parameter letter_d = 7'b0100001;
parameter J = 7'b1110001;
parameter B = 7'b0000011;
parameter off = 7'b1111111;


p2divider(clk_old, clk_new);
p1divider(clk_old, clk_extra);
p3divider(clk_old, clk2);


//data shiftreg
always @(posedge pulse)
begin
	shiftreg <= {shiftreg[6:0], data};
end

//next state block
always @*
begin
	if(counter < 2) begin
		latch = 1;
		pulse = 0;
		reset = 0;
	end
	else if(counter == 3 | counter == 5 | counter == 7 | counter == 9 | counter == 11 | counter == 13 | counter == 15 | counter == 17) begin
		latch = 0;
		pulse = 1;
		reset = 0;
	end
	else begin
		latch = 0;
		pulse = 0;
		reset = 0;
	end
	if(counter >= 1634)
		reset = 1;
end

//easter egg next state block
always @*
begin
	check = clk2;
	case(state)
	N: begin
		LEDr = 0;
		egg = 0;
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111110)
			next_state = Rh;
		else
			next_state = N;
		end
	Rh: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111110)
			next_state = Rh;
		else
			next_state = R;
		end
	R: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11110111)
			next_state = Uh;
		else if(shiftreg == 8'b11111111)
			next_state = R;
		else
			next_state = N;
		end
	Uh: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11110111)
			next_state = Uh;
		else
			next_state = U;
		end
	U: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b01111111)
			next_state = Ah;
		else if(shiftreg == 8'b11111111)
			next_state = U;
		else
			next_state = N;
		end
	Ah: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b01111111)
			next_state = Ah;
		else
			next_state = A;
		end
	A: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111011)
			next_state = Dh;
		else if(shiftreg == 8'b11111111)
			next_state = A;
		else
			next_state = N;
		end
	Dh: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111011)
			next_state = Dh;
		else
			next_state = D;
		end
	D: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111011)
			next_state = D2h;
		else if(shiftreg == 8'b11111111)
			next_state = D;
		else
			next_state = N;
		end
	D2h: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111011)
			next_state = D2h;
		else
			next_state = D2;
		end
	D2: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111101)
			next_state = Lh;
		else if(shiftreg == 8'b11111111)
			next_state = D2;
		else
			next_state = N;
		end
	Lh: begin
		if(clk2)
			next_state = N;
		else if(shiftreg == 8'b11111101)
			next_state = Lh;
		else
			next_state = L;
		end
	L: begin
		LEDr = 1;
		egg = 1;
		else if(shiftreg == 8'b11101111)
			next_state = N;
		else
			next_state = L;
		end
	default: begin
		next_state = N;
	end
	endcase
end

//clock block
always @(posedge clk_new)
begin
	if(reset) begin
		counter <= 0;
	end
	else begin
 		counter <= counter + 1;
	end
end

//extra credit counter
always @(posedge clk_extra)
begin
	if(counter_extra == 13) begin
		counter_extra <= 0;
	end
	else if(egg) begin
		counter_extra <= counter_extra + 1;
	end
end

always @(posedge latch)
begin
	state <= next_state;
end

//LED outputs
always @*
begin
	if(counter > 20)
		LEDg = ~shiftreg;
		//for(i = 0; i < 8; i = i + 1)
			//LEDg[i] <= ~shiftreg[7 - i];
end

//extra credit light show
always @*
begin
	if(egg) begin
		if(counter_extra == 1 || counter_extra == 3 || counter_extra == 5 || counter_extra == 13) begin
			HEX7 = G;
			HEX6 = O;
			HEX5 = O;
			HEX4 = letter_d;
			HEX3 = J;
			HEX2 = O;
			HEX1 = B;
			HEX0 = off;
		end
		else if(counter_extra == 6) begin
			HEX7 = off;
			HEX6 = G;
			HEX5 = O;
			HEX4 = O;
			HEX3 = letter_d;
			HEX2 = J;
			HEX1 = O;
			HEX0 = B;
		end
		else if(counter_extra == 7) begin
			HEX7 = B;
			HEX6 = off;
			HEX5 = G;
			HEX4 = O;
			HEX3 = O;
			HEX2 = letter_d;
			HEX1 = J;
			HEX0 = O;
		end
		else if(counter_extra == 8) begin
			HEX7 = O;
			HEX6 = B;
			HEX5 = off;
			HEX4 = G;
			HEX3 = O;
			HEX2 = O;
			HEX1 = letter_d;
			HEX0 = J;
		end
		else if(counter_extra == 9) begin
			HEX7 = J;
			HEX6 = O;
			HEX5 = B;
			HEX4 = off;
			HEX3 = G;
			HEX2 = O;
			HEX1 = O;
			HEX0 = letter_d;
		end
		else if(counter_extra == 10) begin
			HEX7 = letter_d;
			HEX6 = J;
			HEX5 = O;
			HEX4 = B;
			HEX3 = off;
			HEX2 = G;
			HEX1 = O;
			HEX0 = O;
		end
		else if(counter_extra == 11) begin
			HEX7 = O;
			HEX6 = letter_d;
			HEX5 = J;
			HEX4 = O;
			HEX3 = B;
			HEX2 = off;
			HEX1 = G;
			HEX0 = O;
		end
		else if(counter_extra == 12) begin
			HEX7 = O;
			HEX6 = O;
			HEX5 = letter_d;
			HEX4 = J;
			HEX3 = O;
			HEX2 = B;
			HEX1 = off;
			HEX0 = G;
		end
		else begin
			HEX7 = off;
			HEX6 = off;
			HEX5 = off;
			HEX4 = off;
			HEX3 = off;
			HEX2 = off;
			HEX1 = off;
			HEX0 = off;
		end
	end
end

endmodule

//divider module
module p2divider(clockin, clockout);
input clockin;
output wire clockout;

parameter n = 8;
reg [n:0] count;

always@(posedge clockin)
begin
count <= count + 1;
end

assign clockout = count[n];

endmodule

//extra credit divider
module p1divider(clockin, clockout);
input clockin;
output wire clockout;

parameter n = 23;
reg [n:0] count;

always@(posedge clockin)
begin
	count <= count + 1;
end

assign clockout = count[n];

endmodule

//extra credit one second divider
module p3divider(clockin, clockout);
input clockin;
output wire clockout;

parameter n = 28;
reg [n:0] count;

always@(posedge clockin)
begin
	count <= count + 1;
end

assign clockout = count[n];

endmodule