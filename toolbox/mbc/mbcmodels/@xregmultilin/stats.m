function [varargout]= stats(m,RequiredStats,varargin);
% MODEL/STATS
% 
% [out,out2]= stats(m,RequiredStats,Xv,Yv);
%
% Inputs
%   m              xreglinear object (or child)
%   RequiredStats  String specifying required stats
%                   'local'    [R^2 F p]
%                   'stepwise' [[AnovaTable [PRESS,PRESS_rsq,R2]'] , [beta stdB]]
%                   'diagnostics' {cookd leverage r y X studres yhat ci_hi ci_lo}
%   Xv             (Optional) Validation X data (only used if RequiredStats=='diagnostics')
%   Yv             (Optional) Validation Y data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:59 $

[varargout{1:nargout}]= stats(get(m,'currentmodel'),RequiredStats,varargin{:});
if strcmp(lower(RequiredStats),'summary')
	% box-cox transform is stored in xregmultilin's model object and not current models.
	varargout{1}(3)= get(m,'boxcox');
end


