function out = cgminmaxexpr(varargin)
%CGMINMAXEXPR Expression that chooses min/max of expression
%
%  The cgminmax expression object chooses the min/max of a set of input
%  expressions.
%
%  clip_object = CGMINMAXEXPR
%  clip_object = CGMINMAXEXPR(namestr, input, type)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:44 $

if nargin==1 && isstruct(varargin{1})
    out = varargin{1};
    e = out.cgexpr;
    out = rmfield(out, 'cgexpr');    
else
    e = cgexpr;
    out = struct('min', 1, 'version', 2);
    
    
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgminmaxexpr:InvalidArgument', 'Name must be a string.');
        end  
        if nargin>1
            if isa(varargin{2}, 'xregpointer')
                e = setinputs(e, varargin{2});
            else
                error('mbc:cgminmaxexpr:InvalidArgument', 'Inputs must be an xregpointer.');
            end
            if nargin>2
                if isa(varargin{3} , 'double') || islogical(varargin{3})
                    out.min = varargin{3};
                else
                    error('mbc:cgminmaxexpr:InvalidArgument', 'Type must be 0/1.');
                end
            end
        end
    end
end 

out = class(out , 'cgminmaxexpr' , e);