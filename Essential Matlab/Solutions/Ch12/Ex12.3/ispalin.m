function y = ispalin(s)                    
y = 1;                                     
s = s(s ~= ' ');                           
for i = 1 : length(s)                      
  if s(i) < 91                             
    s(i) = s(i) + 32;                      
  end                                      
end                                        
for i = 1 : floor(length(s) / 2)           
  if s(i) ~= s(length(s) - i + 1)          
    y = 0;                                 
  end                                      
end