module priority_encoder_8x3(input [7:0] in,
				output reg [2:0] out);
always @(*) begin
casex(in)
	'b1 : out='b0;
	'b1x : out='b001;
	'b1xx : out='b010;
	'b1xxx : out='b011;
	'b1xxxx : out='b111;
	'b1xxxxx : out='b101;
	'b1xxxxxx : out='b110;
	'b1xxxxxxx : out='b111;
	default : out='bz;
endcase
end
endmodule

module priority_encoder_8x3_tb();
reg [7:0] in;
wire [2:0] out;
integer i;
priority_encoder_8x3 DUT(in,out);
initial begin
	{in}=0;
	$monitor("Input is in=%b Output is out=%b",in,out);
	for(i=0;i<8;i=i+1)
	begin
	in=(in+3'b110)<<i;
	#10;
	end
	end
endmodule
