function varargout=set(m,Property,Value);
% POLYNOM/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:46 $

switch lower(Property)
otherwise
   try
      m.localmod=set(m.localmod,Property,Value);
   catch
      try
         m.xreglinear=set(m.xreglinear,Property,Value);
      catch
         s= lasterr;
         f= findstr(s,sprintf('\n'));
         error(sprintf('POLYNOM/SET invalid property: %s\n%s',Property,s(f(1)+1:end)));
      end
   end
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end