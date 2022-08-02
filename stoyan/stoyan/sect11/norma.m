function [maxnorm,norm2] = norma(x)
% fuggvenyunk az x vektor normait szamolja
% maxnorm a vegtelen norma
% norm2 az euklideszi norma
%
% © Molnarka Gy''oz''o 1998; program a Matlab programozasa c. reszhez

n=length(x);
maxnorm=max(abs(x));
ss=0;
for i=1:n
   ss=ss+x(i)^2;
end;
norm2=sqrt(ss);