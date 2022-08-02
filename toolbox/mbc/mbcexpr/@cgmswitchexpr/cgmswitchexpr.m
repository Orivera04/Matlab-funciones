function out=cgmswitchexpr(varargin)
%CGMSWITCHEXPR Constructor for the cgmswitchexpr class
%
%  M = CGMSWITCHEXPR returns an empty cgmswitchexpr.
%  M = CGMSWITCHEXPR(name,input,ptrList) returns an cgmswitchexpr object.
%
%		Output = the ith element of ptrList where i = round(eval(input))
%		i < 0.5 or i>=(length(listPtrs)+0.5) gives an output of Nan

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:28 $

if nargin==1 && isstruct(varargin{1})
    out = varargin{1};
    e = out.cgexpr;
    out = rmfield(out, 'cgexpr');    
else
    e = cgexpr;
    out = struct('version', 2);
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgmswitchexpr:InvalidArgument', 'Name must be a string.');
        end
        % The switch expression always has a pointer to a switch input:
        % this is initialised to null.
        inputs = null(xregpointer,1);
        if nargin>1
            if isa(varargin{2} , 'xregpointer')
                inputs(1) =  varargin{2};
            else
                error('mbc:cgmswitchexpr:InvalidArgument', 'Switch input must be an xregpointer.');
            end
            if nargin>2
                if isa(varargin{3}, 'xregpointer')
                    inputs = [inputs varargin{3}(:)'];
                else
                    error('mbc:cgmswitchexpr:InvalidArgument', 'Input must be an xregpointer.');
                end
            end 
        end
        e = setinputs(e, inputs);
    end
end 

out = class(out , 'cgmswitchexpr' , e);