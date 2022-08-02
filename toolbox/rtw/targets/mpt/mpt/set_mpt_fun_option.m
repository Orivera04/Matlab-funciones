function set_mpt_fun_option(handle,funOption)
%SET_MPT_FUN_OPTION will set Stateflow specified function options.
%
% SET_MPT_FUN_OPTION(HANDLE, FUNOPTION) will set options configured for
% a specific Stateflow graphical function or chart.
%
%   INPUT:
%         handle:        Handle or ID of Stateflow Chart or Graphical
%                        Function
%         funOption:     Options to associated with Stateflow chart or
%                        graphical function
%   OUPPUT:
%         none

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.4.3 $
%   $Date: 2004/04/15 00:29:06 $

if isempty(handle) == 0
    
    sf('set',handle,'.tag',funOption);
    isa = sf('get',handle,'.isa');
    if isa == 1
        machineHandle = sf('get',handle,'.machine');
    else
        parentH = sf('get',handle,'.treeNode.parent');
        machineHandle = sf('get',parentH,'.machine');
    end
    modelName = sf('get',machineHandle,'.name');
    
    %Add a switch for user to ask for writing info to library or not 
    if sf('get',machineHandle,'.isLibrary') == 1
        
        answer = questdlg(['Do you want to write information into locked library: ',modelName,' ?'], ...
            'MPT Function Manager Question','Yes','No','No');
        switch answer,
            case 'Yes', 
                set_param(modelName,'Lock','off');
                set_param(modelName,'dirty','on');
                sfsave(modelName);
                set_param(modelName,'Lock','on');
            case 'No',
                disp('*** Warning: The configuration you made is not saved');
                disp(['             on locked library: ',modelName, '. ***']);
        end % switch
    else
        set_param(modelName,'dirty','on');
        sfsave(modelName);
    end
end
