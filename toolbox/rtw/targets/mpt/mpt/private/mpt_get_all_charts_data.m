function chartData = mpt_get_all_charts_data(modelName)
%MPT_GET_ALL_CHARTS_DATA - extracts all the data used in a chart 
%
%   [CHARTDATA]=MPT_GET_ALL_CHARTS_DATA(MODELNAME)
%   This fucntion takes in a mdoel and extracts all the data from the
%   charts and returns a structuire with that set of data.
%
%   Inputs:
%              modelName : Name of input model
%
%   Outputs:
%              chartData : a structure of data from the chart data sets.
%
%

%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2004/04/15 00:28:36 $
%


global mpmResult;
chartData =[];
cnt = 1;

if exist('mpt_test_model.mdl','file'),
   delete('mpt_test_model.mdl');
end

%
% Rename current system 
%
if isunix,
  system(['cp ',modelName,'.mdl mpt_test_model.mdl']);     
else
  system(['copy ',modelName,'.mdl mpt_test_model.mdl']); 
end

%
% re-open present model
%

%open_system(modelName);

%
% Load the quietly 
%

load_system('mpt_test_model');
try
  sys = find_system('mpt_test_model','MaskType','ModulePackagingTool');
  delete_block(sys);
catch
end

% sfBlocks = find_system('mpt_test_model','BlockType','SubSystem','MaskType','Stateflow');
% for i=1:length(sfBlocks),
%    set_param(sfBlocks{i},'LinkStatus','none');  
% end
break_links('mpt_test_model');
save_system('mpt_test_model');
close_system('mpt_test_model');
load_system('mpt_test_model');


%
% Get the root stateflow API object
%

rt = sfroot;

%
% Find the stateflow machines available. Then get the specific model
% machine of interest.
%
machineSF = rt.find('-isa','Stateflow.Machine');
if length(machineSF) > 1,    
    for i = 1:length(machineSF),
        if strcmp(machineSF(i).Name,'mpt_test_model')==1,
            specificMachine = machineSF(i);  
            break; 
        end
    end
else
    if strcmp(machineSF.Name,'mpt_test_model')==1,
        specificMachine = machineSF;  
    end 
end

%
% Next find the sfunction target id
%

 sfTargets = specificMachine.findDeep('Target');
 for i=1:length(sfTargets),
       if strcmp(sfTargets(i).Name,'sfun')==1,
           sfunTargetId = sfTargets(i).Id;
           sfunTarget = sfTargets(i);
       end
 end
%
% Clear all custom code references so legacy functions will pop out as
% error(s) in the parse of the model and they can be collected up.
%
  
sfunTarget.CustomCode ='';
sfunTarget.UserSource ='';
sfunTarget.UserLibraries ='';
sfunTarget.UserIncludeDirs ='';

%
% Get all the data object handles for that machine.
% And delete all the data from the data dictionary for that machine.
%

data = specificMachine.findDeep('Data');
for j=1:length(data),
        data(j).delete;    
end

%
% Get all the chart objects for a specific machine
%

chart = specificMachine.findDeep('Chart');

%
% Parse the model to extanblish missing data items from the parsed diagrams
%

try
    slsfnagctlr('Exit'); 
    mpmResult.err.MemMode = 0;
    sf('Private','autobuild',specificMachine.Id,'sfun','parse',0,'no',[],[]);
catch
    slsfnagctlr('Clear', modelName, 'RTW Embedded Coder Module Packaging Tool');
    mpmResult.err.MemMode =1;
    lasterr('');
end
clc;

% 
%  Put up progess bar
%

wh = waitbar(0,'Determining Diagram Data Sets');

%
% Loop through all the charts extracting all the data items fro each chart
% establishing the data items used in the diagrams.
%

% 
% [dataSymbolArray,...
%  eventSymbolArray,...
%  functionSymbolArray,...
%  nonRTWdataArray,...
%  nonRTWFunctionArray]= sf('UnresolvedSymbolsIn',machineId,chartId,targetId);
% 

for i=1:length(chart)    
    chartData(cnt).name = strrep(chart(i).Name,' ','_');
    chartData(cnt).fullName = strrep(chart(i).getFullName,' ','_');
    save_system('mpt_test_model');
    chartData(cnt).data = sf('get',chart(i).Id,'.unresolved.data');
    chartData(cnt).events = sf('get', chart(i).Id, '.unresolved.events');
    [chartData(cnt).dataSymbolArray,...
     chartData(cnt).eventSymbolArray,...
     chartData(cnt).functionSymbolArray,...
     chartData(cnt).nonRTWdataArray,...
     chartData(cnt).nonRTWFunctionArray]= sf('UnresolvedSymbolsIn',specificMachine.Id,chart(i).Id,sfunTargetId);
    for ifl=1:length(chartData(cnt).functionSymbolArray)
     chartData(cnt).functionSymbolArray(ifl).labelString = sf('get',chartData(cnt).functionSymbolArray(ifl).contextObjectId,'.labelString');
    end    
    cnt = cnt + 1;
    waitbar(i/length(chart),wh);
end

%
% Close the wait bar indicator
%

close(wh);
%
% Close and delete the hidden model we used to extract the data from
%

close_system('mpt_test_model',0);
delete('mpt_test_model.mdl');

%
% Return chartData back as the results of getting all the data in the
% chart.
%
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%