module dff(input clk,
           input d,
           input reset,
           output reg q);
  //always@(posedge clk or posedge reset)//+ve edge triggered dff with enable High asynchronous reset
  always @(posedge clk )//+ve edge triggered dff with synchronous reset
    if(reset)
      q<=0;
  else
    q<=d;
endmodule
module dff_tb();
reg d,clk,reset;
  wire q;
  dff DUT(clk,d,reset,q);
  initial begin
    clk=1'b0;
    forever #10 clk=~clk;
   
  end
  task initialize;
    begin
      d=0;
      clk=0;
      reset=0;
    end
  endtask
  
  task rst;//to apply reset on design
    begin
      @(negedge clk)
      reset=1'b1;
      @(negedge clk)
      reset=1'b0;
    end endtask
  task din(input k);
    begin
      @(negedge clk)
      d=k;
    end endtask
  initial begin
    initialize;
    rst;
    din(1'b1);
    din(1'b0);
    din(1'b0);
    din(1'b0);
    din(1'b1);
    din(1'b1);
    din(1'b1);
    rst;
    #10;
    $finish;
  end
   initial   //use monitor task in parallel initial block 
      $monitor("clk=%b reset=%b d=%b q=%b",clk,reset,d,q);
endmodule
    
