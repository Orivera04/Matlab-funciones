function varargout=set(m,Property,Value);
% LOCALSURFACE/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:32 $

switch lower(Property)
case 'model'
   m.userdefined= Value;
otherwise
   try
      m.localmod=set(m.localmod,Property,Value);
   catch
      try
         m.xregmodel=set(m.xregmodel,Property,Value);
      catch
         error(['LOCALSURFACE/SET invalid property ',Property]);
      end
   end  
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end