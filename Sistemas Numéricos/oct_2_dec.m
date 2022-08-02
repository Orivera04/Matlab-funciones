function output=oct_2_dec(a)

% This function converts an octagonal number into corresponding decimal number.
%  Class of both variables-output and a are "char".

c=[];
for(i=1:length(a))
    c=[c oct_2_bin(a(i))];
end
output=bin_2_dec(c);