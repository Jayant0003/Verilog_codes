module jkFF(input clk,
  			input J,
            input reset,
            input K,
            output reg Q,
            output reg Q_bar);
  parameter HOLD=2'b00,
  			SET=2'b10,
  			RESET=2'b01,
  			TOGGLE=2'b11;
  always @(posedge clk)
    if(reset)
      begin
     	 Q=0;
        Q_bar=1;
      end
  else
    begin
      case ({J,K})
        HOLD : begin Q<=Q;Q_bar<=Q_bar;end
        RESET :begin Q<=0;Q_bar<=1;end
        SET :begin Q<=1;Q_bar<=0;end
        TOGGLE :begin Q<=~Q;Q_bar<=~Q_bar;end 
        default:{Q,Q_bar}<=2'bxx;
       endcase
    end
endmodule
            
module jkFF_tb();
  reg clk,J,K,reset;
  wire Q,Q_bar;
  jkFF DUT(clk,J,reset,K,Q,Q_bar);
  initial begin
    clk=1'b0;
 forever clk=~clk;
  end
 task initialize;
  begin
    {J,K,reset}=0;
  end endtask
  
  task rst;
    begin
      @(negedge clk)
      reset=1'b1;
      @(negedge clk)
      reset=1'b0;
   end endtask
  
  task jkInput(input i,input j);
    begin 
	@(negedge clk)
      J=i;
      K=j;
    end endtask
  initial begin
    initialize;
    rst;
    jkInput(0,0);
    #5;
    jkInput(1,0);
    #5;
    jkInput(0,0);
    #5;
    jkInput(0,1);
    #5;
    jkInput(0,0);
    #5
    jkInput(1,1);
    #5;
    rst;
    $finish;
  end
      initial
        $monitor("rst=%b J=%b K=%b Q=%b ~Q=%b",reset,J,K,Q,Q_bar);
      endmodule
      
      
