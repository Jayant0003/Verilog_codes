// Code your design here
module DFF(input d,
           input reset,
           input clk,
           output reg q);
  always @(posedge clk or posedge reset)
    begin
    if(reset)
      q<=1'b0;
  else
    q<=d;
    end
endmodule

module TFF(input t,
           input reset,
           input clk,
           output  q);
  wire inp;
 assign inp=t^q;
  DFF d1(inp,reset,clk,q);
endmodule
// Code your testbench here
// or browse Examples
module TFF_tb();
  reg t,rst,clk;
  wire q;
  TFF DUT(t,rst,clk,q);
  initial begin
    clk=1'b0;
     forever #5 clk=~clk;
  end
  
  task initialize;
    begin
      {t,rst}=0;   
    end endtask
  
  task reset;
    begin
      @(negedge clk)
      rst=1'b1;
      @(negedge clk)
      rst=1'b0;
      end endtask
      
  task tin(input k);
    @(negedge clk)
    t=k;
      endtask
      initial begin
        initialize;
        reset;
        #5;
        tin(1'b1); 
        #5;
        tin(1'b0);  
        #5;
        tin(1'b1); 
        #5;
         tin(1'b0);
        #5;
        tin(1'b1);
        #5;
         reset;
        $finish;
      end
      initial
        $monitor("reset=%b clk=%b t=%b q=%b time=%0t",rst,clk,t,q,$time);
        
endmodule
