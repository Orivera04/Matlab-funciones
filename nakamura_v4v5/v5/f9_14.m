% f9_14 demontrates stret_ and plots by bar command. 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.14')

clear,clf
x=stret_(20,1,0.01,0.02);
dx=diff(x);
bar(dx)
xlabel('Segment number')
ylabel('Segment length')
