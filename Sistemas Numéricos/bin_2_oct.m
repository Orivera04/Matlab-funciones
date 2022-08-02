function c=bin_2_oct(a)

% This function converts an binary number into corresponding octagonal number.
%  Class of both variables-c and a are "char".

if(rem(length(a),3)~=0)
for(i=1:3-rem(length(a),3))
    a=['0' a];
end
end
[m n]=size(a);
b=reshape(a,3,m*n/3)';
c=[];
for(i=1:m*n/3)
c=[c bin2oct(b(i,:))];
end
