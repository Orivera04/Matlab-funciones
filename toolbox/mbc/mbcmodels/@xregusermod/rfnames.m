function [rnames,defs]= rfnames(U);
% xregusermod/RFNAMES response feature names

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:01:38 $

[rnames,defs]= feval(U.funcName,U,'rfnames');
if isempty(rnames);
   rf= feval(U.funcName,U,'rfvals');
   for i=1:length(rf)
      rnames{i}= sprintf('RF_%d',i);
   end
	defs=[];
end
if isempty(defs)
	defs= 1:numParams(U);
end
