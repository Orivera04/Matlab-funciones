function R= loadobj(R);
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:54:57 $

if isa(R,'struct')
	R= xregrbf(R);
end
if ischar(R.kernel)
   R.kernel= str2func(R.kernel);
end

if ~isempty(R.om) && any(strcmp(getname(R.om),{'TrialWidths','WidPerDim'}))
    % update to new algorithm
    om= widthstep(R);
    R.om= setAltMgrs(R.om,getAltMgrs(get(om,'WidthAlgorithm')));
    set(om,'WidthAlgorithm',R.om);
    omStep= lsqom(R);
    omStep= setAltMgrs(omStep,getAltMgrs(get(om,'StepAlgorithm')));
    om= set(om,'StepAlgorithm',omStep);
    R.om= om;
end
