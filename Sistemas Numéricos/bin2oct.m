function output=bin2oct(a)

% This function converts a single-digit binary number into corresponding octagonal number.
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
if(a==mat_1(i,:))
    output=mat_2(i);
end
end