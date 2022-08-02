function [s,List,Width,MinIsBest]= FitSummary(m,varargin);
%XREGMODEL/FITSUMMARY
%
% [s,List,Width,MinMax]= FitSummary(m,x,y);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:51:05 $

% find list of all summary stats

if nargout>1
    [List,Width,SummStatsType,MinIsBest]= StatsList(m);
end

% model specific (old)
sMain= stats(m,'summary',varargin{:});

if ~isempty(m.Stats.Summary)
    % call extra statistics
    s =  summary(m,m.Stats.Summary,varargin{:});
    s= [sMain s];
else
    s= sMain;
end

    

