circle = 0;                  
square = 1000;               
for i = 1 : square           
 x = 2 * rand - 1;          
 y = 2 * rand - 1;          
 if (x * x + y * y) < 1     
   circle = circle + 1;     
 end                        
end                          
disp( circle / square * 4 ); 