function toggle_exprofiling_c166(system)
% TOGGLE_EXPROFILING_C166 toggles Execution Profiling between CAN and serial
%  TOGGLE_EXPROFILING_C166(SYSTEM) will replace an Execution Profiling over
%  CAN block in SYSTEM with an Execution Profiling over Serial block, and
%  vice versa.  It functions only for Execution Profiling blocks from the
%  c166drivers library.  The sample time, position and background colour
%  of the block are preserved.

% Copyright 2003-2004 The MathWorks, Inc.

load_system('c166drivers');
prefs = RTW.TargetPrefs.load('c166.prefs');
cputype = localGetCPUType(prefs.MakeVariablesReferenceFile);
if strcmp(cputype,'0x1662')
  cantype = 'TwinCAN';
else
  cantype = 'CAN';
end


canblockname=sprintf(['C166 Execution Profiling\nvia ' cantype ' A']);
canblock=sprintf('%s/%s', system, canblockname);
serialblockname=sprintf(['C166 Execution Profiling\nvia ASC0']);
serialblock=sprintf('%s/%s', system,serialblockname);
canlibraryblock = sprintf(['c166drivers/Execution Profiling/C166 Execution Profiling\nvia ' cantype ' A']);
seriallibraryblock = sprintf('c166drivers/Execution Profiling/C166 Execution Profiling\nvia ASC0');

if isempty(find_system(system, 'Name', serialblockname))
    % Convert to serial
    oldblock = canblock;
    newblock = serialblock;
    source = seriallibraryblock;
else
    % Convert to CAN
    oldblock = serialblock;
    newblock = canblock;
    source = canlibraryblock;
end

add_block(source, newblock, ...
          't', get_param(oldblock, 't'), ...
          'Position', get_param(oldblock, 'Position'), ...
          'BackgroundColor', get_param(oldblock, 'BackgroundColor'));
delete_block(oldblock);

if strcmp(newblock, serialblock)
  % Set serial bit rate to the default used by profile_c166
  localSetSerialBitRate(57600);
end


%%%%%%%%%%%%%%%%%%%
% Local Functions %
%%%%%%%%%%%%%%%%%%%

function localSetSerialBitRate(rate)
  target = RTWConfigurationCB('get_target',gcb);
  serial = target.findConfigForClass('c166Config.ASC_SERIAL');
  serial.Bit_rate_ideal = rate;
  

function cputype = localGetCPUType(inputFile)

  inputFile = strrep(inputFile,'$(MATLAB_ROOT)',matlabroot);
  inputDir = fileparts(inputFile);
  
  fid=fopen(inputFile,'r');
  if fid==-1
    error(['The file ' inputFile ' cannot be opened. This error occurs '...
           'if a the reference makefile specified does not exist. ']);
  end
  bufIn=fread(fid,Inf);
  bufIn=char(bufIn');
  fclose(fid);
  
  
  % Extract the CPUTYPE
  re = '-DCPUTYPE=([^\s])*[\s]';
  [s,f,t] = regexp(bufIn,re);
  if size(t)~= 1 | length(t{1}) ~= 2
    error(['CPUTYPE is not specified inside ' inputFile '. ' ...
           'This error occurred because the string ''-DCPUTYPE=cpunumber'' could not '...
           'be found inside the OPT_CC variable. To fix this problem, you must make '...
           'sure that the reference make variables file contains a make variable '...
           'OPT_CC that specifies e.g. -DCPUTYPE=0x167.']);
  else
    t = t{1};
    cputype = bufIn(t(1):t(2));
  end
  