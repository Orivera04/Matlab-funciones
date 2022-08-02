% Reads data from a file, but only plots the numbers
% up to a flag of -99.Uses find and the colon operator
 
load experd.dat
 
where = find(experd == -99);
newvec = experd(1:where-1);
 
plot(newvec,'ko')
