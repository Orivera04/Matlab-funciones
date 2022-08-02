function varargout=set(m,Property,Value);
% LOCALMOD/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:38 $

switch lower(Property)
case 'delg';
   m.delG = Value;
case 'datumtype'
   if m.DatumType~=Value
      m.DatumType=Value;
      m.Type= DatumDisplay(m,m.Type);
   end
case 'limits'
   m.Limits= Value;
case 'fitdisplay'
   m.FitOptions.DispHndl=Value;
otherwise
   error('LOCALMOD/SET invalid property')
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end