function varargout=set(m,Property,Value);
% LOCALBSPLINE/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:23 $

switch lower(Property)
case 'numknots'
	OldNum= get(m.xreg3xspline,'numknots');
   m.xreg3xspline=set(m.xreg3xspline,'numknots',Value);   
	if OldNum~=Value
		m= SetFeat(m,'default');
	end
otherwise
   try
      m.localmod=set(m.localmod,Property,Value);
   catch
      try
         m.xreg3xspline=set(m.xreg3xspline,Property,Value);
      catch
         % throw an error back to MATLAB
         error(['LOCALBSPLINE/SET invalid property ',Property]);
      end
   end  
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end