% f2_20  Copyright S. Nakamura, 1995
clear, clg
set(gcf, 'NumberTitle','off','Name', 'Figure 2.20')

[x,y,f]=td_data;
mesh(x,y,f)
xlabel('x'), ylabel('y'), zlabel('f')
