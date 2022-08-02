function output=oct2bin(a)

% This function converts a single-digit octagonal number into corresponding binary number.
%  Class of both variables-output and a are "char".

mat_1=['000';
       '001';
       '010';
       '011';
       '100';
       '101';
       '110';
       '111'];   
mat_2='01234567';

for(i=1:8)
if(a==mat_2(i))
    output=mat_1(i,:);
end
end