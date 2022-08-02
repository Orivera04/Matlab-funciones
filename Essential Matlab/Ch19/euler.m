h = 0.5;
r = 0.8;                                                 
a = 0;                                                   
b = 10;                                                  
m = (b - a) / h;                                         
N = zeros(1, m+1);                                       
N(1) = 1000;                                             
t = a:h:b;                                               
                                                        
for i = 1:m                                              
 N(i+1) = N(i) + r * h * N(i);                          
end                                                      
                                                        
Nex = N(1) * exp(r * t);                                 
format bank                                              
disp( [t' N' Nex'] )                                     
                                                        
plot(t, N ), xlabel( 'Hours' ), ylabel( 'Bacteria' )
hold on                                                  
plot(t, Nex ), hold off    