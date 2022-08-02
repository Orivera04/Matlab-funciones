function varargout=set(m,Property,Value);
%LOCALUSERMOD/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:04 $

switch lower(Property)
case 'userdefined'
   m.userdefined= Value;
case 'tbs'
    m.userdefined= set(m.userdefined,Property,Value);
    m.xregmodel=set(m.xregmodel,Property,Value);
otherwise
   try
      m.localmod=set(m.localmod,Property,Value);
   catch
      try
         m.xregmodel=set(m.xregmodel,Property,Value);
      catch
         lasterr
         error(['LOCALUSERMOD/SET invalid property ',Property]);
      end
   end  
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end