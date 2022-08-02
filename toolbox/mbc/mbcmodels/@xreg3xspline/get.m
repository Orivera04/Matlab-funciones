function val= get(m,prop);
% xreg3xspline/GET overloaded get function for xreg3xspline
%
% Value= get(m,'Property')
% Properties
%  'symbol'       Factor Labels 
%  'order'        Factor Order
%  'knots'        Knot Position (in (-1,1)).
%  'naturalknots' Raw knots
%  'interact'     Interaction Level
%  'spline'       Index to Spline Variable
%  'numknots'     Number of knots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:43:26 $



if nargin==1
	val= [{'order','knots','naturalknots','interact',...
			'spline','reorder','numknot','polyorder'}';get(m.xreglinear)];
else
	switch lower(prop)
	case 'order'
		o3= get(m.cubic,'order');
		i=m.splinevar ;
		% insert spline variable in correct position
		val = [o3(1:i-1) m.poly_order o3(i:end)];
	case 'knots'
		val = m.knots;
	case 'naturalknots'
		var=get(m,'spline');
		K= ones(length(m.knots),length(get(m,'symbol')));
		K(:,var)= m.knots(:); 
		K= invcode(m,K);
		val=K(:,var);  
	case 'interact'
		val = m.interact;
	case 'spline'
		val = m.splinevar;
	case 'reorder'
		o3= get(m.cubic,'reorder');
		i=m.splinevar ;
		o3(o3>=i)= o3(o3>=i)+1;
		% insert spline variable in correct position
		val = [m.splinevar o3];
	case 'numknots'
		val=length(m.knots);
	case 'polyorder'
		val= m.poly_order;
	otherwise
		% Call parent get
		val= get(m.xreglinear,prop);
	end
end