%scInv : Inverts a given impedance (admitance) by mirroring it about the origin
%
%  SYNOPSIS:
%     This function inverts the given impedance (admittance) by mirroring it about
%     the origin of the smith chart.
%
%     See also scDraw, scMove, scConCirc, scMatchCirc  
%     
%  SYNTAX:
%     [y] = scInv(z, color)
%
%  INPUT ARGUMENTS:
%     z     : Impedance (or admittance)
%     color : color of the emanating ray for the inverted point, default = red
%
%  OUTPUT ARGUMENT:
%     y : Inverted admittance (or impedance)
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

function y=scInv(z, color)

 if nargin < 1
    error('scInv.m: One input argument required...You may give color as second argument as well');
 end

 if nargin == 1
    color = 'r';
 end

 if size(z) == [1 1]
    if conj(z) == z
       r = z;
       x = 0;
    else
       r = real (z);
       x = imag (z);
    end
 elseif max(size(z)) == 2 & min(size(z)) == 1
    r = z(1);
    x = z(2);
 else
    error('scInv.m: Input must either be a complex number or a 1x2 vector  [r x]');
 end

 if (r+j*x)~=0
    y1   = 1/(r+j*x);
    y(1) = real(y1);
    y(2) = imag(y1);

    % NOW PLOT THE INVERTED IMPEDANCE
    scRay(y, color);
 else
    y = inf;
 end


