function str = char(PREC)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:53 $

%CGPRECFLOAT/CHAR  Return a readable representation of a cgprecfloat object

mbits = get(PREC,'mbits');
ebits = get(PREC,'ebits');

if mbits == 52 & ebits == 11
    str = 'IEEE Double Precision'; 
elseif mbits == 23 & ebits == 8
    str = 'IEEE Single Precision';
else
    nbits = mbits + ebits + 1;
    str = [num2str(nbits),' bit floating point']; 
end
