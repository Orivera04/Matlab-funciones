function [c,msg] = contwostage( Local, Global )
%CONTWOSTAGE Two-stage constraint model
%
%  OUT = CONTWOSTAGE(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:34 $ 

if nargin < 1,
    Local = conellipsoid( 2 );
end
if nargin < 2,
    Global = xreginterprbf( 'nfactors', 2 );
end
if ~iscell( Global ),
    nr = numfeats( Local );
    [tmp{1:nr}] = deal( Global );
    Global = tmp;
end

c.Local = Local;
c.Global = Global;
parent = conbase( getsize( Local ) + nfactors( Global{1} ) );

c = class( c, 'contwostage', parent );
