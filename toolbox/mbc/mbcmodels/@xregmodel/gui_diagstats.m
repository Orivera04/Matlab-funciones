function varargout= gui_diagstats(m,Action,varargin)
% xregUniSpline/GUI_DIAGSTATS
% 
% GUI Tool for displaying ANOVA Table and other Statistics
% This is based on the statistics calculated by
% s = stats(m,'stepwise').
% This tool makes extensive use of UITABLES
%
% See also xreglinear/STATS, UITABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:09 $

switch lower(Action)
case 'create'
   % create tool
   varargout{1}=i_Create(varargin{:});
case 'id'
   varargout{1}='model';
end

function Tool= i_Create(hFig);
% create Stats tables

Tool.layout= xregcontainer(hFig);


