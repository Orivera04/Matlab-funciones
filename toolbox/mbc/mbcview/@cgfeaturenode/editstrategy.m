function [featnode, sys] = editstrategy( featnode )
%EDITSTRATEGY A short description of the function
%
%  FEATNODE = EDITSTRATEGY( FEATNODE )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 08:22:44 $ 

sfPtr = getdata( featnode );

global WRITEC testVal EXPRT
EXPRT = 0;
WRITEC = 1;
curdir = pwd;
% Create a SL window

% sl window margin information
[slPos, calLibWidth] = pcalcSLPosition;

sfName=strrep(sfPtr.getname,' ','_');
opensys=find_system('type','block_diagram');
if ismember(lower(sfName),lower(opensys))
    try
        close_system(sfName,0);
    end
end

% show all libraries
pToggleLibs(1, featnode );
load_system('cgeqlibprivate');
set_param('cgeqlibprivate','lock','off');
sys=strrep(sfPtr.getname,' ','_');
opensys=find_system('type','block_diagram');
if ismember(sys,opensys)
    close_system(sys,0);
end
new_system(sys);
cgexpr2sl(sfPtr,1,sys,0);%Options.StrategyType
set_param(sys,'creator','CAGE');
% Add a time and input vector to the workspace to allow evaluation
if WRITEC
    assignin('base','t',0);
    assignin('base','u',testVal);
end
set_param(sfName,'modelbrowservisibility','off',...
    'toolbar','off',...
    'statusbar','off',...
    'location',slPos,...
    'BlockDescriptionStringDataTip','on',...
    'BlockParametersDataTip','off');
clear global calLibWidth slPos
set_param(sfName, 'CloseFcn', 'Callbacks(cgfeaturenode,''i_SLClose'',[],[]);');

%resize and show new system and library

outports=find_system(sfName,'findall','on','searchdepth',1,'LookUnderMasks','all','followlinks','on',...
    'Blocktype','Outport');
openfcn='Callbacks(cgfeaturenode,''i_SLUpdate'',[],[]);';
for i=1:length(outports)
    set_param(outports(i),'openfcn',openfcn,'backgroundcolor','blue');
end
open_system(sfName);
sys=get_param(sfName,'handle');
cd(curdir);
clear testVal EXPRT


