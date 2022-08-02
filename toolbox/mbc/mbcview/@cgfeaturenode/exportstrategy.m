function featnode = exportstrategy( featnode, fileName, StrategyType )
%EXPORTSTRATEGY Exports the feature strategy to a simulink file
%
%  FEATNODE = EXPORTSTRATEGY( FEATNODE, <FILENAME> )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:22:45 $ 

global testVal EXPRT WRITEC
sfPtr = getdata( featnode );
EXPRT = 1;
curPath = pwd;

sfName=strrep(sfPtr.getname,' ','_');
if nargin > 1
    % programmatic export so don't show messages etc
    messages = 1;
    if nargin < 3
        StrategyType = 1;
    end
    [PATH, sys] = fileparts( fileName );
    if isempty( PATH )
        PATH = pwd;
    end
else
    messages = 1;
    StrategyType = 1;
    % find a place to put the model
    [fileName,newPath] = uiputfile([sfName,'.mdl'],'File Name & Location for the exported model');
    if isnumeric( fileName )
        return
    end
    [PATH, sys] = fileparts( fullfile( newPath, fileName ) );
end


opensys=find_system('type','block_diagram');
if ismember(lower(sys),lower(opensys))
    close_system(sys,0);
end

% Create sl diagram from feature
try
    new_system(sys);
catch
    % It's possible that sys is not a valid name - if this is the case
    % new_system will error. As they not throw an eror ID here we have to
    % pick up the actaul error message.
    if findstr(lasterr, 'invalid model name specification')
        msg = sprintf( '"%s" is an invalid SIMULINK model name.  Please try again.', sys );
    else
        msg = lasterr;
    end
    errordlg( msg , 'MBC Toolbox', 'modal') ;
    return;
end


load_system('cgeqlib');
set_param('cgeqlib','lock','off');
if StrategyType==2;
    load_system('FordEEC');
    set_param('FordEEC','lock','off');
    global EXPORTPARFILE
    EXPORTPARFILE = [sys,'PARAM'];
    t = 0;
    save(EXPORTPARFILE,'t');
end

% override setting of Write Calibration to Simulink Diagram
tempWriteC = WRITEC;
WRITEC = 1;
wrn=warning;
warning off;
% build the simulink model
cgexpr2sl(sfPtr,StrategyType,[sys,'/',sfName],1);
warning(wrn);
WRITEC = tempWriteC;

if messages
    % Create a SL window the same size and position as the display frame
    % Work out sl diagram positions
    set_param(sys,'modelbrowservisibility','on',...
        'toolbar','on',...
        'statusbar','on',...
        'BlockParametersDataTip','off',...
        'creator',['Automatically created by CAGE ',mbcver]);
    blocks = find_system(sys,'type','block');
    for i=1:length(blocks)
        set_param(blocks{i},'copyfcn','');
    end
    %resize and show new system and library
    % same size and position as the display frame
    spos=get(0,'screensize');
    browserWidth = 160;
    left=browserWidth+60;
    right=spos(3)-7;
    if right > 1000
        right=1000;
    end
    bottom=spos(4)-50;
    top=spos(4)-350;
    slpos=[left top right bottom];
    set_param(sys,'location',slpos);
    open_system(sys);
    
    if StrategyType == 2
        set_param(sys,'preloadfcn',['load(''',EXPORTPARFILE,'.mat'');']);
        clear EXPORTPARFILE
    end
end

set_param(sys,'stoptime','0');
cd(PATH)
save_system(sys);
cd(curPath);

clear testVal EXPRT
