function tssf = check(tssf)
%TSSF = CHECK(TSSF) checks for inconsistancy between data nailed into
%design and available data
%
%  TSSF = CHECK(TSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:11:14 $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEED TO THINK ABOUT HOW THIS FUNCTION SHOULD OPERATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% get all data coming down from SSF
data = sweepset(tssf.sweepsetfilter);
ssGuids = getSweepGuids(data);

%% check any excluded Data points no longer exist?
% validGuids = ismember(tssf.excludedData, ssGuids);
% tssf.excludedData = tssf.excludedData(validGuids);

%% do any points nailed into Design no longer exist in the data?
%% if so we need to un-nail them
D = get(tssf, 'actualDesign');
designNailed = get(tssf,'designthataredata');
nailedInds = get(tssf,'designthataredatainds');

%% strip out only those factors that appear in the design
% we deal with global variables = sweep means
data = get(tssf, 'dataindesign');

%% cut out those data already nailed into the Design
inds = ismember(designNailed, data, 'rows');
%% find indices into original design
if ~isempty(nailedInds)
    toFreeInDesign = nailedInds(~inds);
    %% do this to the actualDesign
    if ~isempty(toFreeInDesign)
        tssf.codeddesign = setdatapoint(D, toFreeInDesign, false);
        queueEvent('tssfActualDesignChanged');
    end
end
