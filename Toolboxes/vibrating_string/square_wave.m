function res = sqaure_wave(x)

L = x(end);
B = 1;
a = 0.25*L;
b = 0.75*L;
%inc = x(2)-x(1);
%res = zeros(1,length(x));
%res = square(a:inc:b);
%res = (x>=0&x<=L/2)*2*B.*x./L + (x>L/2)*2*B.*(L-x)./L;
res = (x>=a&x<=b)*B;
%for i = 1:length(x)
%if (x(i)>=a & x(i)<=b)
    %res(i)=B;
    %return
    %else
    %res(i)=0;
    %return
    %end
%end