function L= pevinit(L,Xfitdata,Yfitdata);
% PEVINIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:37:50 $


if nargin==3
   [Xd,Y]= checkdata(L,Xfitdata,Yfitdata);
   if isa(L.model,'xregarx')
      % initialize initial conditions
      L.model= set(L.model,'InitialConditions',Y(1));
  end
else
   L= var(L,zeros(size(L,1)),Inf,0);
end

% PEV is initialized by fitmodel and is constant for all tests
