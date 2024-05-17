module clkbuf(iclk, oclk); 
    input iclk; 
    output oclk; 
    buf b1(iclk, oclk); 
endmodule 


module clkbuf_tb();
    reg iclk;    
    wire oclk;
    realtime t1, t2, t3, t4, t5, t6;
    
    clkbuf dut(iclk, oclk);   
    initial begin        
        iclk = 1'b0;       
        forever #10 iclk = ~oclk; 
    end

   
 task master;
    begin
        @(posedge iclk) t1 = $realtime;
        @(posedge iclk) t2 = $realtime;        
        t3 = t2 - t1; 
    end 
    endtask  
  
 task bufout; 
    begin        
        @(posedge oclk) t4 = $realtime;
        
        @(posedge oclk) t5 = $realtime;        
        t6 = t5 - t4; 
    end 
    endtask

  task freq_phase;
    realtime f, p; 
    begin        
        f = t6 - t3; 
        p = t4 - t1;        
        $display("freq_diff=%0t, phase_diff=%0t", f, p); 
    end
    endtask 
  
initial begin        
        fork 
            master; 
            bufout; 
        join        
        freq_phase;
    end
    initial
      $monitor("Time=%t, iclk=%b, oclk=%b",$time,iclk,oclk);       
    initial
      #500 $finish;  
endmodule 
