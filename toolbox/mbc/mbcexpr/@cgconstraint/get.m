function property_value = get(obj, property_name);
%GET Cgconstraint get method.
%
%  VAL = GET(OBJ, VALUE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:15 $

if nargin==1
    % just return structure
    property_value = struct(obj);
else
    switch upper(property_name)
     case 'TYPE'
      property_value = 'Constraint';
     case 'EVALTYPE'
      property_value = obj.evaltype;
     case 'CONOBJ'
      property_value = obj.conobj;
     case 'FACPTRS'
      property_value = getinputs(obj);
     otherwise
         try
             s = getparams(obj.conobj);
             property_value = getfield(s,property_name);
         catch      
             error('Unknown property name');
         end
    end
end
