function target_state = beforetlcHookpoint_tic2000target (target_state, modelInfo)

% $RCSfile: beforetlcHookpoint_tic2000target.m,v $
% $Revision: 1.1.6.2 $ $Date: 2004/04/08 21:07:41 $
%% Copyright 2003-2004 The MathWorks, Inc.

% obtain handle to the target preference object associated with the model
[h, errmsg] = getTargetPreferences_tic2000;
error (errmsg);

% check basic properties of the object 
consistencyCheck (h);

h.getCCSLink.deleteProjectFiles (modelInfo);

% force generate code only (to skip execution of makefile generated by rtw)
set_param (modelInfo.name, 'RTWGenerateCodeOnly', 'on');

% unless 'Generate_code_only' is selected, validate DSP board and create connection to CCS
if ~isequal (h.getBuildOptions.getRunTimeOptions.getBuildAction, 'Generate_code_only'),  
    % check for proper target board installation
    boardLabel = h.getDSPBoard.getDSPBoardLabel;
      
    % ByPass Board Check for internal QE testing
    if exist('qeBypassBoardCheck','file') && qeBypassBoardCheck,
        % This is for QE operation mode only        
        % Note that s does not have all fields that it would have 
        % had if "else" part were executed. 
        % Missing: ccsbi: [1x1 struct], boardName
        s.ccsInstalled = 1;
        s.nboards = 1;
        s.success = 1;
        s.boardIndex = 1;
        s.boardNum = 0;
        s.procNum = 0;
        s.errmsg = '';
    else
        % This is for normal operation mode
        s = h.getCCSLink.validateDSPBoard (modelInfo, boardLabel);         
    end
     
    error(s.errmsg);
    % construct CCS object and store board IDs into reset blocks
    target_state = h.getCCSLink.connectToCCS (target_state, modelInfo, s);
    % text files MUST be closed before 'beforemakeHookpoint' or else newly generated files
    % may cause CCS modal message to include new versions of opened files to old CCS project
    target_state.ccsObj.close ('all', 'text');
end

h.validateModel_tic2000target (modelInfo);

% [EOF] beforetlcHookpoint_DSPtarget.m


