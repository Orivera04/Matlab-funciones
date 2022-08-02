function out = cgconstant(n,val,prec)
%CGCONSTANT Constructor for cgConstant class
%
%  c = CGCONSTANT returns an empty cgConstant object
%  c = CGCONSTANT(namestr,val) returns a xregpointer to a Constant object
%  with default floating point precision.
%  c = CGCONSTANT(namestr,val,precision) as above but with a defined
%  precision object.
%
%  Restrictions on arguments...
%    val             - scalar double or value object
%    precision       - @precision

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:12 $

c = struct('prec',cgprecfloat('double')); % Double precision
v = cgvalue;

if nargin == 0
    out = class(c , 'cgconstant' , v);
else
    if nargin==1
        % Convert structure to object
        c = n;
        v = c.cgvalue;
        c = rmfield(c, 'cgvalue');
    elseif nargin > 1
        if isa(val,'cgvalue')
            if isscalar(val)
                v=val;
            else
                error('mbc:cgconstant:InvalidArgument', 'Constant must be a scalar.');
            end
        elseif isa(val,'double')
            if length(val)>1
                error('mbc:cgconstant:InvalidArgument', 'Constant must be a scalar.');
            end
            v = set(v,'value',val);
        else
            error('mbc:cgconstant:InvalidArgument', 'Val argument must be a value object or a double.');
        end
        v = setname(v , n);
        if nargin > 2
            if isa(prec,'cgprec')
                c.prec = prec;
            else
                error('mbc:cgconstant:InvalidArgument', 'Precision argument must be of class @precision.');
            end
        end
    else
        error('mbc:cgconstant:InvalidArgument', 'Insufficient constructor arguments.');
    end
    out = class(c , 'cgconstant' , v);
end