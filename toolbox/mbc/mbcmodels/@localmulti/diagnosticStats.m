function [data,factors,specialPlots,olIndex]= diagnosticStats(L,X,Y)
%LOCALMULTI/diagnosticStats
% 
% [data,factors,specialPlots,olIndex]= diagnosticStats(m)
%
% This is an overloaded function to return
% stats and factors for the diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:39:53 $

m= get(L.xregmulti,'currentmodel');
set(m,'ytrans',get(L,'ytrans'));
% doe
[data,factors]= diagnosticStats(m,X,Y);

% This is a list of special plots. This can be empty
specialPlots= {'Local Response',...
      'Normal plot'};

olIndex= outliers(L,data,factors);