function b = numf(h,a,nb)
%NUMF	Find numerator B given impulse-response h of B/A and denominator A
%	NB is the numerator order.  This function is used by YULEWALK.
  
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.3 $  $Date: 1994/01/25 17:59:33 $

nh = max(size(h)); 
impr = filter(1,a,[1 zeros(1,nh-1)]);
b = h/toeplitz(impr,[1 zeros(1,nb)])';

