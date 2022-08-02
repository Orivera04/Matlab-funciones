% P1_5 Conversion table from degrees to radians
%  0 to 360 degrees in 10 degree increments
degrees=([0:10:360])';
radians=(degrees.*pi)/180;
disp('   Degrees    Radians  ')
disp([degrees radians])