function output=hex_2_dec(a)

% This function converts an hexagonal number into corresponding decimal number.
%  Class of both variables-output and a are "char".

c=[];
for(i=1:length(a))
    c=[c hex_2_bin(a(i))];
end
output=bin_2_dec(c);