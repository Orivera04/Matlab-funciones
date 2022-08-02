function LT = setX(LT,x);
%SETX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:30 $

% Set the Xexpr field of the dummy normaliser to the expression x.

if isempty(x)
   dummyNorm = get(LT.cgnormfunction,'x');
   dummyNorm.info = dummyNorm.set('x', []);
elseif ~isa(x,'xregpointer')
   error('Input should be an xregpointer');
elseif ~isa(x.info,'cgexpr');
   error('Input is not an expression object');
end

dummyNorm = get(LT.cgnormfunction,'x');
dummyNorm.info = dummyNorm.setX(x);
