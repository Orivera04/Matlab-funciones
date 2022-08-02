function b=str2num(a)

% This function converts a string into an array.
%  Class of variable-a is "char".
%  Class of variable-b is "double".

for(i=1:length(a))
b(i)=a(i)-48;
end