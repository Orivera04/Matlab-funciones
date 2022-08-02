% Reads data from a file, but only plots the numbers
% up to a flag of -99. Uses a while loop.

load experd.dat
 
i = 1;
while experd(i) ~= -99
    newvec(i) = experd(i);
    i = i + 1;
end
 
plot(newvec,'ko')
title('Valid data')
