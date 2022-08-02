function varargout= set(L,Property,Value);
%LOCALAVFIT/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:54 $

try
   L.localmod= set(L.localmod,Property,Value);
catch
   try
      L.xregmodel= set(L.xregmodel,Property,Value);
   catch
      L.model= set(L.model,Property,Value);
   end
end

if nargout 
   varargout{1}=L;
else
   assignin('caller',inputname(1),L);
end
   
