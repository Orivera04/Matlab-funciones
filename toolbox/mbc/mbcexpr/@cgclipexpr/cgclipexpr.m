function c = cgclipexpr(varargin)
%CGCLIPEXPR Limiting expression
%
%  The cgclipexpr object limits an input expression between min and max
%  bounds.  This is equivalent to Simulink saturation or strategy
%  cgclipexpr blocks.
%
%  clip_object = CGCLIPEXPR
%  clip_object = CGCLIPEXPR(namestr);
%  clip_object = CGCLIPEXPR(namestr,[min max]);
%  clip_object = CGCLIPEXPR(namestr,[min max],inputPtr);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:03 $

if nargin==1 && isstruct(varargin{1})
    c = varargin{1};
    e = c.cgexpr;
    c = rmfield(c, 'cgexpr');    
else
    e = cgexpr;
    c = struct('bound', [-inf,inf], 'version', 2);
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgclipexpr:InvalidArgument', 'Name must be a string.');
        end  
        if nargin>1
            if isa(varargin{2} , 'double')
                c.bound = varargin{2};
            else
                error('mbc:cgclipexpr:InvalidArgument', 'Second argument must be a cgfuncmodel.');
            end
            if nargin>2
                if isa(varargin{3}, 'xregpointer')
                    e = setinputs(e, varargin{3});
                else
                    error('mbc:cgclipexpr:InvalidArgument', 'Input must be an xregpointer.');
                end
            end
        end
    end
end 

c = class(c , 'cgclipexpr' , e);