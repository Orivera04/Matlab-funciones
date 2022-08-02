function res = plucked_string1(x)

L = x(end);
B = 1;
a = 0.25*L;
b = 0.75*L;
res = (x>=0&x<=L/2)*2*B.*x./L + (x>L/2)*2*B.*(L-x)./L;
%res = (x>=a&x<L/2)*B.*(x-a)./(L/2-a) + (x>=L/2&x<=b)*B.*(x-b)./(L/2-b);