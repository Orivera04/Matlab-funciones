function val= get(m,prop);
% xregUniSpline/GET overloaded get function
%
% Value= get(m,'Property')
% Properties
%  'max_knots'
%  'init_pop'
%  'percent_opt'
%  'max_iter'
%  'max_func'
%  'bit_len'
%  'max_gen'
%  'fitoptions'
%  'algorithm'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:58:27 $


if nargin==1
	val= [get(m.mv3xspline)];
else
	Opts=m.FitOptions;
	Param=Opts.Param;
	switch lower(prop)
	case 'max_knots'
		val=Param.Max_Knots;
	case 'init_pop'
		val=Param.Init_Pop;
	case 'percent_opt'
		val = Param.Percent_Opt;
	case 'max_iter'
		val= Param.Max_Iter;  
	case 'max_func'
		val = Param.Max_Func;
	case 'bit_len'
		val = Param.Bit_Len;
	case 'max_gen'
		val=Param.Max_Gen;
	case 'jupp'
		val=Param.Jupp;
	case 'fitoptions'
		val=Opts;
	case 'algorithm'
		val=Opts.Algorithm;
	case {'xreg3xspline','xreg3xspline'}
		val=m.mv3xspline;
		c= get(m,'code');
		set(val,'code',c);
		
		yt= get(m,'ytrans');
		set(val,'ytrans',yt);
	case 'naturalknots'
		val= get(m.mv3xspline,'knots');
		val= invcode(m,val(:),get(m.mv3xspline,'spline'));
	otherwise
		% Call parent get
		try
			val= get(m.xregmodel,prop);
		catch
			val= get(m.mv3xspline,prop);
		end
	end
end