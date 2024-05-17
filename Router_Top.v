`include "Router_FSM.v"
`include "Router_Synchronizer.v"
`include "Router_FIFO.v"
`include "Router_Register.v"
module Router_Top(input clk,
                  input resetn,
                  input [7:0] din,
                  input pkt_valid,
                  input read_enb_0,
                  input read_enb_1,
                  input read_enb_2,
                  output [7:0] dout0,
                  output [7:0] dout1,
                  output [7:0] dout2,
                  output vld_out_0,
                  output vld_out_1,
                  output vld_out_2,
                  output err,
                  output busy );

wire parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,full_0,full_1,full_2;
wire [2:0] write_enb;

  wire [7:0]dout;
  
  Router_FSM m1(clk,resetn,pkt_valid,parity_done,din[1:0],soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,busy,write_enb_reg,rst_int_reg,lfd_state);
  
  Router_Synchronizer  m2(detect_add,din[1:0],write_enb_reg,clk,resetn,read_enb_0,read_enb_1,read_enb_2,fifo_empty_0,fifo_empty_1,fifo_empty_2,full_0,full_1,full_2,vld_out_0,vld_out_1,vld_out_2,write_enb,fifo_full,soft_rst_0,soft_rst_1,soft_rst_2);
  
Router_Register m3(clk,resetn,pkt_valid,din,fifo_full,rst_int_reg,detect_add,lfd_state,laf_state,full_state,ld_state,parity_done,low_pkt_valid,err,dout);
 
  Router_FIFO m4(clk,resetn,write_enb[0],soft_rst_0,read_enb_0,dout,lfd_state,fifo_empty_0,full_0,dout0);
 
  Router_FIFO m5(clk,resetn,write_enb[1],soft_rst_1,read_enb_1,dout,lfd_state,fifo_empty_1,full_1,dout1);
  
  Router_FIFO m6(clk,resetn,write_enb[2],soft_rst_2,read_enb_2,dout,lfd_state,fifo_empty_2,full_2,dout2);

endmodule


 
module Router_Top_tb();
  reg clk,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2;
  reg [7:0] din;
  wire [7:0] dout0,dout1,dout2;
  wire vld_out_0,vld_out_1,vld_out_2,err,busy;
  integer i;
  Router_Top DUT(clk,resetn,din,pkt_valid,read_enb_0,read_enb_1,read_enb_2,dout0,dout1,dout2,vld_out_0,vld_out_1,vld_out_2,err,busy);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize; 
    {din,pkt_valid,read_enb_0,read_enb_1,read_enb_2}=0;
  endtask
  
  task reset; begin
    @(negedge clk)
    resetn=1'b0;
    @(negedge clk)
    resetn=1'b1;
  end endtask
  
  task pkt_gen_14; 
    reg [7:0] parity,header,payload;
    reg [5:0] payload_len;
    reg [1:0] addr;
    
    begin
      @(negedge clk)
      wait(~busy)
      @(negedge clk)
      payload_len=6'd14;
      addr=2'b00;
      header={payload_len,addr};
      parity=0;
      din=header;
      pkt_valid=1;
      parity=parity^header;
      @(negedge clk)
      wait(~busy)
      for(i=0;i<payload_len;i=i+1) begin
        @(negedge clk)
        wait(~busy)
        payload=($random)%256;
        din=payload;
        parity=parity^din;
      end
      @(negedge clk)
      wait(~busy)
      pkt_valid=0;
      din=parity;
    
    end endtask     
  
  initial begin
    initialize;
   #10 reset;
    fork
      pkt_gen_14;
      begin
        wait(vld_out_0)
        read_enb_0=1'b1;
      end
    join
    
  end
  initial 
    #500 $finish;
  
  initial
    $monitor("time=%0t clk=%b resetn=%b din=%b pkt_valid=%b read_enb_0=%b dout0=%b vld_out_0=%b busy=%b",$time,clk,resetn,din,pkt_valid,read_enb_0,dout0,vld_out_0,busy);  
  
  
endmodule

