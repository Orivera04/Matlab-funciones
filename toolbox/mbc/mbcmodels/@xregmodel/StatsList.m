function [List,Width,SummStatsType,MinIsBest]= StatsList(m,TypeFilter);
%XREGMODEL/STATSLIST
%
% [List,Width,SummStatsType,MinIsBest]= StatsList(m,x,y);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:51:15 $

if nargin<2
    TypeFilter='summary';
end

[MinIsBest,List,SummStatsType]= summary(m);
% can only use summary statistics with Type>0 for summary

filter= false(size(List));
filter(m.Stats.Summary)= true;
switch lower(TypeFilter)
    case 'summary'
        filter( SummStatsType<=0) = false;
    case 'data'
        filter(abs(SummStatsType)~=1)= false ;
    case 'multi'
        filter(SummStatsType==0)= false;
    case {'prune','all'}

    otherwise
        error('mbc:InvalidOption','Invalid summary statistics type')
end




List= List(filter);
MinIsBest= MinIsBest(filter);
SummStatsType= SummStatsType(filter);

[MainStats,Width]= colhead(m);

MinIsBest= [true(1,length(MainStats)) MinIsBest];
Width= [Width repmat(Width(end),1,length(List))];
Width= Width/sum(Width);
List= [MainStats List];

SummStatsType= [-1*ones(1,length(MainStats)) SummStatsType];
