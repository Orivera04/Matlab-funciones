function m= setFitOpt(m,Prop,Val);
% MODEL/SETFITOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:53:06 $

m.FitAlgorithm= set(m.FitAlgorithm,Prop,Val);

if ~nargout
	assignin('caller',inputname(1),m);
end
