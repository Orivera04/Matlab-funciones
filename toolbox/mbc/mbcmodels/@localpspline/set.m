function varargout=set(m,Property,Value);
% localpspline/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:33 $

switch lower(Property)
case 'knot'
   m.knot= Value;   
case 'store'
   m.Store=Value;
otherwise
   try
      m.localmod=set(m.localmod,Property,Value);
   catch
      try
         m.xregmodel=set(m.xregmodel,Property,Value);
      catch
         % throw an error back to MATLAB
         error(['localpspline/SET invalid property ',Property]);
      end
   end  
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end