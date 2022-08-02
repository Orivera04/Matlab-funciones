function machine = get_sf_data(Name);
%GET_SF_DATA will extract model data and state information.
%
%   [MACHINE] = GET_SF_DATA(NAME)
%   This function takes in the mdoel name and returns all the information
%   available about the satteflow machin within that model. This includes
%   all the states, charts, events, and data items.
%
%   INPUTS: 
%           Name   :  Model Name
%
%   OUTPUTS:
%           machine : structure of all the data of the stateflow machine
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.25.4.1 $
%   $Date: 2004/04/15 00:28:09 $
%

% chart{}
% chart_input
% chart_output
% chart_local (static)
%        function_name
%        prototype{}
%        return
%        temporary_data{}
%        local_define{}
% 

INPUT_DATA = 1;
OUTPUT_DATA = 2;
LOCAL_DATA = 0;
TEMPORARY_DATA = 6;
CONSTANT_DATA = 7;
FUNCTION_OUTPUT_DATA = 9;
FUNCTION_INPUT_DATA = 8;
OR_STATE = 0;
AND_STATE =  1;
FUNC_STATE = 2;
IMPORTED_DATA = 4;
EXPORTED_DATA = 5;
OUTPUT_EVENT = 2;
INPUT_EVENT = 1;
LOCAL_EVENT = 0;
FUNCTION_CALL_EVENT = 3;


empty=[];

cEmpty.input=empty;
cEmpty.output=empty;
cEmpty.functionInput = empty;
cEmpty.functionOutput = empty;
cEmpty.constant=empty;
cEmpty.temporary=empty;
cEmpty.local=empty;
cEmpty.inputEvent = empty;
cEmpty.outputEvent = empty;
cEmpty.localEvent = empty;
cEmpty.uniqueName = empty;

sEmpty.local = empty;
sEmpty.constant = empty;

fEmpty.local = empty;
fEmpty.constant = empty;
fEmpty.input = empty;
fEmpty.output = empty;
fEmpty.temporary = empty;

mEmtpy.local=empty;
mEmtpy.imported=empty;
mEmtpy.exported=empty;
mEmtpy.constant=empty;

machine = mEmtpy;

isTranslationAllowed = mpt_static_config('isTranslationAllowed');

chartList = sf_get(Name, 'ChartList');
linkChartList = sf_get(Name,'ChartListLinked');
chartList = [chartList,linkChartList];
machineID = sf_get(Name, 'MachineId');

machine.machineID = machineID;
machine.fullFileName = sf('get',machineID,'.fullFileName');
machine.modelName = sf('get',machineID,'.name');
for i=1:length(chartList)
    info = [];
    tinfo = [];
    chart{i}=cEmpty;
    if i <= length(chartList)-length(linkChartList)
         chartH = chartList(i).handle;
         chart{i}.name = sf('get',chartH,'.name');
     else
         chart{i}.name = sf('get',chartList(i).handle,'.name');
         chartHH = sf('get',chartList(i).handle,'.handle');
         chartH = sf('Private','block2chart',chartHH);
    end
    chart{i}.uniqueName = sf('get',chartH,'.unique.name');
    chart{i}.handle = chartH;
    info.dataH = sf('get',chartH,'.firstData');
    chart{i} = get_data_detail(chart{i}, info);
    tinfo.dataH = sf('get',chartH,'.firstEvent');
    while tinfo.dataH ~= 0	
        dataScope = sf('get',tinfo.dataH,'.scope');
        tinfo.name =  fliplr(deblank(fliplr(deblank(sf('get',tinfo.dataH,'.name')))));
        tinfo.triggerType = sf('get',tinfo.dataH,'.trigger');
        switch (dataScope)
            case INPUT_EVENT
                chart{i}.inputEvent{end+1}=tinfo;
            case OUTPUT_EVENT
                chart{i}.outputEvent{end+1}=tinfo;
            case LOCAL_EVENT
                chart{i}.localEvent{end+1}=tinfo;
            otherwise,
        end
        tinfo.dataH = sf('get',tinfo.dataH,'.linkNode.next');
        if isempty(tinfo.dataH) == 1
            break;
        end
    end
    tree = get_state_tree(chartH);
    chart{i}.exportChartFunctions = sf('get',chartH,'.exportChartFunctions');
    chart{i}.stateTree=tree;

    chart{i} = mpt_temp_promote(chart{i});
    
end
machine.chart = chart;
m_i = 1;
m_e = 1;
m_c = 1;
m_l = 1;

info.dataH = sf('get',machineID,'.firstData');
while info.dataH ~= 0
    
    dataScope = sf('get',info.dataH,'.scope');
    info.name = fliplr(deblank(fliplr(deblank(sf('get',info.dataH,'.name')))));
    info = sfdata_item_info(info);
    if isempty(dataScope) == 0
        switch (dataScope)
            case CONSTANT_DATA
                machine.constant{m_c}=info;
                machine.constant{m_c}.scope ='MACHINE_CONSTANT'; 
                m_c =  m_c + 1;
            case LOCAL_DATA
                machine.local{m_l}=info;
                machine.local{m_l}.scope ='MACHINE_LOCAL'; 
                m_l =  m_l + 1;
            case IMPORTED_DATA
                machine.imported{m_i}=info;
                machine.imported{m_i}.scope ='MACHINE_IMPORTED'; 
                m_i =  m_i + 1;
            case EXPORTED_DATA
                machine.exported{m_e}=info;
                machine.exported{m_e}.scope ='MACHINE_EXPORTED'; 
                m_e =  m_e + 1;
            otherwise,
        end
        info.dataH = sf('get',info.dataH,'.linkNode.next');
    else
        info.dataH = 0;
        disp('get_sf_data catch');
    end
end

if isTranslationAllowed ==1,
   machine = data_translation_check(machine);
end

return

 

