module Switch(input B1,
              input B2,
              input B3,
              input s,
              input s1,
              input s2,
              output  out);
  reg out1,out2;
  reg a=1'b0;
  reg b=1'b1;
  
  always @(*) begin
    case({s1,s2})
      2'b00 : out1=B1;
      2'b01 : out1=B2;
      2'b10 : out1=B3;
      2'b11: out1=0;
    endcase end
  
  always @(*) begin
    case(s)
      1'b0 : out2=a;
      1'b1 : out2=b;
      
    endcase end
  
  and a1(out,out1,out2);
 
endmodule

module Switch_tb();
  wire out;
  reg B1,B2,B3,s,s1,s2;
  
  Switch DUT(B1,B2,B3,s,s1,s2,out);
  
  task initialize;
    {B1,B2,B3,s,s1,s2}=0;
  endtask
  
  task din(input i,input j,input k,input l,input m,input n); begin
    B1=i;
    B2=j;
    B3=k;
    s1=l;
    s2=m;
    s=n;
  end
  endtask
  
  initial begin
    initialize;
    #5 din(1,1,1,0,1,0);
    #10 din(1,1,0,1,1,1);
    #10 din(0,1,1,1,0,1);
    #10 din(1,0,0,1,0,1);
    #10 din(1,1,0,0,1,0);
    #10 din(1,1,0,0,1,1);
    #10 din(1,0,0,0,0,1);
    #20 $finish;
  end
  initial 
    $monitor("B1=%b B2=%b B3=%b s1=%b s2=%b s=%b out=%b",B1,B2,B3,s1,s2,s,out);
endmodule
