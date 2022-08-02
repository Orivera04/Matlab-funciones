function LT = setX(LT,x);
%SETX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:17 $

% Set the Xexpr field of the LUT to the expression x.
if isempty(x);
   LT.Xexpr = [];
elseif ~isa(x,'xregpointer')
   error('Input should be a xregpointer');
elseif ~isa(x.info,'cgexpr');
   error('Input is not an expression object');
end


LT.Xexpr = x;