function FX=fx(m)
%xreglinear/FX  FX matrix
%   f=FX(m) extracts the FX data from the model store

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:31 $


if ~isfield(m.Store,'Q')
   error('Use initstore first to initialise data in the model');
end

FX=m.Store.X;
