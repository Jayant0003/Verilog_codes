module Router_FSM(input clk,
                  input resetn,
                  input pkt_valid,
                  input parity_done,
                  input [1:0] din,
                  input soft_rst_0,
                  input soft_rst_1,
                  input soft_rst_2,
                  input fifo_full,
                  input low_pkt_valid,
                  input fifo_empty_0,
                  input fifo_empty_1,
                  input fifo_empty_2,
                  output detect_add,
                  output ld_state,
                  output laf_state,
                  output full_state,
                  output busy,
                  output write_enb_reg,
                  output rst_int_reg,
                  output lfd_state);
  reg [1:0] addr;
  reg [2:0] present_state,next_state;
  parameter DECODE_ADDRESS= 3'b000,
  			LOAD_FIRST_DATA= 3'b001,
  			LOAD_DATA= 3'b010,
  			FIFO_FULL_STATE= 3'b011,
  			LOAD_AFTER_FULL= 3'b100,
  			LOAD_PARITY= 3'b101,
  			CHECK_PARITY_ERROR= 3'b110,
  			WAIT_TILL_EMPTY= 3'b111;
  
  //internal variable add logic
  always @(posedge clk) begin   
    if(~resetn)
      addr<=0;
    else begin
      if((soft_rst_0 && din==2'b00)||(soft_rst_1 && din==2'b01) ||(soft_rst_2 && din==2'b10))
        addr<=0;
    else if(detect_add)
      addr<=din; end
  end
  
  //present_state logic
  always @(posedge clk) begin
    if(~resetn)
      present_state<=DECODE_ADDRESS;
    else begin
      if((soft_rst_0 && din==2'b00)||(soft_rst_1 && din==2'b01) ||(soft_rst_2 && din==2'b10))
  		present_state<=DECODE_ADDRESS;
      else
        present_state<=next_state; end
  end
  
  //next_state logic
  always @(*) begin

    next_state=present_state; 
      case(present_state)
        DECODE_ADDRESS: begin if((pkt_valid && (din==2'b00) && fifo_empty_0) || (pkt_valid &&(din==2'b01)&&fifo_empty_1)||(pkt_valid && (din==2'b10) && fifo_empty_2))
          next_state=LOAD_FIRST_DATA;
           else if((pkt_valid&&(din==0)&&!fifo_empty_0) || (pkt_valid&&(din==1)&&!fifo_empty_1)||(pkt_valid&&(din==2)&&!fifo_empty_2))
          next_state=WAIT_TILL_EMPTY;
          else 
            next_state=DECODE_ADDRESS; end
        LOAD_FIRST_DATA: next_state=LOAD_DATA;
        LOAD_DATA:begin if(fifo_full)
          next_state=FIFO_FULL_STATE;
          else if(!fifo_full&&!pkt_valid)
            next_state=LOAD_PARITY;
          else
            next_state=LOAD_DATA; end
         FIFO_FULL_STATE: begin
           if(!fifo_full)
             next_state=LOAD_AFTER_FULL;
           else
             next_state=FIFO_FULL_STATE; end
         LOAD_AFTER_FULL: begin
           if(parity_done)
             next_state=DECODE_ADDRESS;
           else if(!parity_done && !low_pkt_valid)
             next_state=LOAD_DATA;
            else if(!parity_done && low_pkt_valid)
              next_state=LOAD_PARITY; end
          LOAD_PARITY: next_state=CHECK_PARITY_ERROR;
          CHECK_PARITY_ERROR: begin
            if(!fifo_full)
              next_state=DECODE_ADDRESS;
            else
              next_state=FIFO_FULL_STATE; end
          WAIT_TILL_EMPTY: begin
            if((fifo_empty_0 && addr==0) || (fifo_empty_1 && addr==1)|| (fifo_empty_2 && addr==2))
              next_state=LOAD_FIRST_DATA;
            else
              next_state=WAIT_TILL_EMPTY; end
          default: next_state=DECODE_ADDRESS;
          endcase
        end 
  // Output SIgnals
  
  assign detect_add=(present_state==DECODE_ADDRESS)?1'b1:1'b0;
  assign lfd_state=(present_state==LOAD_FIRST_DATA)?1'b1:1'b0;
  assign ld_state=(present_state==LOAD_DATA)?1'b1:1'b0;
  assign full_state=(present_state==FIFO_FULL_STATE)?1'b1:1'b0;
  assign laf_state=(present_state==LOAD_AFTER_FULL)?1'b1:1'b0;
  assign rst_int_reg=(present_state==CHECK_PARITY_ERROR)?1'b1:1'b0;
  assign write_enb_reg=((present_state==LOAD_DATA)||(present_state==LOAD_AFTER_FULL)||(present_state==LOAD_PARITY))?1'b1:1'b0;
  assign busy=((present_state==WAIT_TILL_EMPTY)||(present_state==LOAD_FIRST_DATA)||(present_state==LOAD_AFTER_FULL)||(present_state==FIFO_FULL_STATE)||(present_state==CHECK_PARITY_ERROR)||(present_state==LOAD_PARITY))?1'b1:1'b0;
  
 
  
  
  
endmodule
 
  

 


 
module Router_FSM_tb();
  reg clk,resetn,pkt_valid,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
  reg [1:0] din;
  wire detect_add,ld_state,laf_state,full_state,busy,write_enb_reg,rst_int_reg,lfd_state;
  
  Router_FSM DUT(clk,resetn,pkt_valid,parity_done,din,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,busy,write_enb_reg,rst_int_reg,lfd_state);
  
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;  {parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,din}=0;
  endtask
  
  task reset; begin
    @(negedge clk)
    resetn=1'b0;
    @(negedge clk)
    resetn=1'b1;
  end endtask
  
  task t1; begin
    @(negedge clk)
    pkt_valid=1'b1;
    din=2'b10;
    fifo_empty_0=1'b1;
    @(negedge clk)
    @(negedge clk)
    fifo_full=1'b1;
    pkt_valid=1'b0;
    @(negedge clk)
    fifo_full=1'b0;
    @(negedge clk)
    parity_done=1'b1;
    end endtask
  
  task t2; begin
     @(negedge clk)
    pkt_valid=1'b1;
    din=2'b10;
    fifo_empty_0=1'b1;
    @(negedge clk)
    @(negedge clk)
    fifo_full=1'b1;
    @(negedge clk)
    fifo_full=1'b0;
    @(negedge clk)
    parity_done=1'b0;
    low_pkt_valid=1'b1;
  end endtask
  
  task t3; begin
    @(negedge clk)
    pkt_valid=1'b1;
    din=2'b10;
    fifo_empty_0=1'b1;
    @(negedge clk)
    @(negedge clk)
    fifo_full=1'b1;
    @(negedge clk)
    fifo_full=1'b0;
    @(negedge clk)
    parity_done=1'b0;
    low_pkt_valid=1'b0;
    @(negedge clk)
    pkt_valid=1'b0;
    @(negedge clk)
    @(negedge clk)
    fifo_full=1'b1;
    @(negedge clk)
    fifo_full=1'b0;
  end endtask
  
  task t4; begin
    
    @(negedge clk)
    pkt_valid=1'b1;
    din=2'b01;
    fifo_empty_0=1'b0;
    @(negedge clk)
    fifo_empty_0=1'b1;
    din=0;
    @(negedge clk)
    @(negedge clk)
    pkt_valid=1'b0;
    fifo_full=1'b0;
  end endtask
  
  initial begin
    initialize;
   #5 reset;
    #10 t1;
    #30 t3;
    #30 t2;
#30 t4;
    #30 $finish;
  end
  
  initial 
    $monitor("time=%0t clk=%b resetn=%b pkt_valid=%b detect_add=%b ld_state=%b laf_state=%b full_state=%b busy=%b write_enb_reg=%b rst_int_reg=%b lfd_state=%b",$time,clk,resetn,pkt_valid,detect_add,ld_state,laf_state,full_state,busy,write_enb_reg,rst_int_reg,lfd_state);
endmodule     
