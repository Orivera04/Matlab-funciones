m = 44;                                                           
n = 28;                                                           
while m ~= n                                                      
  while m > n                                                     
    m = m - n;                                                    
  end                                                             
  while n > m                                                     
    n = n - m;                                                    
  end                                                             
end                                                               
disp(m); 