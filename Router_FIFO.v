module Router_FIFO(input clk,
                  input resetn,
                  input write_enb,
                  input soft_rst,
                  input read_enb,
                  input [7:0] din,
                  input lfd_state,
                  output empty,
                  output full,
                  output reg [7:0] dout);

reg [8:0] mem[0:15];
reg [3:0] fifo_counter;
reg [4:0] wr_pt,rd_pt;
reg lfd_state_s;
  integer i;
always @(posedge clk) begin
	if(!resetn)
		lfd_state_s<=0;
	else
		lfd_state_s<=lfd_state;//giving one clock delay to lfd_state signal
end

  
// FIFO counter logic
always @(posedge clk) begin
   if(!resetn) 
    fifo_counter<=0; 
  else if(soft_rst) 
    fifo_counter<=0; 
  else if(read_enb & ~ empty) begin
    $display("fifo_counter=%b empty=%b",fifo_counter,empty);
    if(mem[rd_pt[3:0]][8]==1'b1)
      fifo_counter<=mem[rd_pt[3:0]][7:2]+1'b1;
   else if(fifo_counter!=0)
       fifo_counter<=fifo_counter-1'b1;
     end end
  
//FIFO Read operation
always @(posedge clk) begin
  
  if(!resetn) dout<=8'b0;
  else if(soft_rst) dout<=8'bz;
  else begin
    if((fifo_counter==0) && dout!=0)
      dout<=8'dz;
    else if(read_enb & ~ empty)
      dout<=mem[rd_pt[3:0]];
  end
end

// FIFO Write Operation
always @(posedge clk) begin
  if(!resetn) begin
    for(i=0;i<16;i=i+1) 
      mem[i]<=0;  end
  else if(soft_rst) begin
    for(i=0;i<16;i=i+1) 
      mem[i]<=0;  end
  else begin
    if(write_enb && !full)
    {mem[wr_pt[3:0]]}<={lfd_state_s,din};
        end
  end
// Incrementing Pointer
always @(posedge clk) begin
 
  if(!resetn) begin
    rd_pt<=5'b0;
    wr_pt<=5'b0; end
  else if(soft_rst) begin
    rd_pt<=5'b0;
    wr_pt<=5'b0; end
  else begin
    if(!full && write_enb)
      wr_pt<=wr_pt+1;
    else wr_pt<=wr_pt;
    if(!empty && read_enb)
      rd_pt<=rd_pt+1;
    else rd_pt<=rd_pt; end
end
 
assign full= (wr_pt=={~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
assign empty=(wr_pt==rd_pt)?1'b1:1'b0;                
                                       
endmodule






module Router_FIFO_tb();
  reg clk,resetn,write_enb,soft_rst,read_enb,lfd_state;
  reg [7:0] din;
  wire empty,full;
  wire [7:0] dout;
  integer i;
  
  Router_FIFO DUT(clk,resetn,write_enb,soft_rst,read_enb,din,lfd_state,empty,full,dout);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize; 
    {write_enb,soft_rst,read_enb,lfd_state}=0;
  endtask
  task reset; begin
    @(negedge clk)
    resetn=1'b0;
    @(negedge clk)
    resetn=1'b1;
    end endtask
  
  initial begin
    reset;
    #10 initialize;
    @(negedge clk)
    write_enb=1'b1;
    lfd_state=1'b1;
    din=8'b00111000;
    for(i=0;i<18;i=i+1) begin
      @(negedge clk)
      lfd_state=1'b0;
      din=i;
    end
    write_enb=0;
    repeat(20)
    @(negedge clk)
    read_enb=1'b1;
    #20 $finish;
  end
  initial 
    $monitor("time=%0t clk=%b resetn=%b write_enb=%b read_enb=%b din=%b lfd_state=%b empty=%b full=%b dout=%b",$time,clk,resetn,write_enb,read_enb,din,lfd_state,empty,full,dout);
endmodule
  
  
             
                   
       
     
                        
        
      
      
      
