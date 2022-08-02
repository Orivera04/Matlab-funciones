bin = input('Enter binary number: ', 's'); 
bin = bin == '1';                          
dec = 0;                                   
inc = 0;                                   
for i = length(bin) : -1 : 1               
  dec = dec + 2 ^ inc * bin(i);            
  inc = inc + 1;                           
end                                        
disp(dec);  