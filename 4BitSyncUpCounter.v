module tff( input clk,
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
    
module Bit4SyncUpCounter(input clk,
                         input reset,
                         input t,
                         output  [3:0] q);
  
//   always @(posedge clk,posedge reset)
//     begin
//     if(reset)
//       q<=0;
//   else
//     begin
//     if(t)
//       q<=q+1;
//   	else
//       q<=q;
//       end end
// endmodule
  
  wire a1,a2;
  tff T1(clk,reset,t,q[0]);
  tff T2(clk,reset,q[0],q[1]);
  and A1(a1,q[0],q[1]);
  tff T3(clk,reset,a1,q[2]);
  and A2(a2,a1,q[2]);
  tff T4(clk,reset,a2,q[3]);
endmodule


//testbench

module Bit4SyncUpCounter_tb();
  reg t,rst,clk;
  wire [3:0]q;
  
  Bit4SyncUpCounter DUT(clk,rst,t,q);
  
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
     tin(1);
     
        #200 $finish;
      end
  
    initial
        $monitor("reset=%b clk=%b t=%b q=%b time=%0t",rst,clk,t,q,$time);
        
endmodule