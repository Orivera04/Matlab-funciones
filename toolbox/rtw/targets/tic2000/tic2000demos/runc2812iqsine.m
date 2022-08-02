function runc2812iqsine(action)
%   runc2812iqsine gets invoked from c2812iqsine.mdl
%   to run demo on hardware.
%
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/01 16:14:46 $
try
    % Steps not needed in Simulation mode.
    if ~strcmpi(action,'Simulation')
        modelName = gcs;
        [boardNum, procNum] = getBoardProc(modelName);
        
        % If no matches exist, error out
        if isempty(boardNum)
            errordlg(sprintf(['Could not find desired board.  Select the appropriate board in Code Composer '...
                    'Studio Setup and make sure that the "DSPBoardLabel" field in the model''s target preference '...
                    'block matches the name of the selected board.']));
            return;
        end
        % create CCSDSP object (call constructor)
        disp('### Connecting to Code Composer Studio ...');
        CCS_Obj = ccsdsp('boardnum',boardNum,'procnum',procNum);
        CCS_Obj.visible(1);
        % construct full path name of demo
        fullModelName = fullfile('.', [modelName '_c2000_rtw'], modelName);
    end
    switch(action)
        case 'Reload_Run'
            if exist([fullModelName '.out']),
                % save warning present state, and turn off warning
                saveState = warning;
                warning off
                % 'callSwitchyard' is called directly to close previous version of 
                %     project found in ANY board
                projectName = [fullModelName '.pjt'];
                try
                    callSwitchyard(CCS_Obj.ccsversion,[45,boardNum,procNum,0,0], projectName);
                catch
                    % projectName is not open in any board
                end
                try
                    % reload previously generated project
                    CCS_Obj.open(projectName,'project');
                catch
                    % don't error if project does not exist
                end
                % restore warning state
                warning(saveState);
            else
                errordlg({'Could not find COFF file for model. You need to build the model first.'},...
                    'Load Error');
                return;
            end
        case 'Build_Run'
            load_system(modelName); 
            make_rtw
        case 'Simulation'
            hfig = figure;
            pos = get(hfig,'position');
            set(hfig,'position', [pos(1) pos(2) 358 429]);
            
            subplot(3,1,1);
            evalin('base','plot(yout1.signals.values(1:200));')
            title('Sine wave approximation with different IQ formats');
            ylabel('Magnitude')
            xlabel('Time')
            legend('I32 Q4');
            
            subplot(3,1,2);
            evalin('base','plot(yout2.signals.values(1:200));')
            ylabel('Magnitude')
            xlabel('Time')
            legend('I32 Q5');
            
            subplot(3,1,3);
            evalin('base','plot(yout3.signals.values(1:200));')
            ylabel('Magnitude')
            xlabel('Time')
            legend('I32 Q15');
            return;
        otherwise
            error('Invalid option.');
    end
    
    % Change directory to target demo directory 
    CCS_Obj.cd(fullfile(pwd,[modelName '_c2000_rtw']));
    outFile = [modelName '.out'];    
    % Open target file
    if exist([fullModelName '.out'])
        fprintf('### Loading COFF file to target DSP...\n');
        try
            CCS_Obj.reset;
            pause(1.0);
            CCS_Obj.load(outFile,100)
        catch
            clear CCS_Obj;
            errordlg({'There is a problem loading the COFF file for the selected processor.';...
                    'You may need to reset your hardware and rebuild project.'},...
                'Load Error' );
            return
        end
    else
        errordlg({'You need to build the project before running.'}, 'Load Error' , 'modal');    
        return
    end
    
    % Running target, reading and plotting data
    disp('### Running target to process data...')
    run(CCS_Obj);
    pause(2)
    disp('### Reading and plotting Data...')
    
    y1_data = read(CCS_Obj, [hex2dec('8000')], 'single', 200 );
    y2_data = read(CCS_Obj, [hex2dec('8320')], 'single', 200 );
    y3_data = read(CCS_Obj, [hex2dec('8640')], 'single', 200 );
    halt(CCS_Obj);
    
    f = figure;
    plot(y1_data);
    hold on;
    plot(y2_data,'r');
    plot(y3_data,'g');
    hold off;
    title('Sine wave approximation with different IQ formats');
    ylabel('Magnitude')
    xlabel('Time')
    legend('I32 Q4', 'I32 Q5', 'I32 Q15',0)
    disp('### Demo Complete.')
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

