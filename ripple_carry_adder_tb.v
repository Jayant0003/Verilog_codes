module ripple_carry_adder(input [3:0]A,
                          input [3:0]B,
                          output [3:0]S,
                          output Cout);
  wire [2:0] C;
  full_adder FA1(A[0],B[0],0,S[0],C[0]);
  full_adder FA2(A[1],B[1],C[0],S[1],C[1]);
  full_adder FA3(A[2],B[2],C[1],S[2],C[2]);
  full_adder FA4(A[3],B[3],C[2],S[3],Cout);                       
endmodule
module ripple_carry_adder_tb();
  reg [3:0]A,B;
  wire [3:0] S;
  wire Cout;
  integer i;
  ripple_carry_adder DUT(A,B,S,Cout);
  initial begin
    {A,B}=0;
    $monitor("Input : A=%b B=%b Output : Sum=%b Carry=%b",A,B,S,Cout);
    for(i=84;i<99;i=i+1)
               begin
                 {A,B}={i,(i-1'b1)};
                 #10;
               end
             end
endmodule
      

