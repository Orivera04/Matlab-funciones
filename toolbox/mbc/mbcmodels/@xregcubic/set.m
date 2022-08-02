function varargout= set(m,prop,value);
% xregcubic/SET overloaded set for xregcubic
%
% m= set(m,prop,value)
%   xregcubic properties
%     'symbol'   factor symbols
%     'order'    polynomial order for each factor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:39 $



switch lower(prop)
case 'order' 
   value=value(:)';
   
	m= termCount(m,value,m.MaxInteract);
	
case 'maxinteract' 
	
	m= termCount(m,get(m,'order'),value);
   
otherwise
   % get properties from parent
   m.xreglinear= set(m.xreglinear,prop,value);
end

if nargout==1
   varargout{1}= m;
else
   assignin('caller',inputname(1),m)
end