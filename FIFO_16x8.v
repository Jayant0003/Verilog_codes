module FIFO_16x8(
    output reg [7:0] data_out, 
    output  full,            
    output  empty,           
    input [7:0] data_in,        
    input read_n,               
    input write_n,              
    input clock,                
    input reset                
);

    reg [7:0] mem[0:15];       
  reg [3:0]read_pointer;       
  reg [3:0] write_pointer;      
  reg [4:0] counter; 
  integer i;
  
  assign full = (counter ==5'd15)?1'b1:1'b0;
  assign empty = (counter == 5'b0)?1:0;

    
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            read_pointer <= 0;
            write_pointer <= 0;
            counter <= 0;
            data_out <= 8'b0; 
          for(i=0;i<16;i=i+1)
            mem[i]<=0;
        end 
      else 
            
            if (write_n && !full) begin
                mem[write_pointer] <= data_in;
              write_pointer <= (write_pointer + 1) ;
                counter <= counter + 1;
            end

            
            if (read_n && !empty) begin
                data_out <= mem[read_pointer];
                read_pointer <= (read_pointer + 1) ;
                counter <= counter - 1;
            end
        end
        


endmodule
// FIFO Testbench Code
module FIFO_16x8_tb;

    reg clk;                    
    reg rst;                    
    reg write_n;               
    reg read_n;                 
    reg [7:0] data_in;          
    wire empty;                 
    wire full;                  
    wire [7:0] data_out;       
    integer i;                  

    
    FIFO_16x8 DUT (
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .data_in(data_in),
        .read_n(read_n),
        .write_n(write_n),
        .clock(clk),
        .reset(rst)
    );

    
  initial begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  task initialize;
    {write_n,read_n,data_in,rst}=0;
  endtask
  
  task reset; begin
    @(negedge clk) rst=1'b1;
    @(negedge clk) rst=1'b0;
  end endtask

    
    task write_FIFO(input [7:0] data);
    begin
               // Write data into FIFO
      @(negedge clk);        
        write_n = 1;  
      data_in=data;
    end
    endtask

    // Task to perform read operations
    task read_FIFO;
    begin
                 
      @(negedge clk);         
        read_n = 1;             // Deassert read enable
    end
    endtask

    
    initial
    begin
        initialize();  
     #5 reset;
      #5;

        
        for (i = 0; i < 16; i = i + 1)
        begin
            write_FIFO($random % 256);
              
        end
#5;
        
        for (i = 0; i < 16; i = i + 1) begin
            read_FIFO();       
          
        end

      #50  $finish;               
    end

   
    initial
    begin
      $monitor("Time=%0t rst=%b clk=%b empty=%b full =%b write_n=%b read_n=%b data_in=%b data_out=%b",
            $time, rst, clk, empty, full, write_n, read_n, data_in, data_out  );
    end

endmodule







