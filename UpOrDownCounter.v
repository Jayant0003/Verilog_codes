module UpOrDownCounter( Clk,reset,UpOrDown,Count);
    input Clk,reset,UpOrDown;    
    output [3 : 0] Count;   
    reg [3 : 0] Count = 0;  
    
     always @(posedge(Clk) or posedge(reset))
     begin
        if(reset == 1) 
            Count <= 0;
   	else if(UpOrDown == 1)  begin
                if(Count == 15)
                    Count <= 0;
                else
                    Count <= Count + 1; 
	    	end
	else  if(Count == 0)
                    Count <= 15;
         else
                    Count <= Count - 1; 
     end      
endmodule
module UpOrDownCounter_tb();  
    reg clk;
    reg rst;
    reg UpOrDown;    
    wire [3:0] Count;
    
    UpOrDownCounter DUT(clk,rst,UpOrDown,Count );
      initial begin
    clk=1'b0;
     forever #5 clk=~clk;
  end

task rst_1;
    begin
      @(negedge clk)
      rst=1'b1;
      @(negedge clk)
      rst=1'b0;
      end 
endtask
    initial begin
         rst_1;
        #10;
        UpOrDown = 1;
        #300;       
        UpOrDown = 0;
        #300 $finish;     
         
    end
  initial
    $monitor("reset=%b clk=%b upOrDown=%b Count=%b time=%0t",rst,clk,UpOrDown,Count,$time);
      
endmodule
