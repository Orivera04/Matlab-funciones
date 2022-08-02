n =20;                                                             
T = 1;                                                            
i = 0;                                                            
for t = -1.1:0.01:1.1                                                   
  i = i + 1;                                                      
  F(i) = 0;                                                       
  for k = 0 : n                                                   
    F(i) = F(i) + 1 / (2 * k + 1) * ...
           sin((2 * k + 1) * pi * t / T);
  end                                                             
  F(i) = F(i) * 4 / pi;                                           
end                                                               
t = -1.1:0.01:1.1;                                                      
%disp( [t' F'] )                                                   
plot(t, F)