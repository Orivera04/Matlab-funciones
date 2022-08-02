function xvalues=clxfunct(tvalues)
% CLXFUNCT  Function for Example 1.8
% Call:  xvalues=clxfunct(tvalues) to compute function 
%  xvalues=(2*sqrt(3)/9)*exp(-4*tvalues) x
%       sin(4*sqrt(3)*tvalues+ pi/3)
xvalues=(2*sqrt(3)/9)*exp(-4*tvalues).*sin(4*sqrt(3)*tvalues + pi/3);
% End function
	
	