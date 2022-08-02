function varargout= set(m,varargin);
% GET overloaded get function
%
% Value= set(m,'Property',value)
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


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:00:30 $

for i=1:2:length(varargin)
   switch lower(varargin{i})
   case 'max_knots'
      m.FitOptions.Param.Max_Knots=varargin{i+1};
   case 'init_pop'
      m.FitOptions.Param.Init_Pop=varargin{i+1};
   case 'percent_opt'
      m.FitOptions.Param.Percent_Opt=varargin{i+1};
   case 'max_iter'
      m.FitOptions.Param.Max_Iter=varargin{i+1};  
   case 'max_func'
      m.FitOptions.Param.Max_Func=varargin{i+1};
   case 'bit_len'
      m.FitOptions.Param.Bit_Len=varargin{i+1};
   case 'max_gen'
      m.FitOptions.Param.Max_Gen=varargin{i+1};
   case 'jupp'
      m.FitOptions.Param.Jupp = varargin{i+1};
   case 'fitoptions'
      m.FitOptions=varargin{i+1};
   case 'algorithm'
      m.FitOptions.Algorithm=varargin{i+1};
   otherwise
      try
         m.xregmodel=set(m.xregmodel,varargin{i:i+1});
      catch
         m.mv3xspline=set(m.mv3xspline,varargin{i:i+1});
      end
   end
end
if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end