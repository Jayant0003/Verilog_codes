/*module full_adder(a,b,cin,sum,carry);
	input a,b,cin;
	output sum,carry;
	assign sum=a^b^cin;
	assign carry=(a^b)&cin|a&b;
endmodule 
*/
module full_adder(a,b,cin,sum,carry);
// direction of ports
	input a,b,cin;
	output sum,carry;
//declaring internal ports
	wire w1,w2,w3;
//instantiating half adders using order based port mapping
	half_adder HA1(a,b,w1,w2);
	half_adder HA2(w1,cin,sum,w3);
//instantiating or gate
	or OR1(carry,w2,w3);
endmodule 

module full_adder_tb();
//Testbench global variables
	reg a,b,cin;
	wire sum,carry;
//variable for loop iteration
	integer i;
//instatiating full adder with order based port mapping
	full_adder DUT(a,b,cin,sum,carry);
//process to initialize variables at 0ns
	initial begin
		{a,b,cin}=0;
		end
//to generate stimulus using for loop
	initial begin
		for(i=0;i<8;i=i+1)
		begin
		{a,b,cin}=i;
		#10;
		end
		end	
//to monitor changes in variables	
	initial 
		$monitor("Input a=%b b=%b cin=%b Output sum=%b carry=%b",a,b,cin,sum,carry);
//terminalte stimulation after 100ns
	initial #100 $finish;
endmodule
	
