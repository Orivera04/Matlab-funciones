function ch=tostring(c,fact)
%TOSTRING  Create string representation of constraint
%
%  STR=TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:31 $

s=[num2cell(c.A) ; fact];
s=s(:,c.A~=0);
s= sprintf('%g*%s + ',s{:});
s= strrep(s,'+ -','- ');
% 'Aij*xj + ... <= bi'
ch= [s(1:end-2) sprintf('<= %g',c.b)]; 