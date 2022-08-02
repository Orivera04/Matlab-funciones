function ec_mpt_listener_cb(blockDiagramObj,listenerObj)
%EC_MPT_LISTENER_CB provides a callback handler for
% EnginePostRTWCompFileNames.
%
% EC_MPT_LISTENER_CB(BLOCKDIAGRAMOBJ,LISTENEROBJ) will handle the 
% EnginePostRTWCompFileNames listener event. It will determine the proper
% data placement and return the information via the DataObjectUsage
% attribute.
%
% INPUT:  blockDiagramObj..Root block diagram object.
%         listenerObj......Listener object that contains event info.

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $
%   $Date: 2004/04/15 00:26:48 $


dataObjectUsage=[];

if ec_mpt_enabled(blockDiagramObj.getFullName)
    ec_debug = 0;
    try
        if strcmp(listenerObj.Type, 'EnginePostRTWCompFileNames') == 1
            %Check if in normal mode. Acceleration and External mode not supported.
            simulationMode = get_param(blockDiagramObj.getFullName,'SimulationMode');
            %             if strcmp(simulationMode,'normal') == 1
            %                 %Check if it is an ERT or ERT derived target
            %                 h=getActiveConfigSet(blockDiagramObj.getFullName);
            %                 if strcmp(get_param(h,'IsERTTarget'),'on')
            % check if the the model is a model reference target or sub
            % model
            %                     modelReferenceTargetType = get_param(blockDiagramObj.getFullName, 'ModelReferenceTargetType');
            %                     if strcmp(modelReferenceTargetType,'NONE') == 1
            %check if the model contains any model reference
            %components
            %                     mList = find_system(blockDiagramObj.getFullName,'FollowLinks','on','LookUnderMasks','all','blocktype','ModelReference');
            %                     if isempty(mList) == 1
            %Get data data object usage information
            dataObjectUsage = get_param(blockDiagramObj.getFullName, 'DataObjectsUsage');
            if ec_debug == 1
                buf = ec_data_user_dump(dataObjectUsage);
                disp(buf);
            end
            dataObjectUsage = ec_data_placement(dataObjectUsage,blockDiagramObj.getFullName);
            set_param(blockDiagramObj.getFullName, 'DataObjectsUsage',  dataObjectUsage);
            %                     end
            %                     end
        end
        %                 end
        %             end
        %         end
    catch
        disp('Error is ec_mpt_listener_cb');%errorFlag = 1;
    end
end
rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB',dataObjectUsage);
