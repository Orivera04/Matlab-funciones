function T= setupTSSF(T,Dp);
%MDEVTESTPLAN/SETUPTSSF
%
% T= setupTSSF(T);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.6.6.3 $    $Date: 2004/04/04 03:31:39 $ 


if nargin>1
    % use supplied dataset
    T.DataLink = Dp;
    % Modified the testplan so update the internal pointer - needed to
    % ensure that the call to testplansweepsetfilter has an up-to-date
    % internal pointer to T
    xregpointer(T);
end

% make testplan sweepset filter
ssf = sweepsetfilter(T.DataLink.info);

if numstages(T)==1 && numstages(sweepset(ssf))~=1
    % upgrade from old projects keeps reorder sweeps
    % this needs to be removed using a hack!!
    ssf = reorderSweeps(ssf,Inf);
    % define data as one-stage
    ssf =  modifyTestDefinition( ssf ,{'#rec' 1 false []});
end
% choose data object and make tssf
tssf = testplansweepsetfilter(ssf, T);

% update project data list as required
MP = info(project(T));
if  numSharedData(MP,T.DataLink) > 1 
    % assign to new location if used in another testplan
    T.DataLink = xregpointer(tssf);
    % add to project list
    MP = addData(MP, T.DataLink);
else
    % place in present location
    T.DataLink.info = tssf;
end
% Update the internal pointer
xregpointer(T);

MP = cleanupData(MP,address(T));
