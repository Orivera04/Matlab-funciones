% File : mpc555_bdm_bootcode_download
%
% Abstract :
%   Install the bootcode on the target processor
%

%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.2.6.2 $
%  $Date: 2004/04/19 01:26:49 $ 
function mpc555_bdm_bootcode_download
    elf = fullfile(mpc555dkroot,'drivers','src','applications','bootcode','auto_flash.elf');
    autoflashmain = fullfile(mpc555dkroot,'drivers','make_plugins','auto_flash','main.c');
    
    disp('#################################################################');
    disp('Embedded Target For Motorola MPC555: Bootcode Installation.');
    disp(' ');
    disp('This command will program the lower 32k of the MPC555 internal');
    disp('flash with bootcode. This is required for all development');
    disp('boards to be used with the Embedded Target for Motorola MPC555.');
    disp(' ');
    disp('Ensure your debug probe is connected to your development board''s BDM');
    disp('port and that you have correctly configured your Target Preferences for');
    disp('your chosen compiler and debugger.');
    disp(' ');
    disp('Please close the debugger when it stops at the "exit" breakpoint.');
    disp('#################################################################');
    yn = input('Do you wish to continue with the bootcode installation? (Y/N)','s');
    disp(' ');
    disp(' ');
    if ~isempty(regexp(yn,'^[Yy]'))
        [line,lineNo]  = findline(autoflashmain,'FLASH FAILED.*FLASH FAILED');
        tgtaction('run','exe',elf,0,{'main.c',lineNo});
    end

    % Find the first line and line number in <file>
    % which matches <pattern>
function [line, lineNo] = findline(file,pattern)
    if ~exist(file)
        error([ 'cannot find file:' file]);
    end
    fH = fopen(file);
    lineNo = 0;
    found = 0;
    while 1
        line = fgetl(fH);
        if ~ischar(line)
            break
        end
        lineNo = lineNo + 1;
        if ~isempty(regexp(line,pattern))
            found = 1;
            break;
        end
    end
    fclose(fH);

    if found == 0;
        line = [];
        lineNo = -1;
    end




%   $Revision: 1.2.6.2 $  $Date: 2004/04/19 01:26:49 $
