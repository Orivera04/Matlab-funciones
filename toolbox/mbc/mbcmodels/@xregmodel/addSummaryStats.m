function m= setSummaryStats(m,Criteria);
%XREGMODEL/SETSUMMARYSTATS
%
% m= setSummaryStats(m,S);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:51:20 $

[dummy,List]= summary(m);
newInd= find(strcmp(List,Criteria) );
m.Stats.Summary= unique([m.Stats.Summary(:); newInd]);
