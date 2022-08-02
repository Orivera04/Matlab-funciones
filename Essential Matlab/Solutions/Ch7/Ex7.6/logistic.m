y(1) = 0.2;
r = 3.738;                   
for k = 1:600                
 y(k+1) = r*y(k)*(1 - y(k));
end                          
plot(y, '.k') 