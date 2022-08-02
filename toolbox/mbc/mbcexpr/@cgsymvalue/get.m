function out = get(sv, property)
%GET get method.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:15:26 $



%*****
%  This function is maintained for backwards compatibility.  Please use the
%  new setXYZ, getXYZ functions for accessing the fields of this object.
%*****



if nargin == 1
    out.value = 'scalar or vector double';
    out.name = 'char name of object';
    out.type = 'char description of class';
    out.linkptr = 'linked pointer';
    out.equation = 'inline object to make the value calculate a function of a linked object';
    out.descr = 'Text description of the variable';
else
    switch property
        case {'value','values'}
            out = getvalue(sv);
        case 'setpoint'
            out = getnomvalue(sv);
        case 'type'
            out = 'Formula';
        otherwise
            out =get(sv.cgvalue,property);
    end
end