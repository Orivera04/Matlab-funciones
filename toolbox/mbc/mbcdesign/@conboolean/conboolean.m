function [c,msg] = conboolean( sz, varargin )
%CONBOOLEAN   Boolean combination of constraint objects
%   [C,MSG] = CONSTAR(N,<ParameterList>) where N is the number of factors 
%   <ParameterList> is a possibly empty list of parameter-value pairs.
%
%   CONBOOLEAN are constraint objects that combine other constraint obejcts
%   using boolean operators, i.e, and, or, xor and not.
%
%   CONBOOLEAN constraints contain a number of other constraints. For 'Not'
%   objects there can only be one contained constraint. For 'And' and 'Or'
%   constraints there are two or more contained constraints. For 'Xor'
%   constraints there are two contained constraints.
%
%   Note that and is equivalent to intersection and or is equivalent to
%   union.
%
%   See also: CONBASE/AND, CONBASE/OR, CONBASE/XOR, CONBASE/NOT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:27 $ 

if ~nargin, % no input arguments
    sz = 2;
end

if isa( sz, 'conboolean' ),
    c = sz;
else
    parent = conbase( sz );
    if isstruct( sz ), 
        c = sz;
    else
        c.Version = 1;
        c.Constraints = {};
        c.Not = 0;
        c.Op = 'and';
    end
    c = class( c, 'conboolean', parent );
end

if length( varargin ),
    [c,msg] = setparams( c, varargin{:} );
else
    msg = {};   
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
