function [varargout] = mpc555_tpu_fqd_config(action, block, varargin)
% MPC555_TPU_FQD_CONFIG implements mask callbacks and initialisation
% for MPC555 TPU FQD block
%
% action - see switch case below
%
% block - handle to the block

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.2 $
%   $Date: 2002/10/18 16:12:24 $

switch lower(action)
case 'initpositioncallback'
   i_initPositionCallback(block);
case 'model_initialisation'
   % note: no set_params are allowed in block initialisation callback
   i_model_initialisation(block, varargin{1});
otherwise
   error(['Action ' action ' not found!']);
end;

function i_model_initialisation(block, positionCount)
   % check the init_position_count entry
   if (positionCount ~= uint16(positionCount))
      % failure
      i_invalidPositionCount;  
   end;
return;

function i_initPositionCallback(block)
   % check the init_position_count entry
   positionCount = str2num(get_param(block,'init_position_count'));
   if (isempty(positionCount))
      % perhaps this is a mask variable
      % initialisation case will deal with this
      return;
   end;

   if (positionCount ~= uint16(positionCount))
      % failure
      i_invalidPositionCount;  
   end;
return;

function i_invalidPositionCount
    error(['Initial Position Count parameter should be an unsigned 16 bit integer (range 0 <= POSITION_COUNT <= 65535). '...
          'A value for Initial Position Count has been entered that is not in this range. '...
          'To fix this error, enter a value for the Initial Position Count parameter that is in range.']);
return;

