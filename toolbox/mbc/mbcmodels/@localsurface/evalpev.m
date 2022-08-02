function p= evalpev(x,L,varargin);
%EVALPEV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:05 $

FX= CalcJacob(L,x);

Ri= var(L);

% calculate inverse and use multiplication
pev= FX*Ri;

p= sum(pev.^2,2);

