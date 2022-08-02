function ch= char(c)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:41 $

ch=cell(length(c.Constraints),1);

for n=1:size(ch,1)
   ch(n)={tostring(c.Constraints{n},c.Factors)};   
end
ch= char(ch);