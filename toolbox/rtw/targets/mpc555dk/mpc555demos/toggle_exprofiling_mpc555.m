function toggle_exprofiling_mpc555(system)
% TOGGLE_EXPROFILING_MPC555 toggles Execution Profiling between CAN and serial
%  TOGGLE_EXPROFILING_MPC555(SYSTEM) will replace an Execution Profiling
%  over CAN block in SYSTEM with an Execution Profiling over Serial block,
%  and vice versa.  It functions only for Execution Profiling blocks from
%  the mpc555drivers library.  The sample time, position and background
%  colour of the block are preserved.

% Copyright 2003-2004 The MathWorks, Inc.

try
    find_system('mpc555drivers','SearchDepth', 0);
catch
    load_system('mpc555drivers');
end

canblockname=sprintf('MPC555 Execution Profiling\nvia CAN A');
canblock=sprintf('%s/%s', system, canblockname);
serialblock=sprintf('%s/MPC555 Execution Profiling\nvia SCI1', system);
canlibraryblock = sprintf('mpc555drivers/Execution Profiling/MPC555 Execution Profiling\nvia CAN A');
seriallibraryblock = sprintf('mpc555drivers/Execution Profiling/MPC555 Execution Profiling\nvia SCI1');
displaystring = 'disp(''Execution Profiling\\nis currently over %s'');';

if isempty(find_system(system, 'Name', canblockname))
    % Convert to CAN
    oldblock = serialblock;
    newblock = canblock;
    source = canlibraryblock;
    maskdisplay = sprintf(displaystring, 'CAN');
else
    % Convert to serial
    oldblock = canblock;
    newblock = serialblock;
    source = seriallibraryblock;
    maskdisplay = sprintf(displaystring, 'Serial');
end

add_block(source, newblock, ...
          't', get_param(oldblock, 't'), ...
          'Position', get_param(oldblock, 'Position'), ...
          'BackgroundColor', get_param(oldblock, 'BackgroundColor'));
delete_block(oldblock);

if strcmp(newblock, serialblock)
  % Set serial bit rate to the default used by profile_mpc555
  localSetSerialBitRate(57600);
end

% Update toggle block
toggleblocks = find_system(system, 'RegExp', 'On', ...
                          'Name', 'Toggle.*Execution.*Profiling');
if ~isempty(toggleblocks)
    % Assume first in list
    set_param(toggleblocks{1}, 'MaskDisplay', maskdisplay);
end


%%%%%%%%%%%%%%%%%%%
% Local Functions %
%%%%%%%%%%%%%%%%%%%

function localSetSerialBitRate(rate)
  target = RTWConfigurationCB('get_target',gcb);
  serial = target.findConfigForClass('MPC555dkConfig.QSMCM');
  serial.SCI1.Bit_rate_ideal = rate;
  
