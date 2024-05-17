module mux41(y,din,sel);
input [3:0] din;
input [1:0] sel;
output reg y;
always @(din,sel)
	begin case(sel)
		2'd0 : y=din[0];
		2'd1 : y=din[1];
		2'd2 : y=din[2];
		2'd3 : y=din[3];
		default : y=0;
		endcase
	end
endmodule

module mux41_tb();
wire y;
reg [3:0] d;
reg [1:0] sel;
mux41 DUT(y,d,sel);
	task initialize;
		begin
		    {d,sel}=0;
		end
	endtask
	/*
		always #16 sel=sel+1;
		always #1 d=d+1; 
	*/
	 task stimulus(input [3:0]i,input [1:0] s);
		begin
			#10;
			d=i;
			sel=s;
		end
	endtask
	initial 
		begin
		initialize;
		stimulus(4'd5,2'd2);
		stimulus(4'd10,2'd3);
		stimulus(4'd14,2'd1);
		end	
	initial 
		begin
		$monitor("input sel=%b, d=%b, output y=%b",sel,d,y);
		end
	initial begin
		 #100 $finish;
		end
endmodule
module mux_2x1(input [1:0] in,
               input sel,
               output out);
  assign out= sel ? in[1]:in[0];
endmodule

/*
module mux_4x1(input [3:0] in,
               input [1:0] sel,
                    output out);
  wire [1:0]w;
  mux_2x1 mux1(.in(in[1:0]),.sel(sel[0]),.out(w[0]));
  mux_2x1 mux2(.in(in[3:2]),.sel(sel[0]),.out(w[1]));
  mux_2x1 mux3(.in(w),.sel(sel[1]),.out(out));
 
endmodule
module mux_4x1_tb();
  
  reg [3:0] in;
  reg [1:0] sel;
  wire  out;
  integer i;
  mux_4x1 DUT(in,sel,out);
  initial
    begin
      {in,sel}=0;
      $monitor("Input in=%b, sel=%b Output out=%b",in,sel,out);

      for(i=22;i<42;i=i+1)
               begin
             
                 {in,sel}=i;
                 #10;
               end
      end 
endmodule
*/

	
