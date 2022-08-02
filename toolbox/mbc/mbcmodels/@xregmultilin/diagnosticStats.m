function [data,factors,specialPlots,olIndex]= diagnosticStats(m,X,Y)
% xreglinear/diagnosticStats
% 
% [data,factors, specialPlots]= diagnosticStats(m)
%
% This is an overloaded function to return
% stats and factors for the diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:22 $

[data,factors,specialPlots,olIndex]= diagnosticStats(get(m,'currentmodel'),X,Y);