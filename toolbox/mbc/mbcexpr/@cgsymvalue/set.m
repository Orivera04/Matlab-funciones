function varargout = set(sv, Property, Value);
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:15:58 $



%*****
%  This function is maintained for backwards compatibility.  Please use the
%  new setXYZ, getXYZ functions for accessing the fields of this object.
%*****




switch lower(Property)
    case 'value'
        % call the setvalue routine
        setvalue(sv, Value);
    case 'setpoint'
        % call the setpoint routine
        setnomvalue(sv, Value);
    otherwise
        sv.cgvalue=set(sv.cgvalue,Property,Value);
end

if nargout==1
   varargout{1} = sv;
else
   assignin('caller', inputname(1), sv);
end
