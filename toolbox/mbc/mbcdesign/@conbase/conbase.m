function [c, msg] = conbase( sz )
%CONBASE A short description of the function
%
%  OUT = CONBASE(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:56 $ 

msg = {};

if ~nargin % no input arguments
    sz=2;
end

if isa( sz, 'conbase' ),
    c = sz;
else
    if isstruct(sz), 
            c = sz;
    else
        c.Version = 1;
        c.Variables = true( 1, sz );
        
        c.SpecialPointOptions = [];
        c.BdryPointOptions    = [];
        c.ModelFitOptions     = [];
    end
    c = class( c, 'conbase' );
end
