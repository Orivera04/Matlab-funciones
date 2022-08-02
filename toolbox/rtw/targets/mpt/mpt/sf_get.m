function value = sf_get(name, attribute)
%SF_GET provides a several core bits of information about a Stateflow
%   diagram. The command requires a full path name to the chart. Then a
%   specific attribute can be extracted per the following names:
%
%   VALUE = SF_GET(NAME, ATTRIBUTE)
%
%   INPUT:
%         name:       Full path name to chart.
%         attributes:
%              'ChartHandle'....Stateflow handle to the specified Stateflow
%                                diagram.
%              'ChartHGHandle'..Handle Graphics handle to the specified
%                               Stateflow diagram figure window.
%              'ChartList'......List of Stateflow Chart handles within
%                               the model.
%              'ChartListLinked'List of Linked Stateflow chart handles
%              'MachineId'......Stateflow handle to the machine id for
%                               the model
%              'StateList'......List of Stateflow Chart handles corresponding
%                               to states within a diagram.
%              'Version'........Stateflow Version Number.
%
%   OUTPUT:
%         Value:   Result of operation.

%   Steve Toeppe
%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.12.4.2 $
%   $Date: 2004/04/15 00:29:10 $

value = [];
try  %handle any invalid inputs or other problems.
attrib_lower=lower(attribute);
switch(attrib_lower)

    case 'charthandle'                %get chart handle associated with chart name
        value = sf('Private','block2chart',name);
% %         %parse name to get model name and chart name
% %         fullChartName = name;
% %         modelName = strtok(name,'/');
% %         chartName = remove_top(name);
% % 
% %         %get machine id of model
% %         machineId = sf_get(name,'MachineId');
% % 
% %         %get list of charts in the model
% %         chartHandles = sf('get',machineId,'.charts');
% % 
% %         %if chart exist, then check each chart to see if the names match
% %         %Save the name match and exit.
% %         if isempty(chartHandles) == 0
% %           for i=1:length(chartHandles)
% %             if strcmp(chartName,sf('get',chartHandles(i),'.name')) == 1
% %                value = chartHandles(i);
% %                return;  %operation complete, return
% %             end
% %           end
% %         end
    case 'charthghandle' %get the handle graphics handle of the chart.
        ChartHandle = sf_get(name,'ChartHandle'); %sf_get_chart_handle(name);
        value = sf('get',ChartHandle,'.hg.figure');

    case 'chartlist'   %get list of charts and handles.
        machineId = sf_get(name,'MachineId');
        chartHandles = sf('get',machineId,'.charts');
        if isempty(chartHandles) == 0
           for i=1:length(chartHandles)
             value(i).name = sf('get',chartHandles(i),'.name');
             value(i).handle = chartHandles(i);
          end
       end
           case 'chartlistlinked'   %get list of charts and handles.
        machineId = sf_get(name,'MachineId');
        chartHandles = sf('get',machineId,'.linkCharts');
        if isempty(chartHandles) == 0
           for i=1:length(chartHandles)
             value(i).name = sf('get',chartHandles(i),'.name');
             value(i).handle = chartHandles(i);
          end
       end
    case 'machineid'  %get the machine id
        [name,r]=strtok(name,'/');
        machineId = sf('get','all','machine.id');
        if isempty(machineId) == 0
           for i=1:length(machineId)
              mName=sf('get',machineId(i),'.name');
              if (strcmp(name,mName) == 1)
                 value = machineId(i);
                 break
              end
           end
       end
   case 'statelist' %get a list of all states for the entire machine
                    %the list is flat

       %get the machine id and chart handles for the entire machine
       machineId = sf_get(name,'machineId');
       chartHandles = sf('get',machineId,'.charts');
       k=1;
       % process each chart handle and pull the list of states and save
       for i=1:length(chartHandles)
            listh = sf('get',chartHandles(i),'.states');
            for j=1:length(listh)
               value(k).name = sf('get',listh(j),'.name');
               value(k).handle = listh(j);
               k=k+1;
           end
       end
   case 'version'  %get stateflow version number
       machineId = sf('find', 'all', 'machine.simulinkModel', 0);
       value = sf('get',machineId,'.sfVersion');
    otherwise,
    end
catch
    value = [];
end

function newName = remove_top(name)
[t,r] = strtok(name,'/');
newName = r(2:end);
