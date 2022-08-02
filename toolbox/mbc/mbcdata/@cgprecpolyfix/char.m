function str = char(PREC)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:10 $

%CGPRECPOLYFIX/CHAR  Return a readable representation of a cgprecpolyfix object

nbits = get(PREC,'bits');
s = get(PREC,'signed');
if s
    str = 'Signed ';
else
    str = 'Unsigned ';
end
n = get(PREC,'NumCoeff');
d = get(PREC,'DenCoeff');
if length(n) == 2 & n == [1 0] & d == [0 1]
    str = [str,num2str(nbits),' bit fixed point']; 
else
    str = [str,num2str(nbits),' bit fixed point with a ratio of polynomials hardware to physical conversion'];    
end
