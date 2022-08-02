function T = cacheTSSF(T)
%CACHETSSF Enable caching in the data if it is supported
%
%  T= cacheTSSF(T) enables caching in the sweepset data object for the
%  testplan, if it is supported.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.3 $    $Date: 2004/02/09 08:07:34 $ 

if IsMatched(T)
    if ~isa(T.DataLink,'xregpointer')
        % this is the upgrade route
        T = i_upgrade2TSSF(T);
    end
    % turn caches on for data
    [Xp,Yp] = dataptr(T);
    if Yp.isa('sweepsetfilter')
        Xp(1).info = setCacheState(Xp(1).info, true);
        Yp.info    = setCacheState(Yp.info, true);
    end
else
    % make sure the datalink is unset
    T.DataLink = xregpointer;
    T = info( xregpointer(T) );
end




function T= i_upgrade2TSSF(T)

[Xp,Yp]= dataptr(T);
% make tssf and put it on the heap
ssf= info(dataptr(T.DataLink));
sindex= get(T.DataLink,'reordersweeps');
if ~isempty(sindex)
    ssf= reorderSweeps(ssf,sindex{1});
end

% make tssf
tssf= testplansweepsetfilter(ssf,T);

if ~isa(ssf,'testplansweepsetfilter')
    % use same location
    pTSSF = dataptr(T.DataLink);
    pTSSF.info= tssf;
else
    % new copy required
    pTSSF = xregpointer(tssf);
    % add to project data list
    pProject= project(T);
    pProject.addData(pTSSF); 
end
T.DataLink= pTSSF;

des= getdesign(T.DesignDev);
% make actual design
xg= Xp(end).double;
xg= code(model(T),xg);
settings= factorsettings(des);
settings(1:size(xg,1),:)= xg;
T.DesignDev= setActualDesign(T.DesignDev,des);

if strcmp(name(des), 'Experimental Design')
    % delete old data design from tree
    dtree= T.DesignDev.DesignTree;
    dtree.designs(dtree.chosen)= [];
    dtree.parents(dtree.chosen)= [];
    % Re-link any of the design's children to the parent node
    dtree.parents(dtree.parents==dtree.chosen) = 1;
    % Fix linking for any other designs further down in the tree
    dtree.parents(dtree.parents>dtree.chosen) = dtree.parents(dtree.parents>dtree.chosen)-1;
    dtree.chosen= 1;
    T.DesignDev.DesignTree= dtree;
else
    % free all points in best design
    des= setuserfixed(des, 1:size(des,1), false);
    T.DesignDev= setdesign(T.DesignDev,des);
end

xregpointer(T);

% stage 1 data is now a sweepsetfilter
xOld= Xp(1).info;
xData= sweepsetfilter(pTSSF);

% add the x data initially
xData= addVarsFilter(xData,get(xOld,'name'));
% we should just get old data + any new factor signals
Xp(1).info= xData;

% data now stored as sweepset filter
yOld = Yp.info;
yData= sweepsetfilter(pTSSF);

% add the x data initially
yData= addVarsFilter(yData,get(yOld,'name'));
Yp.info= yData;


T= info(T);
