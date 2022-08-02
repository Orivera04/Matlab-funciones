function chartsInfo = get_charts_info(modelName)
%GET_CHARTS_INFO extracts all states/functions/notes information in each chart
%
%  CHARTINFO = GET_CHARTS_INFO(MODELNAME)
%         This function takes in the mdoel name and returns the information
%         available about each chart within the model. This includes all the state, 
%         graphical function and note items. 
%
%  INPUT: 
%         modelName: name of the model
%
%  OUTPUT:
%         chartsInfo: chart information structure of all the states/functions/notes
%
%  Note: In order to get the information in linked charts, you need to break links 
%            before using this function.   One way to break links, for example,
%
%   sfblocks = find_system(modelName,'BlockType','SubSystem','MaskType','Stateflow');
%   for i = 1: length(sfblocks)
%       set_param(sfblocks{i},'LinkStatus','none');   %break links
%   end
% 

%  Linghui Zhang
%  Copyright 2002 The MathWorks, Inc.
%  $Revision: 1.1 $
%  $Date: 2002/06/20 20:34:23 $

machine = get_sf_data(modelName);
for i=1: length(machine.chart)
    %get chart's name and handle
    chartsInfo{i}.chartName = machine.chart{i}.name;
    chartsInfo{i}.chartHandle = machine.chart{i}.handle;
    ch = chartsInfo{i}.chartHandle;
   
    %get notes, states and functions' names, labelStrings and handles
    indexS = 0;
    indexF = 0;
    indexN = 0;
    chartsInfo{i}.notes = '';
    chartsInfo{i}.states = '';
    chartsInfo{i}.functions = '';
    chartsInfo{i}.transitions = '';
    stateH = sf('get', ch,'.states'); 
    for j = 1: length(stateH)
        isNoteBox = sf('get',stateH(j),'.isNoteBox');
        if isNoteBox == 1         
             indexN = indexN + 1;
             chartsInfo{i}.notes{indexN}.name = sf('get',stateH(j),'.name');
             chartsInfo{i}.notes{indexN}.handle =stateH(j);
             chartsInfo{i}.notes{indexN}.text = sf('get',stateH(j),'.labelString');
        else
             stateType = sf('get',stateH(j),'.type');
             switch(stateType)
                 case {0,1}
                     indexS = indexS + 1; 
                     chartsInfo{i}.states{indexS}.name = sf('get',stateH(j),'.name');
                     chartsInfo{i}.states{indexS}.handle =stateH(j);
                     chartsInfo{i}.states{indexS}.labelString = sf('get',stateH(j),'.labelString');                  
                 case 2
                     indexF = indexF + 1; 
                     chartsInfo{i}.functions{indexF}.name = sf('get',stateH(j),'.name');
                     chartsInfo{i}.functions{indexF}.handle =stateH(j);
                     chartsInfo{i}.functions{indexF}.labelString = sf('get',stateH(j),'.labelString');                      
                 otherwise
             end        
         end
     end

    %get transitions' names, labelStrings and handles
    tranH = sf('get', ch,'.transitions'); 
    for j =1: length(tranH)
        chartsInfo{i}.transitions{j}.labelString = sf('get',tranH(j),'.labelString');
        chartsInfo{i}.transitions{j}.handle = tranH(j);
    end
end
return;


             