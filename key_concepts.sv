// concept regarding why wait statement stops posedge clk triggering

module top(input clk,ready,readyp);
  always@(posedge clk) begin
    $display("NEW %0t",$time);
    if(ready) begin// when a module is instantiated, then regions comes into effect(values wil be sampled in preponed region). otherwise value will be sampled after the clock edge
       $display("HEHE  time=%0t",$time);
        wait(readyp);
      $display("readyp is high %0t",$time);
      
    end
  end
endmodule


module test;
  bit clk,ready,readyp;
  always #5 clk=~clk;
  top dut(clk,ready,readyp);
   
  
  initial
    begin
      ready=0;
      repeat(5)@(posedge clk);
      ready=1;
      repeat(3)@(posedge clk);
      ready=0;
      
    end
       initial
    begin
      readyp=0;
      repeat(8)@(posedge clk);
      readyp=1;
      repeat(10)@(posedge clk);
      readyp=0;
      
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #300 $finish;
    end
endmodule
