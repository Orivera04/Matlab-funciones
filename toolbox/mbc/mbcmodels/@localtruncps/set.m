function varargout=set(m,Property,Value);
% TRUNCPS/SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:43:13 $

switch lower(Property)
case 'knot'
	nk= length(Value);
	if length(m.knots)~=nk
		nl= numParams(m.xreglinear);
		p= double(m.xreglinear);
		p= [p(1:end-length(m.knots));zeros(nk,1)];
		m.xreglinear= update(m.xreglinear,p);
	end
	
   m.knots= Value; 
	
case 'order'
   m.order= Value;   
otherwise
   try
      m.localmod=set(m.localmod,Property,Value);
   catch
      try
         m.xreglinear=set(m.xreglinear,Property,Value);
      catch
         % throw an error back to MATLAB
         error(['TRUNCPS/SET invalid property ',Property]);
      end
   end  
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end
