function out=cgrelexpr(varargin)
%CGRELEXPR Constructor for the cgrelexpr class
%
%  R = CGRELEXPR returns an empty cgrelexpr.
%  R=CGRELEXPR(name,Left, Right, Relation) returns a cgrelexpr object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $  $Date: 2004/02/09 07:15:13 $


% cgrelexpr keeps the inputs in the parent cgexpr class.  There are two
% pointers: the first corresponds to the "left" input and the second
% corresponds to the "right" input.

if nargin==1 && isstruct(varargin{1})
    out = varargin{1};
    e = out.cgexpr;
    out = rmfield(c, 'cgexpr');    
else
    e = cgexpr;
    out = struct('rel', '<=', 'version', 2);
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgrelexpr:InvalidArgument', 'Name must be a string.');
        end  
        inputs = null(xregpointer, 1,2);
        if isa(varargin{2} , 'xregpointer')
            inputs(1) = varargin{2};
        else
            error('mbc:cgrelexpr:InvalidArgument', 'Left input must be an xregpointer.');
        end
        if isa(varargin{3}, 'xregpointer')
            inputs(2) = varargin{3};
        else
            error('mbc:cgrelexpr:InvalidArgument', 'Right input must be an xregpointer.');
        end
        e = setinputs(e, inputs);
        if ischar(varargin{4})
            out.rel = varargin{4};
        else
            error('mbc:cgrelexpr:InvalidArgument', 'Relation  must be a string.');
        end
        
    end
end 

out = class(out , 'cgrelexpr' , e);