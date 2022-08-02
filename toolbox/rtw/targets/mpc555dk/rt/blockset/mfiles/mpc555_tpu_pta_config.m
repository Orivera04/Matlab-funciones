function [varargout] = mpc555_tpu_pta_config(action, block, varargin)
% MPC555_TPU_PTA_CONFIG implements mask callbacks and initialisation
% for MPC555 TPU PTA block
%
% action - see switch case below
%
% block - handle to the block

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/19 01:29:59 $

switch lower(action)
case 'max_count_callback'
   i_max_count_callback(block);
case 'model_initialisation'
   % note: no set_params are allowed in block initialisation callback
   i_model_initialisation(block, varargin{1});
otherwise
   error(['Action ' action ' not found!']);
end;

function i_model_initialisation(block, maxCount)
    % check the maxCount entry
    if (maxCount ~= uint8(maxCount))
        % failure
        i_invalidMaxCount;  
    end;
    % do not run code that depends on a resource config object
    % when called from a library
    if (strcmp(get_param(bdroot(block),'BlockDiagramType'),'library'))
        return;
    else 
       % make sure TPU interrupts are enabled
       i_checkInterruptsEnabled(block);
    end;
return;

% check that an interrupt level has been chosem for this
% TPU module
function i_checkInterruptsEnabled(block)
    % get the target object associated with this block
    target = RTWConfigurationCB('get_target', block);
    config = target.findConfigForClass('MPC555dkConfig.TPU');
    module = get_param(block, 'module');
    intLevel = eval(['config.TPU_' module '.IRQ_Level']);
    
    if strcmp(intLevel, 'Interrupts Disabled')
        block = regexprep(block, sprintf('\n'), ' ');
        error(['TPU_' module ' IRQ_Level is set to "Interrupts Disabled" in the MPC555 Resouce Configuration block. '...
               'The TPU PTA block, ''' block ''' requires the use of TPU interrupts. '...
               'To fix this error please specify an IRQ_Level for TPU_' module ...
               ' in the MPC555 Resource Configuration block']); 
    end;
return;

function i_max_count_callback(block)
    % check the maxCount entry
   maxCount = str2num(get_param(block,'maxCount'));
   if (isempty(maxCount))
      % perhaps this is a mask variable
      % initialisation case will deal with this
      return;
   end;

   if (maxCount ~= uint8(maxCount))
      % failure
      i_invalidMaxCount;  
   end;
return;

function i_invalidMaxCount
    error(['MAX_COUNT parameter should be an unsigned 8 bit integer (range 0 <= MAX_COUNT <= 255). '...
          'A value for MAX_COUNT has been entered that is not in this range. '...
          'To fix this error, enter a value for the MAX_COUNT parameter that is in range.']);
return;
