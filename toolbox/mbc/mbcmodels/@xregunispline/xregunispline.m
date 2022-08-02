function S= xregunispline(varargin)
% XREGUNISPLINE a  univariate spline model with free knots
% 
% S= xregunispline;
% S= xregunispline('nfactors',1);
% S= xregunispline(order,knots,var);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:43 $

if nargin < 1
   varargin= {3,0,xregcubic([]),1,1,'N'};
end

if nargin & ischar(varargin{1})
   switch lower(varargin{1})
   case 'nfactors'
      if varargin{2}>1
         error(['Free Knot splines are only available for single',...
               ' factor experiments.']);
      else
         S=xregunispline;
         return
      end
   end
end

if nargin ==1 & isa(varargin{1},'xreg3xspline');
   m=varargin{1};
   % get rid of any coding 
   
   basemodel= xregmodel;
   c= get(m,'code');
   set(m,'code',c(~1));
   
   yt= get(m,'ytrans');
   set(m,'ytrans','');
   
   set(basemodel,'code',c);
   set(basemodel,'ytrans',yt);
   
else
   m= xreg3xspline(varargin{:});
   basemodel= xregmodel;
   
end



S.version=1.0;
S.FitOptions.Algorithm='LSQnonlin';
S.FitOptions.Param.Max_Knots			= 1;
S.FitOptions.Param.Init_Pop			= 15;
S.FitOptions.Param.Percent_Opt		= 8;
S.FitOptions.Param.Max_Iter			= 150;
S.FitOptions.Param.Max_Func			= 150;
S.FitOptions.Param.Bit_Len				= 16;
S.FitOptions.Param.Max_Gen				= 50;
S.FitOptions.Param.Jupp					= 0;
S.mv3xspline=m;

S=class(S,'xregunispline',basemodel);
