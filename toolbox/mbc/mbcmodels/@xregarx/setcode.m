function m = setcode( m, bounds, g, target )
%XREGARX/SETCODE   Set the coding of the overall and the embedded model
%   SETCODE(M,BNDS)
%   SETCODE(M,BNDS,G)
%   SETCODE(M,BNDS,G,TGT)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:36 $

if nargin == 2,
    m.xregmodel = setcode( m.xregmodel, bounds );
elseif nargin == 3,
    m.xregmodel = setcode( m.xregmodel, bounds, g );
else,
    m.xregmodel = setcode( m.xregmodel, bounds, g, target );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
