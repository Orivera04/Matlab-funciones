function out=isinitialised(des)
% ISINITIALISED   Indicate if design has been initialised
%
%   RET=ISINITIALISED(D) returns 1 if D has been initialised,
%   0 otherwise.  By initialised, we mean the design object
%   contains valid design points, whether they are optimised
%   or not.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:02 $


if isempty(des.design)
   out=0;
else
   out=1;
end
