clc, disp('There are 2 categories of "general purpose" utilites.  Although these');
disp('routines were created to be "general purpose", they have specific uses');
disp('relating to control system analysis.');
disp(' '); disp('   Polynomial manipulation:'); disp(' ');
disp('         Poly_add');
disp('         Polysbst');
disp('         Polyintg');  
disp('         Polyder          (Supplied with MATLAB)');
disp('         Polymag');
disp('         Polyangl');
disp('         Rootmag');
disp('         Rootangl');
disp(' '); disp('   Data/Function interpolation.'); disp(' ');
disp('         Crossing');
disp('         Crosser');
disp('         Crosses');
disp(' '); disp('Their help files and a sample will be displayed.');
pause;
clc; disp('Poly_add >> designed to expidite polynomial addition:');
help poly_add;
disp('Example of adding polynomials x^2+2x+3 with 4x^3+5x^2+6x+7:');
disp(' '); disp('polysum = poly_add([1 2 3],[4 5 6 7);');
polysum = poly_add([1 2 3],[4 5 6 7])
pause; clear polysum;

clc; disp('Polysbst >> designed for substitution of variables:'); 
help polysbst;
disp('Example of replacing x, in 2x^2+4x+7, with 2y^2+y-1.');
disp(' '); disp('newpoly = polysbst([2 4 7],[2 1 -1]);');
disp('newpoly ='); disp(polysbst([2 4 7],[2 1 -1]));
pause; clear newpoly;

clc; disp('Polyintg >> designed to integrate a polynomial:');
help polyintg;
disp('Example of the integral of x^4+2s^3+3s^2+4x+5.');
disp('Constant of integration = 0, default.');
disp(' '); disp('newpoly = polyintg([1 2 3 4 5]);');
newpoly = polyintg([1 2 3 4 5])
pause; clear newpoly;

clc; disp('Polyder  >> (supplied with MATLAB) derivative of a polynomial:');
help polyder;
disp('Example of the derivative of 5x^4+4x^3+3x^2+2x+1');
disp(' '); disp('[q,d] = polyder([5 4 3 2 1],1)');
[q,d] = polyder([5 4 3 2 1],1)
pause; clear q d;

clc; disp('Polymag  >> locate roots that generate a given magnitude:');
help polymag;
disp('Example for finding magnitude = 1 (0db) for (x^2+3x+2)/(x^3+3x)');
disp('v = polymag([1 3 2],[1 0 3 0],1);');
disp('v = '); disp(polymag([1 3 2],[1 0 3 0],1));
pause;

clc; disp('Polyangl >> locate roots that generate a given angle:');
help polyangl;
disp('Example for finding angle = -180 degrees for (x^2+3x+2)/(x^3+3x)'); 
disp(' '); disp('v = polyangl([1 3 2],[1 0 3 0],-180);');
v = polymag([1 3 2],[1 0 3 0],-180)
pause;

clc; disp('Rootmag  >> locate roots that are a given magnitude:');
help rootmag;
disp('Example for finding roots whose magnitude = 2 of x^3+2x+3');
disp(' '); disp('[k,s] = rootmag([1 0 2 3],1,2);');
[k,s] = rootmag([1 0 2 3],1,2)
pause; clear k s;

clc; disp('Rootangl >> locate roots that have the given angle');
help rootangl;
disp('Example (See Figure 6.60) for finding roots whose angle = 90 of'); 
disp('              1.6*(x+10)/(x^4+9x^3+24x^2+16x)'); disp(' ');
disp('[k,s] = rootangl(1.6*[1 10],[1 9 24 16 0],90);');
[k,s] = rootangl(1.6*[1 10],[1 9 24 16 0],90)
pause; clear k s;

clc; disp('Crossing >> get index (with fraction) of a value in a data set.');
disp('            Inverse of crosses!');
help crossing;
disp('Example to find index of the data [1 3 7 4 9] at a 5 crossing point.');
disp(' '); disp('ndx = crossing([1 3 7 4 9],5);');
ndx = crossing([1 3 7 4 9],5)
pause; clear ndx;

clc; disp('Crosses  >> get the value from a data set at an index (with fraction)');
disp('            Inverse of crossing!');
help crosses;
disp('Example to interpolate the data set [1 3 5 7 11] at [2.3 4.7].');
disp(' '); disp('vals = crosses([1 3 5 7 11],[2.3 4.7])');
vals = crosses([1 3 5 7 11],[2.3 4.7])
pause; clear vals;

clc; disp('Crosser  >> finds the function value evaluates to a given value:');
help crosser;
disp('Example to find where Cos(x) = sqrt(2)/2');
disp(' '); disp('v = crosser(''cos'',[0 pi],sqrt(2)/2) * 180/pi;');
v = crosser('cos',[0 pi],sqrt(2)/2) * 180/pi
pause; clear v;
