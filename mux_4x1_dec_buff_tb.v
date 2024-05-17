module decoder_2x4(input [1:0] in,
                   output [3:0] out);
  assign out=1<<in;
endmodule

module buffer(input en,
              input in,
              output out);
  assign out=en?in:1'bz;
endmodule
module mux_4x1_dec_buff(input [3:0] in,
                          input [1:0] sel,
                          output out);
  wire [3:0] w;
  decoder_2x4 dec(.in(sel),.out(w));
  buffer b1(w[0],in[0],out);
  buffer b2(w[1],in[1],out);
  buffer b3(w[2],in[2],out);
  buffer b4(w[3],in[3],out);
endmodule

module mux_4x1_dec_buff_tb();
  reg [3:0] in;
  reg [1:0] sel;
  wire out;
  integer i;
  mux_4x1_dec_buff DUT(in,sel,out);
  initial begin
    {in,sel}=0;
    $monitor("input in=%b,sel=%b Output is out=%b",in,sel,out);
   	in=4'b1011;
    for(i=32;i<40;i=i+1)
    begin
      {in,sel}=i;
      #10;
    end
  end
endmodule
