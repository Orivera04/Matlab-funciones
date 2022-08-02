function [A,b]=linearConstr(c);
%LINEARCONSTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:01:56 $

p=[];
for n=1:length(c.Constraints)
   if islinear(c.Constraints{n})
      p=[p getparams(c.Constraints{n})];
   end
end
if ~isempty(p)
	A= cat(1,p(:).A);
	b= cat(1,p(:).b);
else
	A=zeros(0,length(c.Factors));
	b=[];
end