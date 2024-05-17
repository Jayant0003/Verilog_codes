module Bit4SyncMod12UpCounter(input clk,
                              input reset,
                              input load,
                              input [3:0] d_in,
                              output reg [3:0] count);
  always @(posedge clk)
    begin
      if(reset)
        count<=4'b0;
      else
        if(load)
          count<=d_in;
      	else
          if(count==4'b1011)
            count<=4'b0;
      	  else
            count<=count+1;
    end
  
  
endmodule
  

module Bit4SyncMod12UpCounter_tb();
  reg rst,clk,load;
  reg [3:0] d_in;
  wire [3:0] count;
  
  Bit4SyncMod12UpCounter DUT(clk,rst,load,d_in,count);
  
  initial begin
    clk=1'b0;
     forever #5 clk=~clk;
  end
  
  task initialize;
    begin
      {d_in,load,rst}=0;   
    end endtask
  
  task reset;
    begin
      @(negedge clk);
      rst=1'b1;
      @(negedge clk);
      rst=1'b0;
      end endtask
      
  task din(input l,input k);
    begin
           
      @(negedge clk);
   		 d_in=k;
         load=l;
    end
  endtask
  
   initial begin
        initialize;
        reset;
        #5;
     din(1'b0,4'd10); 
        #5;
     din(1'b1,4'd8);  
      
        
         
        #100 $finish;
      end
      initial
        $monitor("reset=%b clk=%b load=%b d_in=%b count=%b time=%0t",rst,clk,load,d_in,count,$time);
        
endmodule