module mux21(I,S,Y);
	input [0:1]I;
	input S;
	output Y;
	assign Y=S?I[1]:I[0];
endmodule

module mux21_tb();
	reg [0:1]I;
	reg S;
	wire Y;
	mux21 DUT(I,S,Y);
	initial begin
		S=0;
		I=2'b00;
		end	
		always #4 S=S+1;
		always #1 I=I+1;
			
	initial
		$monitor("input S=%b I=%b Output Y=%b",S,I,Y);
	initial #20 $finish;
endmodule
		
