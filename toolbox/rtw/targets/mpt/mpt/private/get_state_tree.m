function tree = get_state_tree(chartHandle)
%GET_STATE_TREE will extract all states associated with a given chart.
%
%   [TREE]=GET_STATE_TREE(CHARTHANDLE)
%   This functin takes in the chart handle and returns a tree of the states
%   with their hierarchy preserved.  Each level of substates are processed 
%   until completed. Subcharts and substates are handled the same.
%
%   INPUTS:
%        chartHandle:   Handle of chart to process
%
%   OUTPUTS:
%        tree:          tree structure that contains all state names with hierarchy preserved.

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.11.4.1 $
%   $Date: 2004/04/15 00:28:10 $

% This function uses a recursive call.

% get the initial child states.
child = sf('get',chartHandle,'.treeNode.child');

% go deeper into each child state
tree = recursive_get_state_tree(child);

function tree = recursive_get_state_tree(stateHandle)
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
%tree{..}.state_name
%tree{..}.stateHandle
%tree{..}.substates{..}
sh = stateHandle;
index = 1;
tree = [];

%loop until all states at this level has been processed
while sh > 0

    % get & save the state name and handle.

    tree{index}.stateName = sf('get',sh,'.name');
    tree{index}.stateHandle = sh;
    stateType = sf('get',sh,'.type');
    tree{index}.functionInlineOption=[];
    tree{index}.stateTypeID = stateType;
                data = cEmpty;
            info.dataH = sf('get',sh,'.firstData');
            tree{index}.data = get_data_detail(data, info);
    switch(stateType)
        case 0
            tree{index}.stateType = 'OrState';

        case 1
            tree{index}.stateType = 'AndState';
        case 2
            tree{index}.stateType = 'Function';
            functionInlineOption =  sf('get',sh,'.functionInlineOption');
            dataHandle = sf('get',sh,'.firstData');
%             tree{index}.input=[];
%              tree{index}.output=[];
%             while dataHandle == 0
%                 scope = sf('get',dataHandle,'.scope');
%                 switch(scope)
%                     case 8   %FUNCTION_INPUT_DATA
%                         element.name = sf('get',dataHandle,'.name');
%                         element.dataType = sf('get',dataHandle,'.dataType');
%                         tree{index}.input{end+1}=element;
%                     case 9
%                         element.name = sf('get',dataHandle,'.name');
%                         element.dataType = sf('get',dataHandle,'.dataType');
%                         tree{index}.output{end+1}=element;
%                     otherwise
%                 end
%                dataHandle = sf('get',dataHandle,'.linkNode.next');
%             end
            switch(functionInlineOption)
                case 0
                    tree{index}.functionInlineOption = 'FUNCTION_INLINE_AUTO';
                case 1
                    tree{index}.functionInlineOption = 'FUNCTION_INLINE_FORCE_YES';
                case 2
                    tree{index}.functionInlineOption = 'FUNCTION_INLINE_FORCE_NO';
                otherwise
                     tree{index}.functionInlineOption=[];
            end
        case 3
            tree{index}.stateType = 'Box';
        otherwise
    end
    % get the next level of children states (if any)
    csh = sf('get',sh,'.treeNode.child');
    if csh > 0
        %  Use recursive call to this function to process children states
        tree{index}.substates=recursive_get_state_tree(csh);
    else
        tree{index}.substates=[];
    end

    % get next state at current level
    sh = sf('get',sh,'.treeNode.next');
    index = index + 1;
end