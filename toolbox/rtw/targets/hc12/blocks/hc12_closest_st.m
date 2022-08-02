function [varargout] = hc12_closest_st(desiredST,osc)
%HC12_CLOSEST_ST
% Find the closest achievable sample time on the HC12 using the CRG
% register settings rtr[3:0] and rtr[6:4]
%
%   desiredST = Sample time in seconds.
%   osc       = Oscillator clock. 
%
%   Usage:
%   [st]                       = hc12_closest_st(0.01, 16000000)
%   [st, pctErr]               = hc12_closest_st(0.01, 16000000)
%   [st, rtr30, rtr64, pctErr] = hc12_closest_st(0.01, 16000000)

% Copyright 2003 The MathWorks, Inc.
% $Revision: 1.6.6.1 $ $Date: 2003/04/11 18:32:22 $

% Local variables
% a -- rtr30+1
% b -- rtr64

% Bounds on input
outOfBounds = 0;
if (desiredST>0.2)
  desiredST>0.2;
  outOfBounds = 1;
end

best_rtr30   = 1;
best_rtr64   = 1;
best_ST      = 1;
smallestDiff = 1;

% Determine value for CRG register RTR.
for a = 1:16
    for b = 1:7 
        st(a,b) = a*2^(9 + b) /osc;      
        stDiff = abs(desiredST-st(a,b));
        if stDiff < smallestDiff
            best_rtr30 = a;
            best_rtr64 = b;
            best_ST = st(a,b);   
            smallestDiff = stDiff;
        end
    end
end
best_rtr30 = best_rtr30-1; % Calculations above made with (rtr30+1)
percentError = (abs(desiredST-best_ST)/desiredST)*100;

if (percentError>2)
  if outOfBounds
      warndlg(['Excessive error between desired and actual sample time on HC12.', ...
        ' Please use function hc12_closest_st to determine an achievable sample time for the HC12.',...
        ' Simulink is now using a sample time of ',num2str(best_ST) ],'Unachievable sample time');
  
  else
      warndlg(['Error between desired and actual sample time on HC12 is ',num2str(percentError),'%.', ...
        ' Please use function hc12_closest_st to determine an achievable sample time for the HC12.',...
        ' Simulink is now using a sample time of ',num2str(best_ST) ],'Unachievable sample time');
  end
end

switch nargout
  case 1
    varargout = {best_ST};

  case 2
    varargout(1) = {best_ST};
    varargout(2) = {percentError};

  case 4
    varargout(1) = {best_ST};
    varargout(2) = {best_rtr30};
    varargout(3) = {best_rtr64};
    varargout(4) = {percentError};

  otherwise
    disp('Function: hc12_closest_st returns either 1, 2, or 4 arguments')
  end