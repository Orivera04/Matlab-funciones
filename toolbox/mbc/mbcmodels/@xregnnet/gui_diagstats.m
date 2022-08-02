function varargout= gui_diagstats(m,Action,varargin)
% NNMODEL/GUI_DIAGSTATS
% 
% GUI Tool for displaying ANOVA Table and other Statistics
% This is based on the statistics calculated by
% s = stats(m,'stepwise').
% This tool makes extensive use of TABLES
%
% See also NNMODEL/STATS, TABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:22 $

switch lower(Action)
case 'create'
   % create tool
   varargout{1}=i_Create(varargin{:});
case 'id'
   varargout{1}='xregnnet';
end

function Tool= i_Create(hFig);
% create Stats tables

Tool.layout= xregcontainer(hFig);

