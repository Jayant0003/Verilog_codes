module RamSPort_16x8  # (parameter width=8, depth=16, add_bus=4)
  					(input we,
                     input re,
                     input [add_bus-1:0] add,
                     inout [width-1:0] data);
  reg [width-1:0] mem [depth-1:0];

  always @(*)
    if(we && !re)
      mem[add]=data;
//   if(re && !we)
//     data=mem[add];
  assign data=(re&&!we)?mem[add]:8'hzz;
endmodule
      
module RamSPort_16x8_tb();
  wire [7:0] data;
  reg we,re;
  reg [3:0] add;
  reg [7:0] temp;
  
  RamSPort_16x8 DUT(we,re,add,data);
  
  assign data=(we&!re)?temp:8'hzz; //wire data acts like input during write OP
 
  
 task initialize;
   {we,re,temp}=0;
 endtask
  
  task write(input w,input [3:0] a,input [7:0] d);
    begin
      we=w;
      re=0;
      temp=d;
      add=a;
    end
  endtask
  task read(input r,input [3:0] a);
    begin
      re=r;
      we=0;
      add=a;
    end endtask
  
  initial begin
    initialize;
    #5 write(1,4'b1101,8'd14);
    #5 write(1,4'b1001,8'd10);
    #5 write(1,4'b0101,8'd4);
    #5 read(1,4'b1101);
    #5 read(1,4'b0101);
  end
  initial
    $monitor("we=%b re=%b add=%b data=%b",we,re,add,data);
endmodule   
      

  

