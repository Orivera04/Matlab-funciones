function varargout= gui_diagstats(m,Action,varargin)
% DISPSTATS
% 
% GUI Tool for displaying ANOVA Table and other Statistics
% This is based on the statistics calculated by
% s = stats(m,'stepwise').
% This tool makes extensive use of UITABLES
%
% See also xreglinear/STATS, UITABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:30 $

varargout=cell(1,nargout);
[varargout{:}]= gui_diagstats(get(m,'currentmodel'),Action,varargin{:});