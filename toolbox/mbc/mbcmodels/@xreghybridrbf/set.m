function varargout = set(m, Property, Value);
% HYBRIDRBF/SET
%
%   Properties:
%   RbfPart
%   LinearmodPart
%   ChosenOrder
%   Lambda

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:48:21 $




switch lower(Property)
case 'rbfpart'
     m.rbfpart = Value;
     beta = [double(m.linearmodpart);double(m.rbfpart)];
     m = update(m,beta);
     ind= size(m.linearmodpart,1)+1:length(beta);
     m= setstatus(m,ind,getstatus(Value));
case 'linearmodpart'
     m.linearmodpart = Value; 
     beta = [double(m.linearmodpart);double(m.rbfpart)];
     m = update(m,beta);
     m= setstatus(m,1:size(Value,1),getstatus(Value));
otherwise
   try
      m.xreglinear=set(m.xreglinear,Property,Value);
   catch    
      lasterr
      error(strvcat(['XREGHYBRIDRBF/SET invalid property ',Property],lasterr));  
   end
end
if nargout==1
   varargout{1} = m;
else
   assignin('caller', inputname(1), m);
end
