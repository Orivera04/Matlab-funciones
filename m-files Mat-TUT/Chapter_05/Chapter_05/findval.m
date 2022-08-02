% Reads data from a file, but only plots the numbers
% up to a flag of -99.Uses find and the colon operator
 
load espera.dat
 
where = find(espera ==-99 );
newvec = espera(1:where-1);
 
plot(newvec,'ko'),grid on
