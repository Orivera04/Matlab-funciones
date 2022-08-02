A = 1000;            % amount borrowed
n = 12;              % number of payments per year
                                                    
for r = 0.1 : 0.01 : 0.2                             
 fprintf( '%4.0f%', 100 * r );                      
 for k = 15 : 5 : 25                                
   temp = (1 + r/n) ^ (n*k);                        
   P = r * A * temp / n / (temp - 1);               
   fprintf( '%10.2f', P );                          
 end;                                               
 fprintf( '\n' );       % new line                  
end;   