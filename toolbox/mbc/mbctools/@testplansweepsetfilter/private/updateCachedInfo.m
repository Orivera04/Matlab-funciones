function [tssf] = updateCachedInfo(tssf)
%UPDATECACHEDINFO A short description of the function
%
%  TSSF = UPDATECACHEDINFO(TSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:12:33 $ 

% Get the data
data = sweepsetfilter(tssf);
% Is this empty because we haven't set the codeddesign or something
if ~isobject(tssf.codeddesign)
    tssf.codeddesign = Design(getTestplan(tssf));
end
% Get the local copy of the design 
codeddesign = tssf.codeddesign;
% Inverse code the design
uncodeddesign = invcode(model(codeddesign), codeddesign);
% Get the expected signal names
signals = globalsignalnames(tssf);
% Do these names exist in the sweepset? 
if isempty(find(data, signals))
    % Default global cache
    tssf.cachedInfo.globaldata = sweepset('variable', signals', [], [], [], [], [], zeros(0, length(signals))) ;
    % Default uncoded design cache
    tssf.cachedInfo.uncodeddesign = uncodeddesign;
    % Find the sweep means for matching
    tssf.cachedInfo.meandata = zeros(0, length(signals));
    % Find data that are already nailed into the design
    tssf.cachedInfo.designindata = [];
    % Find those indices in the data
    tssf.cachedInfo.dataindesign = [];
else    
    % We are only interested in the global signal names 
    tssf.cachedInfo.globaldata = data(:, signals);
    % Default uncoded design cache
    tssf.cachedInfo.uncodeddesign = uncodeddesign;
    % Find the sweep means for matching
    tssf.cachedInfo.meandata = mean(tssf.cachedInfo.globaldata);
    % Find data that are already nailed into the design
    tssf.cachedInfo.designindata = find(getdatapoint(codeddesign));
    % Need to code the data to compare to the design
    codedMeanData = code(model(codeddesign), tssf.cachedInfo.meandata);
    % Find those indices in the data
    tssf.cachedInfo.dataindesign = find(ismember(codedMeanData, codeddesign(tssf.cachedInfo.designindata, :), 'rows'))';
end
