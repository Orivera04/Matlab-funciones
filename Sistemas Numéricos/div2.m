function [e,factor]=div2(a)

% This function divides an array by 2 and calculates the remainder too.
%    a is the input array, e is the resultant array and factor is the remainder.
%     Class of all variables- e,f and a are "double".

for(i=1:length(a))
if(rem(a(i),2)==0)
    b(i)=a(i)/2;
    c(i)=0;
    ,else
    b(i)=(a(i)-1)/2;
    c(i)=5;
end
end
c=[0 c];
b=[b 0];
d=b+c;
for(i=1:length(d)-1)
    e(i)=d(i);
end
factor=d(length(d))/5;

