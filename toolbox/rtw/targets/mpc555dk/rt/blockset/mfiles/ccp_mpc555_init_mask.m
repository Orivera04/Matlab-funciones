function ccp_mpc555_init_mask(action, block, varargin)
% CCP_MPC555_INIT_MASK Configuration for the CCP Block
%
% ccp_mpc555_init_mask(action, block)
%
% ccp_mpc555_init_mask('init', block) uses the SF API to uncheck the 'Use
% Settings for all Libraries' check boxes if appropriate (ie. if using SF
% 4.2 or higher).
%
% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.1.4.2 $
% $Date: 2004/04/19 01:29:37 $

switch action
    case 'setup_library_ccp_block'
        % setup the actual ccp block in the mpc555extras.mdl library
        internal_setup_library_ccp_block(block);
    case 'show_commands_mask_callback'
        show_commands=get_param(block,'show_commands');
        var_names = {'PROGRAM_PREPAREenabled' 'DNLOADenabled' ...
                'UPLOADenabled' 'SHORT_UPenabled' 'DNLOAD_6enabled'};
        switch show_commands
            case 'on'
                internal_show_commands(block, var_names);
            case 'off'
                internal_hide_commands(block, var_names);
        end;
    case 'check_prog_prep_bit_timing'
        target = varargin{1};
        toucan = target.findConfigForClass('MPC555dkConfig.TOUCAN');
        bitrate = toucan.CAN_A.Timing.CAN_Bit_Rate;
        nq = toucan.CAN_A.Timing.Number_Of_Quanta;
        sam = toucan.CAN_A.Timing.Sample_Point;
        % bootcode system frequency is always expected
        % to be 20MHz!
        bootfreq = 20e6;
        
        try
            can_bit_timing(bootfreq, bitrate, nq, sam);
        catch
            title = 'CCP Program Prepare Download';
            newline = sprintf('\n');
            estring = ['CCP Program Prepare downloads will not work in this configuration.' newline newline...
                       'This is because the desired Program Prepare CAN bit timing settings cannot '...
                       'be achieved by the MPC555 bootcode.' newline newline...
                       'To fix this, please choose bit timing settings that the bootcode can achieve.' newline newline ...
                       'You may wish to use the utility ''can_bit_timing'', setting the bootcode system frequency as 20MHz, to '...
                       'determine achievable bit timing settings.'];
            warndlg(estring, title);
        end;  
    otherwise
    disp('Unknown action');
end;

function internal_setup_library_ccp_block(block)
    % set the copy function of the actual CCP block to display the 
    % Target Options Configuration figure which has callbacks set on the
    % Yes, No, and close Buttons
    
    % Assume standard CCP block will call this dialogue!
    
    %cpStr = ['openfig(''ccp_questdlg.fig'');'...
    %        'set_param(gcbh,''CopyFcn'','''');'];
    
    cpStr = ''; 
    
    set_param(block,'CopyFcn',cpStr);    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function internal_show_commands(block, var_names)
    for (i=1:length(var_names)) 
        simUtil_maskParam('show',block,var_names{i});
    end;
    
function internal_hide_commands(block, var_names)
    for (i=1:length(var_names))
        simUtil_maskParam('hide',block,var_names{i});
    end;