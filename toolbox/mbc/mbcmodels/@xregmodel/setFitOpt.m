function varargout= setFitOpt(m,Prop,Val);
% MODEL/SETFITOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:04 $

if nargin==2
	m.FitAlgorithm= Prop;
else
	m.FitAlgorithm= set(m.FitAlgorithm,Prop,Val);
end

if ~nargout & ~isempty(inputname(1));
	assignin('caller',inputname(1),m);
else
	varargout{1}= m;
end