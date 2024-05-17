// Code your design here
module SR_latch(input S,
                input R,
                output Q,
               output Q_bar);

  nor g1(Q,Q_bar,R);
  nor g2(Q_bar,Q,S);
endmodule
// Code your testbench here

module SR_latch_tb();
  reg S,R;
  wire Q,Q_bar;
  SR_latch DUT(S,R,Q,Q_bar);
  task initialize;
    begin
    {S,R}=0;
    end endtask
    task SRinput(input i,input j);
      begin
      S=i;
      R=j;
      end
    endtask
    initial begin
      initialize;
      SRinput(0,0);
      #5;
      SRinput(1,0);
       #5;
      SRinput(0,0);
       #5;
      SRinput(0,1);
       #5;
      SRinput(0,0);
       #5;
      SRinput(1,1);
       #5;
      SRinput(0,0);
      $finish;
    end 
      initial
        $monitor("S=%b R=%b Q=%b ~Q=%b",S,R,Q,Q_bar);
      endmodule
      
      
