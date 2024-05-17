module encoder_16x4(input en,
                    input [15:0] in,
                    output reg [3:0] out);
  //assign out= en ? in>>1 :0;
  always @(in,en) 
    begin 
      if(en==1)
        begin
          if(in[0]==1)out=4'b0000;
          if(in[1]==1)out=4'b0001;
          if(in[2]==1)out=4'b0010;
          if(in[3]==1)out=4'b0011;
          if(in[4]==1)out=4'b0100;
          if(in[5]==1)out=4'b0101;
          if(in[6]==1)out=4'b0110;
          if(in[7]==1)out=4'b0111;
          if(in[8]==1)out=4'b1000;
          if(in[9]==1)out=4'b1001;
          if(in[10]==1)out=4'b1010;
          if(in[11]==1)out=4'b1011;
          if(in[12]==1)out=4'b1100;
          if(in[13]==1)out=4'b1101;
          if(in[14]==1)out=4'b1110;
          if(in[15]==1)out=4'b1111;
        end
    end
endmodule

module encoder_16x4_tb();
  reg en;
  reg [15:0] in;
  wire [3:0] out;
  integer i;
  encoder_16x4 DUT(.en(en),.in(in),.out(out));
  initial
    begin
    {en,in}=0;
      $monitor("Input en=%b, in=%b Output out=%b",en,in,out);

        en=1;
        in=in+1;
      	#10;

      for(i=0;i<15;i=i+1)
               begin
             
                 in=in<<1;
                 #10;
               end
      end 
endmodule
