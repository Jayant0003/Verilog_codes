module Router_Register(input clk,
                       input resetn,
                       input pkt_valid,
                       input [7:0] din,
                       input fifo_full,
                       input rst_int_reg,
                       input detect_add,
                       input lfd_state,
                       input laf_state,
                       input full_state,
                       input ld_state,
                       output reg parity_done,
                       output reg low_pkt_valid,
                       output reg err,
                       output reg [7:0] dout);
  
  reg [7:0] header_byte,fifo_full_state_byte;
  reg [7:0] packet_parity,internal_parity;
  
  // dout logic
  always @(posedge clk) begin
    if(~resetn)
      dout<=0;
    else if(lfd_state)
      dout<=header_byte;
    else if(ld_state && ~fifo_full)
      dout<=din;
    else if(laf_state)
      dout<=fifo_full_state_byte;
    else 
      dout<=dout;
  end
  
  // header_byte and FIFO_full_state_byte logic
  always @(posedge clk) begin
    if(~resetn)
    {header_byte,fifo_full_state_byte}<=0;
    else begin
      if(detect_add && pkt_valid)
      header_byte<=din;
    else if(fifo_full && ld_state)
      fifo_full_state_byte<=din; end
  end
  
  
  // parity_done logic
  always @(posedge clk) begin
    if(~resetn)
      parity_done<=0;
    else begin
      if(ld_state && ~pkt_valid && ~fifo_full)
        parity_done<=1;
      else if(laf_state && low_pkt_valid && ~parity_done)
        parity_done<=1;
      else begin
        if(detect_add)
          parity_done<=0;end end
  end
  
  // low_pkt_valid logic
  always @(posedge clk) begin
    if(~resetn)
      low_pkt_valid<=0;
    else begin
      if(rst_int_reg)
        low_pkt_valid<=0;
      if(ld_state && ~pkt_valid)
        low_pkt_valid<=1;
    end end  
  
  //packet_parity(received parity) logic
  always @(posedge clk) begin
    if(~resetn)
      packet_parity<=0;
    else begin
      if((ld_state && pkt_valid && ~fifo_full) || (laf_state&&low_pkt_valid&&~parity_done))
        packet_parity<=din;
      else if(~pkt_valid && rst_int_reg)
        packet_parity<=0;
      else begin
        if(detect_add)
          packet_parity<=0; end end
  end
  
  
  
  //internal_parity logic
  always @(posedge clk) begin
    if(~resetn)
      internal_parity<=0;
    else begin
      if(detect_add)
        internal_parity<=0;
      else if(lfd_state)
        internal_parity<=header_byte;
      else if(ld_state && pkt_valid && ~full_state)
        internal_parity<=internal_parity^din;
      else if(~pkt_valid && rst_int_reg)
        internal_parity<=0;
    end end
  
  
  //error logic
  always @(posedge clk) begin
    if(~resetn)
      err<=0;
    else begin
      if(parity_done==1'b1 && internal_parity!=packet_parity)
        err<=1'b1;
      else 
        err<=1'b0;
    end end
  
endmodule

module Router_Register_tb();
  reg clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,lfd_state,laf_state,full_state,ld_state;
  reg [7:0] din;
  wire parity_done,low_pkt_valid,err;
  wire [7:0] dout;
  
  Router_Register DUT(clk,resetn,pkt_valid,din,fifo_full,rst_int_reg,detect_add,lfd_state,laf_state,full_state,ld_state,parity_done,low_pkt_valid,err,dout);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;
    {pkt_valid,fifo_full,rst_int_reg,detect_add,lfd_state,laf_state,full_state,ld_state}=0;
  endtask
  
  task reset; begin
    @(negedge clk)
    resetn=1'b0;
    @(negedge clk)
    resetn=1'b1;
  end endtask
  
 initial begin
   reset;
   initialize;
   @(negedge clk)
   pkt_valid=1'b1;
   din=8'b00001010;
   detect_add=1'b1;
   @(negedge clk)
   detect_add=1'b0;
   lfd_state=1'b1;
   ld_state=1'b1;
   
   
   
   @(negedge clk)
   lfd_state=1'b0;
   fifo_full=1'b0;
   din=8'b00000001;
   @(negedge clk)
   din=8'b00000011;
   @(negedge clk)
   din='b00000111;
   @(negedge clk)
   din='b00001111;
   @(negedge clk)
   din='b00011111;
   @(negedge clk)
   din='b00111111;
   
   @(negedge clk)
   fifo_full=1'b1;
   din=8'b11111111;
   @(negedge clk)
   laf_state=1'b1;
   #20 $finish;
 end
  initial 
    $monitor("time=%0t clk=%b resetn=%b pkt_valid=%b detect_add=%b din=%b lfd_state=%b fifo_full=%b laf_state=%b ld_state=%b dout=%b"
             ,$time,clk,resetn,pkt_valid,detect_add,din,lfd_state,fifo_full,laf_state,ld_state,dout);
    
endmodule
