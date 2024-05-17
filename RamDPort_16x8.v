module RamDPort_16x8(input clk,
                     input reset,
  					 input wr,
                     input rd,
                     input [7:0] din,
                     input [3:0] w_add,
                     input [3:0] r_add,
                     output reg [7:0] dout);
  reg [7:0] mem[0:15];
integer i;
  
  always @(posedge clk) begin
    if(reset) begin
      dout<=0;
	for(i=0;i<16;i=i+1)
	mem[i]<=0; end
    else
      if(wr)
        mem[w_add]<=din;
      if(rd)
      dout<=mem[r_add];
       
  end 
endmodule       
        
     module AsyncRamDP_8x16_tb();
  wire [15:0] dout;
  reg re,we,reset,w_clk,r_clk;
  reg [2:0] w_add,r_add;
  reg [15:0] din;
  integer i,j,a,b;
  
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
  
    task write(input w,input [2:0] wadd, input [15:0]d);
    begin
    @(negedge w_clk)
    we=w;
    w_add=wadd;
    din=d;
    end endtask
  
    task read(input r,input [2:0] radd);
    begin
      @(negedge r_clk)
    re=r;
    r_add=radd;
    end endtask
  
  initial begin
    initialize;
    #5 rst;
    #10 for(i=0;i<8;i=i+1) begin
      a=i;
      write(1,a,a+20);
      #5;
    end
    #10 for(j=0;j<8;j=j+1) begin
      b=j;
      read(1,b);
      #5;
    end
    #40 $finish;
  end
    initial
    $monitor("reset=%b w_clk=%b we=%b w_add=%b din=%b r_clk=%b re=%b r_add=%b dout=%b",reset,w_clk,we,w_add,din,r_clk,re,r_add,dout);
endmodule
   
    
    
  
     



