function out=div(vec,var)
A=0;
for i=1:length(vec)
   A=A+diff(vec(i),var(i));
end
out=A;