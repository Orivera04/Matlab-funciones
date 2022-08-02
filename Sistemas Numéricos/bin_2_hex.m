function c=bin_2_hex(a)

% This function converts an binary number into corresponding hexagonal number.
%  Class of both variables-c and a are "char".

if(rem(length(a),4)~=0)
for(i=1:4-rem(length(a),4))
    a=['0' a];
end
end
[m n]=size(a);
b=reshape(a,4,m*n/4)';
c=[];
for(i=1:m*n/4)
c=[c bin2hex(b(i,:))];
end
