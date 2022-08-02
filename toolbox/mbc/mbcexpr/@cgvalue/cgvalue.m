function out = cgvalue(n , value, u)
%CGVALUE Constructor for cgvalue class (Parented by cgvariable)
%  v=cgvalue
%		returns an empty cgvalue object
%  v=cgvalue(name,[min max])
%		returns a pointer to a cgvalue object 
%  An object which simply holds the value of a double or vector of doubles.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:16:13 $

v = struct('bounds',[-1 1],'version',2);
e = cgvariable;
if nargin > 0
    if isstruct(n)
        e = n.cgvariable;
        v = mv_rmfield(n, 'cgvariable');
    else
        e = setname(e , n);
        if nargin > 1
            if length(value) == 1
                v.bounds = [value value];
            else
                v.bounds = [min(value) max(value)];
            end
            e = setvalue(e, value);
            e = setnomvalue(e, value(1));
            if nargin > 2
                error('cgvalue : Too many constructor arguments');
            end
        end   
    end
    v = class(v , 'cgvalue' , e);
    out = xregpointer(v);
else
	v = class(v , 'cgvalue' , e);
	out = v;
end
