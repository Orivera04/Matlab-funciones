function d=det_xtx(m)
%xreglinear/DET_XTX   Determinant of X'X
%   d=DET_XTX(m) calculates |X'X| for the model m

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:23 $


if ~isfield(m.Store,'Q')
   error('Use initstore first to initialise qr data in model');
end

r=abs(diag(m.Store.R));

d=exp(2*sum(log(r)));





