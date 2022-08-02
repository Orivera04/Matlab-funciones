function tuneInfo = ec_get_sf_tunable(modelName)
%EC_GET_SF_TUNABLE detects all Stateflow tunable or parameters.

%   Copyright 1994-2004 The MathWorks, Inc.

tuneList=[];
rt=sfroot;
m = rt.find('-isa', 'Stateflow.Machine', '-and', 'Name',modelName);
charts = m.find('-isa','Stateflow.Chart');
index=1;
tuneInfoList=[];
for i=1:length(charts)
    data = charts(i).find('-isa','Stateflow.Data','-and','Scope','Parameter');
    for j=1:length(data)
        info=[];
        info.pObj{1}.name = data(j).Name;
        info.pObj{1}.paramRef = 'WSName';
        info.pObj{1}.value = [];
        info.pObj{1}.exist = 1;
        info.pObj{1}.minDim = 1;
        info.numberOfParam = 1;
        info.blocktype = 'Stateflow';
        info.srcBlkHandle = [];
        tuneList{index} = data(j).Name;
        tuneInfoList{index} = info;
        index = index + 1;
        if  evalin('base', ['exist(''',info.pObj{1}.name,''')']) == 0
            assignin('base',info.pObj{1}.name,0);
            info.pObj{1}.exist=0;
        else
            info.pObj{1}.exist=1;
        end
    end
end
[tuneList,I,J] = unique(tuneList);
tuneInfo = tuneInfoList(I);
