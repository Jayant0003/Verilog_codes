module bidirectional_buffer(input en,                           
                            inout  a,
                            inout  b);  
 assign b=en?a:1'bz;
  assign a=~en?b:1'bz;
endmodule
module bidirectioal_buffer_tb(); 
  reg en;
  wire a,b;  
  reg tempa, tempb;
  integer i;
  bidirectional_buffer DUT(en,a,b);   

assign a=en?tempa:1'bz;
  assign b=~en?tempb:1'bz;
  initial begin  
{tempa,tempb,en}=0;
    $monitor(" en=%b a=%b b=%b",en,a,b);
    for(i=0;i<9;i=i+1)    
      begin
        {tempa,tempb,en}=i;       
        #10;
      end 

  end
endmodule
