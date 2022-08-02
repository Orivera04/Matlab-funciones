function sol = getSol(cgc, varargin)
%GETSOL Get the Pareto solution index for given operating point(s)
%
%  SOL = GETSOL(CGC, ROWIND) Help needed here !
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:26 $ 

if length(varargin)
    sol = cgc.solutionNo(varargin{1});
else
    sol = cgc.solutionNo;
end


