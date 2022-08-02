A = 1000;            % amount borrowed
n = 12;              % number of payments per year
                                                    
for r = 0.1 : 0.01 : 0.2                                           
 k = 15 : 5 : 25;                                                 
 temp = (1 + r/n) .^ (n*k);                                       
 P = r * A * temp / n ./ (temp - 1);                              
 disp( [100 * r, P] );                                            
end;                                              