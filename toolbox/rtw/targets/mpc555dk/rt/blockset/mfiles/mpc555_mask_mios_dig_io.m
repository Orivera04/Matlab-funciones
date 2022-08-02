function varargout = mpc555_mask_mios_dig_io(action,block,varargin)
%MPC555_MASK_MIOS_DIG_IO

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/08/15 16:26:58 $
switch lower(action)
case 'init'
    i_init(block, varargin{1});
case 'callback'
    i_callback(block);
end;
return;

% called at model update time - DO NOT use set_param
function i_init(block, bits)
    i_checkBits(bits);
return;

% mask callback - ok to use set_param
function i_callback(block)
    bits = str2num(get_param(gcb,'bits'));
    if (isempty(bits)) 
        % perhaps this is a mask variable
        % initialisation case will deal with this.    
        return;
    end;
    i_checkBits(bits);
return;

function i_checkBits(bits)
    if ( any(bits>15) + any(bits<0) + any(bits~=round(bits)) + any(diff(sort(bits))==0)  ) > 0
	    error('Each element of the bits vector must be a unique integer in the range 0 to 15')
    end
return;