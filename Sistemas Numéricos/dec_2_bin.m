function c=dec_2_bin(a)

% This function converts an decimal number into corresponding binary number.
%  Class of both variables-c and a are "char".

for(i=1:length(a))
    array(i)=(a(i))-48;
end
b=dec2bin2(array);
for(i=1:length(b))
c(i)=int2str(b(i));
end