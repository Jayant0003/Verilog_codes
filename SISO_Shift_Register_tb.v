module SISO_Shift_Register(input clk,
                           input reset,
                           input si,
                           output reg so);
  
  reg [3:0] temp;
  always @(posedge clk)
    begin
    if(reset)
      temp<=4'b0;
  else
    begin
      so<=temp[0];
      temp<={si,temp[3:1]};
       
    end end
endmodule 

module SISO_Shift_Register_tb();
  reg clk,reset,si;
  wire so;
  
  SISO_Shift_Register DUT(clk,reset,si,so);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;
    {reset,si}=0;
  endtask
  
  task rst;
    begin
    @(negedge clk) reset=1'b1;
    @(negedge clk) reset=1'b0;
    end
  endtask
  
  task din(input k);
    @(negedge clk)
    si=k;
  endtask
  
  initial begin
    initialize;
    rst;
    #5 din(1);    
    #5 din(0);
    #5 din(1);
    #5 din(0);
    #50 $finish;
  end
  initial 
    $monitor("reset=%b clk=%b si=%b so=%b",reset,clk,si,so);
endmodule
