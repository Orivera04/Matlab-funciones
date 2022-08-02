function [LocalMap,GlobalMap,OpPoints]= AllLocalModels(T,filename)
%ALLLOCALMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.5 $  $Date: 2004/04/04 03:31:26 $

G = getModel(T.DesignDev);
X = getdata(T,'X');
OpPoints = double(X{end});

p = children(T,'bestmdev');
GlobalMap = children(T,'xregstatsmodel');
LocalMap=  cell(1,length(p));
LocalOK = true(size(OpPoints,1),1);
TS = HSModel(T.DesignDev);
BdryModel = BoundaryModel(T,TS);

for i = 1:length(p)
    if p{i}==0
        % use the first local model if there is not a best one
        p(i) = children(T,i,'children',1);
    end
    [LocalMap{i},TPOK]= LocalModel(p{i}.info,':');
    LocalMap{i} = LocalMap{i}(:);
    LocalOK = LocalOK & TPOK(:);
    
    % make a switch model 
    m = xregmodswitch(LocalMap{i}(TPOK), OpPoints(TPOK,:), G);
    INFO = exportinfo( info(project(T)) ,p{i}, {m});
    GlobalMap{i} = xregstatsmodel(m,varname(m),INFO,BdryModel); 
end

if nargin>1
	save('-mat',filename,'GlobalMap','OpPoints');
end
