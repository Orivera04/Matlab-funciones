function dec=foct2dec(octnum)
% FOCT2DEC.M Function to convert an octal fraction to decimal
% CALL: dec=foct2dec(octnum); octnum is vector of octal digits
m=length(octnum);	% Number of digits
dec=0;	% Initialize the sum
for I=1:m;
 octexp=-1*I;
 dec=dec+octnum(I)*8^octexp;
end
