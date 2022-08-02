function day = dayofweek(d)
k = d(1);                                                         
m = d(2) - 2;                                                     
if m < 1                                                          
  m = m + 12;                                                     
  d(3) = d(3) - 1;                                                
end                                                               
c = floor(d(3) / 100);                                            
y = d(3) - c * 100;                                               
f1 = fix(2.6 * m - 0.2) + k + y + ...
     fix(y / 4) + fix(c / 4) - 2 * c;
f = 1 + rem(f1, 7);                                               
if f < 0                                                          
    f = 7 + f;                                                    
end                                                               
daylist = char('Sunday', 'Monday', 'Tuesday', ...
  'Wednesday', 'Thursday', 'Friday', 'Saturday');                 
day = daylist(f, 1:9); 