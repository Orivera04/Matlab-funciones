function varargout=set(m,Property,Value);
% xreglinear/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:50:07 $

switch lower(Property)
case 'status'
	if length(Value)~=length(m.Beta)
		error('Size of status variable must be the same as the size of xreglinear')
	end
	
   m.TermStatus= Value;
	
   % force terms in the model if status==1
   m.TermsOut(Value==1)= false;
   % force terms out of model  if status==2
   m.TermsOut(Value==2)= true;
   m.Beta(Value==2)= 0;
case 'store'
   m.Store=Value;
case 'lambda'
	m.lambda= Value;
case 'qr'
	m.qr= Value;
otherwise
   try
      m.xregmodel=set(m.xregmodel,Property,Value);
   catch
      error('xreglinear/SET invalid property');
   end
end
if nargout==1 
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end