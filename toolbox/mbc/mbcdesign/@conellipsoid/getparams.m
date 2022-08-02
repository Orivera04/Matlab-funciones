function p=getparams(c, type);
%GETPARAMS  Return parameters for object
%
%  S=GETPARAMS(C) returns a structure containing the parameters
%  for the constraint object C.  For conellipsoid objects the fields
%  are:
%       xc:  vector
%       W: matrix
%       ScaleFactor: scalar
%
%  S=GETPARAMS(C,'struct') returns the parameters in a structure.
%  S=GETPARAMS(C,'vector') returns the parameters in a row vector.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:58:02 $

if nargin < 2 || strcmpi( 'struct', type ),
    p = getparams( c.conbase );
    p.xc=c.xc;
    p.W=c.W;
    p.ScaleFactor = c.scalefactor;
    
else % if strcmpi( 'vector', type ),
    d = length( c.xc );
    p = zeros( 1, d + 0.5 * d * (d + 1) );
    
    R = chol( c.W );
    
    p(1:d) = c.xc;

    i = find( triu( ones( d ) ) );
    p((d+1):end) = R(i);
end
