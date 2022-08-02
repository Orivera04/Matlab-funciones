function t = toupper(s)
for i = 1 : length(s)                      
  if double(s(i)) > 96 & double(s(i)) < 123
    temp(i) = s(i) - 32;                   
  else                                     
    temp(i) = s(i);                        
  end                                      
end                                        
t = char(temp);                            
