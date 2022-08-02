function str = char(PREC)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:02 $

%CGPRECLOOKUPFIX/CHAR  Return a readable representation of a cgpreclookupfix object

nbits = get(PREC,'bits');
s = get(PREC,'signed');
if s
    str = 'Signed ';
else
    str = 'Unsigned ';
end
str = [str,num2str(nbits),' bit fixed point with a lookup table hardware to physical conversion']; 
