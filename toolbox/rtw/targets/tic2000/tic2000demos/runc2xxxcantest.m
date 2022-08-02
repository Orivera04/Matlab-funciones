function runc2xxxcantest
%   runc2xxxcantest gets invoked from c2xxxcantest.mdl
%   to run demo on hardware.
%
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/08 21:00:24 $

try
    modelName = gcs;
    [boardNum, procNum] = getBoardProc(modelName);
    if isempty(boardNum)
        errordlg(sprintf(['Could not find desired board.  Select the appropriate board in Code Composer '...
                'Studio Setup and make sure that the "DSPBoardLabel" field in the model''s target preference '...
                'block matches the name of the selected board.']));
        return;
    end

    disp('### Connecting to Code Composer Studio ...');
    CCS_Obj = ccsdsp('boardnum',boardNum,'procnum',procNum); % create CCSDSP object
    CCS_Obj.visible(1);

    fullModelName = fullfile('.', [modelName '_c2000_rtw'], modelName); % full pathname

    if exist([fullModelName '.out']), % if .out file exists, simply reload and run
        saveState = warning;
        warning off
        projectName = [fullModelName '.pjt'];
        warning(saveState);
    else
        load_system(modelName); 
        make_rtw
    end
   
    % Change directory to target demo directory 
    CCS_Obj.cd(fullfile(pwd,[modelName '_c2000_rtw']));
    outFile = [modelName '.out'];    
    % Open target file
    if exist([fullModelName '.out'])
        fprintf('### Loading COFF file to target DSP...\n');
        try
            tgtblock = find_system(modelName,'masktype','c2000 Target Preferences');
            tgtuserdata = get_param(tgtblock,'userdata'); 
            ChipLabel = tgtuserdata{:}.tic2000TgtPrefs.DSPBoard.DSPCHip.DSPChipLabel;
            write(CCS_Obj,[hex2dec('8FF0') 1], uint16(8000)); % make sure it's < 16000
            CCS_Obj.reset;
            if (strcmp (lower(ChipLabel),'ti tms320c2812'))
                CCS_Obj.load(outFile,100);
                CCS_Obj.run;
            elseif (strcmp (lower(ChipLabel),'ti tms320c2407'))  
                CCS_Obj.load(outFile,100);
                CCS_Obj.reset;
                CCS_Obj.run;                 
            end          
        catch
            clear CCS_Obj;
            errordlg({'There is a problem loading the COFF file for the selected processor.';...
                    'You may need to reset your hardware and rebuild project.'}, 'Load Error' );
            return
        end
        try
            c2xxxcantest;
        catch
            errordlg('There is a problem opening the Duty Cycle Control GUI', 'Load Error' );
            return
        end        
    else
        errordlg({'You need to build the project before running.'}, 'Load Error' , 'modal');    
        return
    end
catch
    errordlg(lasterr);
end    

%--------------------------------------------------------------------------
function [boardNum, procNum] = getBoardProc(modelName)
% Search for board label matches in CCS setup
boardNum = [];
procNum = [];
tgtblock = find_system(modelName,'masktype','c2000 Target Preferences');
tgtuserdata = get_param(tgtblock,'userdata'); 
BoardLabel = tgtuserdata{:}.tic2000TgtPrefs.DSPBoard.DSPBoardLabel;
s = ccsboardinfo;
for m = 1:length(s)
    if strcmpi(s(m).name, BoardLabel)
        boardNum = s(m).number;
        procNum =  s(m).proc.number;
        break;
    end
end