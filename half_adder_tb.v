module half_adder(a,b,sum,carry);
	input a,b;
	output sum,carry;
	assign sum=a^b;
	assign carry=a&b;
endmodule 
module half_adder_tb();
	reg a,b;
	wire sum,carry;
	integer i;
	half_adder DUT(a,b,sum,carry);
	initial begin
		{a,b}=0; end
	initial begin
		for(i=0;i<4;i=i+1)
		begin
		{a,b}=i;
		#10; end end
	initial begin
		#100;
		$finish; end
	initial
		$monitor("input a=%b b=%b Outuput sum=%b carry=%b",a,b,sum,carry);
endmodule
