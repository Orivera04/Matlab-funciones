function x = mygauss(a, b)
n = length(a);                                            
                                                         
a(:,n+1) = b;                                             
                                                         
for k = 1:n                                               
 a(k,:) = a(k,:)/a(k,k);        % pivot element must be 1
                                                         
 for i = 1:n                                             
   if i ~= k                                             
     a(i,:) = a(i,:) - a(i,k) * a(k,:);                  
   end                                                   
 end                                                     
                                                         
end                                                       
                                                         
% solution is in column n+1 of a:                         
x = a(:,n+1); 