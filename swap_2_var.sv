//different ways to swap 2 variables
//1.using non-blocking statement
                                          module TB;
                                           int a=10,b=15;
                                           initial begin 
                                              a<=b;
                                              b<=a;
                                               $monitor(" Values of a=%0d b=%0d",a,b);
                                           end
                                        endmodule
//By using xor operators.

                                        module TB;
                                           int a=10,b=15;
                                           initial begin 
                                              a=a^b;  // a=(1010)^(1111)->0101
                                              b=a^b; //b=(0101)^(1111)=1010->10
                                              a=a^b; //a=(0101)^(1010)=1111->15
                                              $display(" Values of a=%0d b=%0d",a,b);
                                        end
//using addition and subtraction
                                          module TB;
                                           int a=10,b=15;
                                           initial begin 
                                              a=a+b;  // a=25
                                              b=a-b;   //b=25-15->10
                                              a=a-b;   //a=25-10->15
                                              $display(" Values of a=%0d b=%0d",a,b);
                                        end
//using multiplication and division
                                           module TB;
                                           int a=10,b=15;
                                           initial begin 
                                              a=a*b;  // a=150
                                              b=a/b;  //b=150/15->10
                                              a=a/b;  //a=150/10->15
                                              $display(" Values of a=%0d b=%0d",a,b);
                                        end
// By using temporary variable.
                                
                                       module TB;
                                           int a=10,b=15, temp;
                                           initial begin 
                                              temp=a;
                                                    a=b;
                                                    b=temp;
                                              $display(" Values of a=%0d b=%0d",a,b);
                                        end
                                      
