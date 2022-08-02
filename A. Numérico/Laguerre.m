
function y=Laguerre(p,L)
n=size(p,2)-1;

q(1)=p(1);
y=0
for k=2:n+1
   q(k)=p(k)+L*q(k-1);
   if q(k)<0
      y=1; 
      disp('No es cota')
      return; 
   end
end
if y==0
disp('Es cota')
end 