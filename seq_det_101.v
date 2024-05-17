module seq_det_101(input clk,
                   input reset,
                   input i,
                   output out);
  parameter IDLE=2'b00,
  			S1=2'b01,
  			S2=2'b10,
  			S3=2'b11;
  
  reg [1:0] ps,ns;
  
  always @(posedge clk)
    begin
    if(reset)
      ps<=0;
  else
    ps<=ns;
    end
  
  always @(i,ps)
    begin
      case(ps)
        IDLE: if(i) ns=S1;
        		else ns=ps;
        S1: if(i) ns=ps;
        	   else ns=S2;
        S2: if(i) ns=S3;
        	   else ns=IDLE;
        S3: if(i) ns=S1;
               else ns=IDLE;
        default: ns=IDLE;
      endcase
        end
        
        assign out=(ps==S3);
 endmodule
  
  module seq_det_101_tb();
  reg clk,reset,i;
  wire out;
  
  seq_det_101 DUT(clk,reset,i,out);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;
    {reset,i}=0;
  endtask
  
  task rst;
    begin
    @(negedge clk) reset=1'b1;
    @(negedge clk) reset=1'b0;
    end
  endtask
  
  task din(input k);
    @(negedge clk) i=k;
  endtask
  
  initial begin
    initialize;
    rst;
   #5 din(1'b1);
     #5din(1'b1);
    #5 din(1'b0);
    #5 din(1'b1);
    #5 din(1'b0);
    #5 din(1'b1);
    #10 $finish;
  end
  
  initial 
    $monitor("reset=%b clk=%b i=%b out=%b",reset,clk,i,out);
endmodule
