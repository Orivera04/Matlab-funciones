bal = 15000 * rand;

if bal < 5000              
 rate = 0.09;             
elseif bal < 10000         
 rate = 0.12;             
else                       
 rate = 0.15;             
end                        
                          
newbal = bal + rate * bal;    
format bank
disp( 'New balance is:' )
disp( newbal ) 