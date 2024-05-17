module Router_Synchronizer(input detect_add,
                    input [1:0] din,
                    input write_enb_reg,
                    input clk,
                    input resetn,
                    input read_enb_0,
                    input read_enb_1,
                    input read_enb_2,
                    input empty_0,
                    input empty_1,
                    input empty_2,
                    input full_0,
                    input full_1,
                    input full_2,
		    output vld_out_0,
		    output vld_out_1,
                    output vld_out_2,
                    output reg [2:0] write_enb,
                    output reg fifo_full,
                    output reg soft_reset_0,
                    output reg soft_reset_1,
                    output reg soft_reset_2);
  // int_add_reg logic
  reg [1:0] int_add_reg;
  reg [4:0] timer_0,timer_1,timer_2;
  
  
  always @(posedge clk) begin
    if(~resetn)
      int_add_reg<=0;
    else if(detect_add)
      int_add_reg<=din;
  end
  
  // write_enb logic
  always @(*) begin
    write_enb=3'b000;
    if(write_enb_reg) begin
      case(int_add_reg)
        2'b00 : write_enb=3'b001;
        2'b01 : write_enb=3'b010;
        2'b10 : write_enb=3'b100;
        default : write_enb=3'b000;
      endcase
    end end
  
  // FIFO Full
  always @(*) begin
    case(int_add_reg)
      2'b00 : fifo_full=full_0;
      2'b01 : fifo_full=full_1;
      2'b10 : fifo_full=full_2;
      default : fifo_full=1'b0;
    endcase 
  end 
  
assign vld_out_0=~empty_0;
assign vld_out_1=~empty_1;
assign vld_out_2=~empty_2;
  
  //timer 0 & soft_rst_0 logic
  always @(posedge clk) begin
    if(~resetn) begin
      timer_0<=0;
      soft_reset_0<=0; end
    else if(vld_out_0) begin
      
      if(!read_enb_0) begin
        if(timer_0 == 5'd29) begin
          soft_reset_0<=1'b1;
          timer_0<=0; end
        else begin
          
          soft_reset_0<=0;
          timer_0<=timer_0+1; end
        end end end
    
   //timer 1 & soft_rst_1 logic
     always @(posedge clk) begin
    if(~resetn) begin
      timer_1<=0;
      soft_reset_1<=0; end
       else if(vld_out_1) begin
         if(!read_enb_1) begin
           if(timer_1 == 5'd29) begin
          soft_reset_1<=1'b1;
          timer_1<=0; end
        else begin
          soft_reset_1<=0;
          timer_1<=timer_1+1'b1; end
        end end end
  // timer_2 & soft_rest_2 logic
   always @(posedge clk) begin
    if(~resetn) begin
      timer_2<=0;
      soft_reset_2<=0; end
     else if(vld_out_2) begin
       if(!read_enb_2) begin
         if(timer_2 == 5'd29) begin
          soft_reset_2<=1'b1;
          timer_2<=0; end
        else begin
          soft_reset_2<=0;
          timer_2<=timer_2+1'b1; end
        end end end
endmodule
    
   

   

    
     
     
      
      
      
  module Synchronizer_tb();
  reg detect_add,write_enb_reg,clk,resetn;
  reg read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
  reg [1:0] din;
  wire [2:0] write_enb;
  wire fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,vld_out_1,vld_out_2;
  
  Router_Synchronizer DUT(detect_add,din,write_enb_reg,clk,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,vld_out_0,vld_out_1,vld_out_2,write_enb,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;
    begin
      {detect_add,din,write_enb_reg,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2}=0;
      {empty_0,empty_1,empty_2}={1'b1,1'b1,1'b1};
    end endtask
  
  task reset; begin
    @(negedge clk)
    resetn=1'b0;
    @(negedge clk)
    resetn=1'b1;
  end endtask
    
    
  task addr(input [1:0] m); begin
    @(negedge clk) begin
    detect_add=1;
     write_enb_reg=1;
      din=m; end
    @(negedge clk) begin
    detect_add=1'b0;
      write_enb_reg=1'b0; end
  end endtask
  
//   task write; begin
//     @(negedge clk)
//     write_enb_reg=1'b1;
//     @(negedge clk)
//     write_enb_reg=1'b0;
//   end endtask
  
  task stimulus; begin
    @(negedge clk)
    {full_0,full_1,full_2}=3'b010;
    @(negedge clk)
    {read_enb_0,read_enb_1,read_enb_2}=3'b010;
    @(negedge clk)
    {empty_0,empty_1,empty_2}=3'b011;
  end endtask
  
  initial begin
    
    initialize;
    reset;
   
    #10 addr(2'b01);
   
    
    #10 stimulus;
    #500 $finish;
  end
  
  initial 
    $monitor("time=%0t clk=%b resetn=%b detect_add=%b din=%b write_enb_reg=%b read_enb_0=%b read_enb_1=%b read_enb_2=%b empty_0=%b empty_1=%b empty_2=%b full_0=%b full_1=%b full_2=%b write_enb=%b fifo_full=%b soft_reset_0=%b soft_rst_1=%b soft_rst_2",$time,clk,resetn,detect_add,din,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,write_enb,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);
 
endmodule

   
