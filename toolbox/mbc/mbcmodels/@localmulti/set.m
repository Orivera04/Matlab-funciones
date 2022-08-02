function varargout= set(L,Property,Value);
%LOCALAVFIT/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:40:11 $

switch Property
   case 'fitalg'
      
   otherwise
      try
         L.localmod= set(L.localmod,Property,Value);
      catch
         L.xregmulti= set(L.xregmulti,Property,Value);
      end
end
if nargout 
   varargout{1}=L;
else
   assignin('caller',inputname(1),L);
end
   
