module alu(input [3:0] a_in,
		input oe,
		input [3:0] b_in,
		input [3:0] cmd,
		output [7:0] out);
	parameter 	ADD=4'b0000,
		  	INC=4'b0001,
			DEC=4'b0010,
			SUB=4'b0011,
			MUL=4'b0100,
			INV=4'b0101,
			DIV=4'b0110,
			AND=4'b0111,
			OR=4'b1000,
			XNOR=4'b1001,
			XOR=4'b1010,
			NAND=4'b1011,
			NOR=4'b1100,
			SHIFTR=4'b1101,
			SHIFTL=4'b1110,
			BUFF=4'b1111;
reg [7:0] out_temp;
always @(cmd,a_in,b_in)
 begin 
	case(cmd)
		ADD :out_temp=a_in+b_in;
		INC :out_temp=a_in+1;
		DEC :out_temp=b_in-1;
		SUB :out_temp=a_in-b_in;
		MUL :out_temp=a_in*b_in;
		INV :out_temp=~a_in;
		DIV :out_temp=a_in/b_in;
		AND :out_temp=a_in&b_in;
		OR :out_temp=a_in|b_in;
		XNOR :out_temp=a_in~^b_in;
		XOR : out_temp=a_in ^ b_in;
		NAND :out_temp=~(a_in & b_in);
		NOR :out_temp=~(a_in | b_in);
		SHIFTR :out_temp=a_in>>1;
		SHIFTL :out_temp=a_in<<1;
		BUFF :out_temp=a_in;
endcase
end
assign out=oe?out_temp:'bz;
endmodule

module alu_tb();
reg [3:0] a_in,b_in;
reg oe;
reg [3:0] cmd;
wire [7:0] out;

integer i;
parameter 	        ADD=4'b0000,
		  	INC=4'b0001,
			DEC=4'b0010,
			SUB=4'b0011,
			MUL=4'b0100,
			INV=4'b0101,
			DIV=4'b0110,
			AND=4'b0111,
			OR=4'b1000,
			XNOR=4'b1001,
			XOR=4'b1010,
			NAND=4'b1011,
			NOR=4'b1100,
			SHIFTR=4'b1101,
			SHIFTL=4'b1110,
			BUFF=4'b1111;
reg [7*7:0] str_cmd;
alu DUT(a_in,oe,b_in,cmd,out);
task initialize;
	begin
		{a_in,b_in,oe,cmd}=0;
	end
endtask

task en_oe(input i);
	begin 
		oe=i;
	end
endtask
task inputs(input [3:0] j,k);
	begin 
		a_in=j;
		b_in=k;
	end
endtask
task command(input [3:0] l);
	begin 
		cmd=l;
	end
endtask
task delay;
	#10;
endtask

always @(cmd)
	begin
		case(cmd)
		ADD :str_cmd="ADD";
		SUB :str_cmd="SUB";
		MUL :str_cmd="MUL";
		DIV :str_cmd="DIV";
		INC :str_cmd="INC";
		DEC :str_cmd="DEC";
		NAND :str_cmd="NAND";
		NOR :str_cmd="NOR";
		AND :str_cmd="AND";
		OR :str_cmd="OR";
		XNOR :str_cmd="XNOR";
		XOR :str_cmd="XOR";
		SHIFTR :str_cmd="SHIFTR";
		SHIFTL :str_cmd="SHIFTL";
		BUFF :str_cmd="BUFF";
		INV :str_cmd="INV";
	endcase
	end
initial begin
	initialize;
	en_oe(1'b1);
	inputs(4'b1101,4'b1001);
	for(i=0;i<16;i=i+1)
		begin
		command(i);
		delay;
		end
	en_oe(1'b0);
	command(5);
	end
initial
	$monitor("inputs a=%b b=%b command=%0s Output out=%b",a_in,b_in,str_cmd,out);
endmodule

