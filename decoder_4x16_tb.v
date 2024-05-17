module decoder_4x16(input en,
                    input [3:0] in,
                    output [15:0] out);
  assign out= en ? 1<<in :0;
endmodule
module decoder_4x16_tb();
  reg en;
  reg [3:0] in;
  wire [15:0] out;
  integer i;
  decoder_4x16 DUT(.en(en),.in(in),.out(out));
  initial
    begin
    {en,in}=0;
      $monitor("Input en=%b, in=%b Output out=%b",en,in,out);
      for(i=0;i<32;i=i+1)
               begin
                 {en,in}=i;
                 #10;
               end
     end
endmodule
