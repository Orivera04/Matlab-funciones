function [dataList, funList] = recursive_data_list(state,dataList,funList)
%RECURSIVE_DATA_LIST retrieves all data components for states and sf fun.
%
%   [DATALIST, FUNLIST] = RECURSIVE_DATA_LIST(STATE, DATALIST, FUNLIST)
%        is used to recursively traverse the substate structure in the 
%        get_sf_data structure. The functions and state information is
%        separated out. Functions can be at any level.
%         
%   INPUT:
%        state:  State/Function/Box structure
%        dataList: Current data list cell array. May contain information
%        from prior passes.
%        funList   : Current graphical function data list cell array. May
%        contain information from prior passes.
%         
%   OUTPUT:
%        dataList: All data objects parented by a particular state.
%        funList:  All data objects parented by a particular graphical
%        function.

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $  
%   $Date: 2002/04/22 04:05:09 $

% separate the graphical function from the normal state data
if strcmp(state.stateType, 'Function') == 0
    dataList{end+1}=state.data;
else
    funList{end+1}=state;
end

%for each substate, use recursion to continue the extraction
for i=1:length(state.substates)
    [dataList, funList] = recursive_data_list(state.substates{i},dataList,funList);
end