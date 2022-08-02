% f9_12 same as L9_6
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.12; List 9.6')

hold off, clg
b = 0.162294;
c = 1/12/(1- exp(0.162294));
a = -c;
x = 0:0.1:7;
y =  a*exp(b*x) + c;
plot(x,y)
xlabel('Section Number')
ylabel('Normalized Cumulative Length')
y1 =  a*exp(b) + c;
hold on
plot([1,1], [0,y1], '--')
plot([0,1], [y1,y1], '--')
%print fig9d8.ps

