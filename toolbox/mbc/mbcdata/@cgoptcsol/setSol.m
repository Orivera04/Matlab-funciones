function cgc = setSol(cgc, varargin)
%SETSOL Set the desired solution for the operating point(s)
%
%  CGC = SETSOL(CGC, OPPTNO, SOLNO)
%  
% Currently this function performs NO error checking, caller must ensure
% the inputs are valid

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:31 $ 

if length(varargin) > 1
    rind = varargin{1};
    data = varargin{2};
    cgc.solutionNo(rind) = data;
elseif length(varargin)
    data = varargin{1};
    cgc.solutionNo = data;
else
    % Shouldn't get here
end

