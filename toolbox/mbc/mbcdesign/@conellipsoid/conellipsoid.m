function [c,msg]=conellipsoid(sz,varargin)
%CONELLIPSOID  Ellipsoid constraint object
%
%  OBJ=CONELLIPSOID(size)  - size = number of factors.
%  OBJ=CONELLIPSOID(size,paramlist)  - see setparams for the paramlist
%    specifications.
%
%  CONELLIPSOID objects constrain points according to the equation (x-xc)'*W*(x-xc) < 1
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:57:58 $

if ~nargin
   sz=4;
end

if isstruct(sz)
   c=sz;
   if c.version < 3,
       parent = conbase( numel( c.xc ) );
       c.version = 3;
   else
       parent = c.conbase;
   end
else
   c.xc=repmat(0,1,sz);
   c.W=eye(sz);
   c.version = 3;
   c.scalefactor = 1;  % controls interior/exterior setting
   parent = conbase( sz );
end

c=class(c,'conellipsoid', parent );

if length(varargin)
   [c,msg]=setparams(c,varargin{:});
else
   msg={};
end

% Version history for CONELLIPSOID structure
%
% Version 1:
%    xc
%    W
%
% Version 2:
%    scalefactor
%
% Version 3:
%    conbase
