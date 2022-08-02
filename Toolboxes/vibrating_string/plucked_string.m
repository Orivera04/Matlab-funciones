function res = plucked_string2(x)%,L,B)

L = 1;
B = 1;
%for i = 1:length(x)
%    if x(i)>=0 & x(i)<=L/2
%        res(i) = 2*B*x(i)/L;
%    else
%        res(i) = 2*B*(L-x(i))/L;
%    end
%end
a = 0.25*L;
b = 0.75*L;
%res = (x>=0&x<=L/2)*2*B.*x./L + (x>L/2)*2*B.*(L-x)./L;
res = (x>=a&x<L/2)*B.*(x-a)./(L/2-a) + (x>=L/2&x<=b)*B.*(x-b)./(L/2-b);