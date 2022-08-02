% f9_6   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.6')

clear; clg; hold off
f = [  1 2 3 5 1 2 4 2  ];  m = length(f);
s=1:m;
plot([-2 14], [0 6], '.'); hold on
xlabel('s'); ylabel('f');  plot(s,f,'o')
for k=1:m
  z=int2str(k+2); sk = s(k); fk=f(k); text(sk+0.2,fk-0.2,z)
end
t = 0:0.1:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   fb = 1/6*((1-t).^3*f(i-1)+(3*t3-6*t2+ 4)*f(i) + ...
        (-3*t3+3*t2 + 3*t + 1)*f(i+1) + t3*f(i+2) );
   plot(s(i)+t,fb)
end
%text (-1,6.3, ' With 3 repeating points at edges', ...
% 'FontSize',[24])

%title (' With no repeating points at the edges')
%print fig9d50.ps

