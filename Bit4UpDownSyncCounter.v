module TFF( input clk,
           input reset,
           input t,
           output reg q);
  always @(posedge clk , posedge reset)
    begin
    if(reset)
      q<=0;
  else 
    if(t)
      q<=~q;
      else 
        q<=q;
    end
endmodule
    
module Bit4UpDownSyncCounter(input clk,
                         input reset,
                         input t,
                             input up,
                             input down,
                         output  reg [3:0] q);
  
  always @(posedge clk,posedge reset)
    begin
    	if(reset)
      q<=0;
 		 else
    
    	if(t)  
       		 if(up)
     		 	q<=q+1;
  		
         	 else if(down)
          		  q<=q-1;
     	 else 
      		q<=q;
            
       end
endmodule
  
//   wire a1,a2;
//   TFF T1(clk,reset,t,q[0]);
//   TFF T2(clk,reset,q[0],q[1]);
//   and A1(a1,q[0],q[1]);
//   TFF T3(clk,reset,a1,q[2]);
//   and A2(a2,a1,q[2]);
//   TFF T4(clk,reset,a2,q[3]);
// endmodule
module Bit4SyncUpCounter_tb();
  reg t,rst,clk,up,down;
  wire [3:0]q;
  
  Bit4UpDownSyncCounter DUT(clk,rst,t,up,down,q);
  
  initial begin
    clk=1'b0;
     forever #5 clk=~clk;
  end
  
  task initialize;
    begin
      {t,up,down,rst}=0;
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
  
  task Up;
    begin
    up=1;
    down=0;
    end
  endtask
  
  task Down;
    begin
    down=1;
    up=0;
    end
  endtask
  
   initial begin
        initialize;
        reset; 
     Up;
     tin(1);
     
        #200;
     reset;
      Down;
     tin(1);
     #200 $finish;
     
      end
  
    initial
        $monitor("reset=%b clk=%b t=%b q=%b time=%0t",rst,clk,t,q,$time);
        
endmodule