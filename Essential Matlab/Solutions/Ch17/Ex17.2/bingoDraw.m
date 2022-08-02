bingo = 1 : 99;                
for i = 1 : 99                 
 temp = bingo(i);             
 swop = floor(rand * 99 + 1); 
 bingo(i) = bingo(swop);      
 bingo(swop) = temp;          
end                            
for i = 1 : 10 : 81            
 disp(bingo(i : i + 9))       
end                            
disp(bingo(91 : 99))