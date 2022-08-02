function m = what_is_top_sf_components( m)

%   COMPONENT = WHAT_IS_TOP_SF_COMPONENTS(M) determines what major
%   components are at the top of the SF diagram. This will permit the type
%   of function and the necessary support infrastructure to be determined.

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.3.4.1 $  $Date: 2004/04/15 00:29:15 $

%A chart can have the following at the top level
%
%   Flow diagram notation
%   States
%   AND States
%   Graphical Functions

% search for all junctions and transitions that are parented by the chart
% only. If there are some, then it is a flow diagram.

% search for all Or states and record status
% search for all And states and record status
% search for all graphical functions and record status
% it is necessary to recursively traverse the state tree hierarchy.

component.flowDiagram = 0;
component.Orstates = 0;
component.andStates = 0;
component.graphicalFunctions = 0;
topTransitions=[];
topJunctions=[];
for i=1:length(m.chart)
    topTransitions=[];
    topJunctions=[];
    h = m.chart{i}.handle;
    topStates = [];
    cnt = 0;
    h1=[];
    for j = 1:length(m.chart{i}.stateTree)
        if isequal(m.chart{i}.stateTree{j}.stateType,'Box') == 1
            boxh = m.chart{i}.stateTree{j}.stateHandle;
            parent = sf('get',boxh,'.treeNode.parent');
            if parent == h
               cnt = cnt + 1; 
               h1(cnt) = boxh;
            end
        end
    end
    transitions = sf('get',h,'.transitions');
    junctions = sf('get',h,'.junctions');
    for j=1:length(transitions)
        parent = sf('get',transitions(j),'.linkNode.parent');
        if parent == h
            topTransitions{end+1}=transitions(j);
        end
        for k = 1:length(h1)
            if parent == h1(k)
                topTransitions{end+1}=transitions(j);
            end
        end
    end
    for j=1:length(junctions)
        parent = sf('get',junctions(j),'.linkNode.parent');
        if parent == h
            topJunctions{end+1}=junctions(j);
        end
        for k = 1:length(h1)
            if parent == h1(k)
                topJunctions{end+1}=junctions(j);
            end
        end
    end
    states = sf('get', h,'.states'); 
    for j = 1: length(states)
        isNoteBox = sf('get',states(j),'.isNoteBox');
        if isNoteBox == 0         
            stateType = sf('get',states(j),'.type');
            if(stateType == 0)|(stateType == 1)
                parent = sf('get',states(j),'.treeNode.parent');
                if parent == h
                    topStates{end+1}=states(j);
                end
                for k = 1:length(h1)
                    if parent == h1(k)
                        topStates{end+1}=states(j);
                    end
                end
            end        
        end
    end 
    if isempty(topStates) == 1
        m.chart{i}.topState = 0;
    else
        m.chart{i}.topState = 1;
    end   
    if isempty(topTransitions) & isempty(topJunctions)
        m.chart{i}.flowDiagram = 0;
    else
        m.chart{i}.flowDiagram = 1;
    end
    dataList = [];
    funList = [];
    for j=1:length(m.chart{i}.stateTree)
        %             [dataList, funList] = recursive_data_list(state,dataList,funList)
        [dataList, funList] = recursive_data_list(m.chart{i}.stateTree{j},dataList, funList);
    end
    m.chart{i}.funList = funList;
    for q=1:length(funList)
        
        m.chart{i}.graphicalFunction{q}=funList{q}.stateName;
        m.chart{i}.graphicalFunctionHandle{q}=funList{q}.stateHandle;
    end
end