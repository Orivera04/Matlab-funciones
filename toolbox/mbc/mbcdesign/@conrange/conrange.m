function [c,msg] = conrange( sz, varargin )
%CONRANGE A short description of the function
%
%  [C,MSG] = CONRANGE(SZ,<ParameterList>) where SZ is the number of factors 
%   <ParameterList> is a possibly empty list of parameter-value pairs.
%  
%   CONSTAR objects constrain points according an rbf model of a star shaped 
%   region.
%
%   See also: CONBASE?SETPARAMS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:41 $ 

if ~nargin % no input arguments
    sz=2;
end

if isa( sz, 'conrange' ),
    c = sz;
else
    if isstruct( sz ), 
        if sz.Version == 1,
            c = sz;
            parent = sz.conbase;
            c = rmfield( c, 'conbase' );
        end
    else
        parent = conbase( sz );
        c.Version   = 1;
        c.Center    = repmat( 0.5, 1, sz );
        c.HalfWidth = repmat( 0.5, 1, sz );
    end
    c = class( c, 'conrange', parent );
end

if length( varargin ),
    [c, msg] = setparams( c, varargin{:} );
else
    msg={};   
end
