module AsyncRamDP_8x16 #(parameter width=16,depth=8,add_bus=3)
  (input reset,
   input w_clk,
   input we,
   input [add_bus-1:0] w_add,
   input [width-1:0] din,
   input r_clk,
   input re,
   input [add_bus-1:0] r_add,
   output reg [width-1:0] dout);
  integer i,j;
  reg [width-1:0] mem [0:depth-1];
  
  always @(posedge w_clk,posedge reset)
    begin
    if(reset) begin
      dout<=0;
      for(i=0;i<8;i=i+1)   		 
           mem[i]<=0;  end       
      else
        if(we)
          mem[w_add]<=din;
    end
  always @(posedge r_clk,posedge reset)
    begin
      if(reset)
        dout<=0;
      else
        if(re)
          dout<=mem[r_add];
    end
endmodule
  		
  module AsyncRamDP_8x16_tb();
  wire [15:0] dout;
  reg re,we,reset,w_clk,r_clk;
  reg [2:0] w_add,r_add;
  reg [15:0] din;
  integer i,j;
  
  AsyncRamDP_8x16 DUT(reset,w_clk,we,w_add,din,r_clk,re,r_add,dout);
  
  initial begin
    w_clk=1'b0;
    forever #5 w_clk=~w_clk;
  end
  
  initial begin
    r_clk=1'b0;
    forever #5 r_clk=~r_clk;
  end
  
 task initialize;
   {re,we,reset,w_add,r_add,din}=0;
 endtask
  
  task rst;
    begin
    @(negedge w_clk) reset=1'b1;
    @(negedge w_clk) reset=1'b0;
      end endtask
  
  task write(input w,input wadd,input d);
    begin
    @(negedge w_clk)
    we=w;
    w_add=wadd;
    din=d;
    end endtask
  
  task read(input r,input radd);
    begin
      @(negedge r_clk)
    re=r;
    r_add=radd;
    end endtask
  
  initial begin
    initialize;
    #5 rst;
    #10 for(i=0;i<8;i=i+1) begin
      write(1,i,i+20);
      #5;
    end
    #10 for(j=0;i<8;j=j+1) begin
      read(1,j);
      #5;
    end
    #40 $finish;
  end
endmodule
   
    
    
  
  

  
      
      
      

  


 
  

