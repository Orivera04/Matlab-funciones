function [Error, dEidRj] = zerobootsub(EndRates, CFSet, Times, RateMap)
%ZEROBOOTSUB Objective function for zeroboot
%   [Error, dEidRj] = zerobootsub(EndRates, CFSet, Times, RateMap)

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/04/14 21:57:53 $

Rates = RateMap * EndRates;
Disc    = (1 + 0.5*Rates).^(-Times);
DelDisc = (1 + 0.5*Rates).^(-Times-1) .* (-Times*0.5);
DelDisc(1) = 0;

% Objective
Error  = CFSet*Disc;

% dEidRj = CFSet*diag(DelDisc)*RateMap;
dEidRj = CFSet*(DelDisc(:,ones(1,size(RateMap,2))).*RateMap);
