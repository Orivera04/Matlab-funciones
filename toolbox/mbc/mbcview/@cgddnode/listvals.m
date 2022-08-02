function [tags,vals]=listvals(T,itemP);
%LISTVALS  return headers and values for subitem node in data dictionary
%
%   [TAGs,VALs]=listvals(ND,itemP)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:23:34 $


tags={'DDTAG_TYPE','DDTAG_ALIAS','DDTAG_MIN','DDTAG_MAX','DDTAG_VALUE','DDTAG_EQUATION'};

if nargin>1
    this=itemP.info;
    TP='Variable';
    if issymvalue(this)
        TP='Formula';
    end
    if isconstant(this)
        TP='Constant';
    end
    
    Alias = getaliasstring(this);
    
    if isconstant(this)
        Rmin = ''; Rmax = '';
    else
        R = getrange(this);
        Rmin = R(1);
        Rmax = R(2);
        if isinf(R(1))
            Rmin = '-Inf';
        end
        if isinf(R(2))
            Rmax = 'Inf';
        end
        if isnan(R(1))
            Rmin='NaN';
        end
        if isnan(R(2))
            Rmax = 'NaN';
        end
    end
    Value = getnomvalue(this);
    if isnan(Value)
        Value='NaN';
    end
    if isinf(Value)
        if Value > 0
            Value = 'Inf';
        else
            Value = '-Inf';
        end
    end
    
    if issymvalue(this)
        Equation = getequation(this);
    else
        Equation = '';
    end
    
    vals = {TP, Alias, Rmin, Rmax, Value, Equation};
else
    vals=[];
end