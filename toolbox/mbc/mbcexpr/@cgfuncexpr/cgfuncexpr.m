function fun = cgfuncexpr(varargin)
%CGFUNCEXPR Constructor for the cgfuncexpr class
%
%  F = CGFUNCEXPR returns an empty cgfuncexpr object.
%  F = CGFUNCEXPR(name , cgfuncmodel , ptrlist)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:55 $

if nargin==1 && isstruct(varargin{1})
    fun = varargin{1};
    e = fun.cgexpr;
    fun = rmfield(fun, 'cgexpr');    
else
    e = cgexpr;
    fun = struct('function' , [], 'version', 2);
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgfuncexpr:InvalidArgument', 'Name must be a string.');
        end      
        if isa(varargin{2} , 'cgfuncmodel')
            fun.function = varargin{2};
        else
            error('mbc:cgfuncexpr:InvalidArgument', 'Second argument must be a cgfuncmodel.');
        end
        if isa(varargin{3}, 'xregpointer') && (length(varargin{3})==nfactors(varargin{2}))
            e = setinputs(e, varargin{3});
        else
            error('mbc:cgfuncexpr:InvalidArgument', 'Input list must be an xregpointer of the correct length.');
        end
    end
end 

fun = class(fun , 'cgfuncexpr' , e);