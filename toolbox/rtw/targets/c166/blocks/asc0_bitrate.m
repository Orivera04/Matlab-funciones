function [achieved, s0brs, s0brl] = asc0_bitrate(ideal,f)
%ASC0_BITRATE calculates bit rate parameters for the C166 serial interface
%   [ACHIEVED, S0BRS, S0BRL] = ASC0_BITRATE(IDEAL, F) calculates
%   the register fields S0BRS and S0BRL that give an ACHIEVED bitrate
%   that is the closest approximation to the IDEAL bitrate. The parameter
%   F is the system frequency.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2002/07/31 08:34:19 $
  
%
% Calculate the S0BRL register value to achieve the desired frequency.
% Do the calculation twice with S0BRS = 1 and S0BRS = 0 then take the
% best fit. See C166 user manual for formula.
%
s0brl_0 = i_calc_s0brl(ideal, 0, f);
s0brl_1 = i_calc_s0brl(ideal, 1, f);
bitrate_acheived_0 = i_calc_bitrate(s0brl_0, 0,f);
bitrate_acheived_1 = i_calc_bitrate(s0brl_1, 1,f);
error_0 = abs(bitrate_acheived_0-ideal);
error_1 = abs(bitrate_acheived_1-ideal);
if error_0<error_1
  s0brs = 0;
  s0brl = s0brl_0;
  achieved = bitrate_acheived_0;
else
  s0brs = 1;
  s0brl = s0brl_1;
  achieved = bitrate_acheived_1;
end  

return




function bitrate = i_calc_bitrate(s0brl, s0brs,f)
  bitrate = f / ( 16 * (2 + s0brs) * (s0brl+1) );
  

function s0brl = i_calc_s0brl(ideal, s0brs,f)
  s0brl = f / (16 * (2 + s0brs) * ideal) -1;
  
  s0brl = round(s0brl);
  
  max_val = 2^13-1;
  if s0brl > max_val
    s0brl = max_val;
  elseif s0brl < 0 
    s0brl = 0
  end




