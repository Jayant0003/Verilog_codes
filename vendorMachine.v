module vendorMachine(input clk,
                     input reset,
                     input i,
                     input j,
                     output x,
                     output y);
  reg [2:0] ps,ns;
  parameter IDLE=3'b000,
  			S1=3'b001,
  			S2=3'b010,
  			S3=3'b011,
  			S4=3'b100;
  always @(posedge clk)
    begin
    if(reset)
      	ps<=IDLE;
    else 
      ps<=ns;
    end
  
  always @(i,j,ps)
    begin
      case(ps)
        IDLE: begin 
          		 if({i,j}==2'b0X) ns<=IDLE;
                 else if({i,j}==2'b10) ns<=S1;
                 else if({i,j}==2'b11) ns<=S2;
                end
         S1: begin
           if({i,j}==2'b0x) ns<=S1;
               else if({i,j}==2'b10) ns<=S2;
               else if({i,j}==2'b11) ns<=S3;
             end
         S2: begin
               if({i,j}==2'b0x) ns<=S2;
           else if({i,j}==2'b10) ns<=S3;
                else if({i,j}==2'b11) ns<=S4;
              end
          S3: ns<=IDLE;
          S4: ns<=IDLE;
          default: ns<=IDLE;
         endcase
     end
     
assign x=(ps==S3)||(ps==S4);
assign y=(ps==S4);
                       
endmodule
 module vendorMachine_tb();
  reg clk,reset,i,j;
  wire x,y;
  
  vendorMachine DUT(clk,reset,i,j,x,y);
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;
    {reset,i,j}=0;
  endtask
  
  task rst; begin
    @(negedge clk) reset=1'b1;
    @(negedge clk) reset=1'b0;
    end
  endtask
  
  task din(input [1:0]k);
    begin
    @(negedge clk)
      {i,j}=k;
  end endtask
  
  initial begin
    initialize;
    rst;
      #5 din(2'b0x);
      #5 din(10);
     #5 din(11);
     #5 din(10);
     #5 din(11);
    #5 din(11);
      #10 $finish;
    end
    initial 
      $monitor("reset=%b clk=%b i=%b j=%b x=%b y=%b",reset,clk,i,j,x,y);
      endmodule
      