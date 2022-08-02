function output=hex_2_bin(a)

% This function converts a single-digit hexagonal number into corresponding binary number.
%  Class of both variables-output and a are "char".

mat_1=['0000';
       '0001';
       '0010';
       '0011';
       '0100';
       '0101';
       '0110';
       '0111';
       '1000';
       '1001';
       '1010';
       '1011';
       '1100';
       '1101';
       '1110';
       '1111';];
   
mat_2='0123456789ABCDEF';

for(i=1:16)
if(a==mat_2(i))
    output=mat_1(i,:);
end
end