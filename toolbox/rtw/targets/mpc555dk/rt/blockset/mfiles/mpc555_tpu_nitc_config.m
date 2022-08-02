function [varargout] = mpc555_tpu_nitc_config(action, block, varargin)
% MPC555_TPU_NITC_CONFIG implements mask callbacks and initialisation
% for MPC555 TPU NITC block
%
% action - see switch case below
%
% block - handle to the block

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $
%   $Date: 2004/04/19 01:29:58 $

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
    if (maxCount ~= uint16(maxCount))
        % failure
        i_invalidMaxCount;  
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

   if (maxCount ~= uint16(maxCount))
      % failure
      i_invalidMaxCount;  
   end;
return;

function i_invalidMaxCount
    error(['MAX_COUNT parameter should be an unsigned 16 bit integer (range 0 <= MAX_COUNT <= 65535). '...
          'A value for MAX_COUNT has been entered that is not in this range. '...
          'To fix this error, enter a value for the MAX_COUNT parameter that is in range.']);
return;
