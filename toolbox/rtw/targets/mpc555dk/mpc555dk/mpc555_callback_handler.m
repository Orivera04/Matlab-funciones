function mpc555_callback_handler(action, varargin)
% MPC555_CALLBACK_HANDLER callback handler for MPC555 real-time options

% Copyright 2003-2004 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/19 01:26:53 $  
  
  s.action = action;
  s.hSrc = varargin{1};
  s.hDlg = varargin{2};
  
  switch action
   % generic callback dispatcher
   case 'callback',
    s.currentVar = varargin{3};
    s.currentVal = getVal(s, s.currentVar);
    feval([s.currentVar '_callback'], s);
    
   case 'SelectCallback',
    % this callback is called:
    % 
    % a) when the target is first selected
    %
    % b) once for old models to convert them to 
    % the new callback mechanism

    % Set Hardware tab items to appropriate settings for MPC555 
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdEqTarget', 'on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdHWDeviceType','Motorola PowerPC');
    slConfigUISetVal(s.hDlg, s.hSrc, 'GenerateSampleERTMain','off');
    slConfigUISetVal(s.hDlg, s.hSrc, 'GenFloatMathFcnCalls','ISO_C');
    
   case 'UnselectCallback',
    % Revert the MPC555 specific settings
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdEqTarget', 'on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdHWDeviceType','32-bit Generic');
    slConfigUISetVal(s.hDlg, s.hSrc, 'GenFloatMathFcnCalls','ANSI_C');
  end

%---------------------------------------------------------------------

function MPC555_OPTIMIZATION_SWITCH_callback(s)
   % Dummy callback

   % callback no longer used except to trigger the FLAGS get function
   % The get function on the opt_flags decides whether
   % to use a target prefs value or the user
   % entered custom flags.


% ---------------------------------------------------------------------------

function MPC555_OPTIMIZATION_FLAGS_callback(s) 
   % set opt_switch to custom
   setVal(s, 'MPC555_OPTIMIZATION_SWITCH', 'custom');
   % The get function on the opt_flags will run after this
   % and display the user entered custom flags.
   
% --------------------------------------------------------------------
function setEnable(s, propName, state)

% Allow either number or string representation
if strcmp(state,'on'),
    state = 1;
elseif strcmp(state,'off'),
    state = 0;
end

slConfigUISetEnabled(s.hDlg,s.hSrc,propName,state);

%---------------------------------------------------------------------

function setVal(s, propName, val)

slConfigUISetVal(s.hDlg,s.hSrc,propName,val);


% --------------------------------------------------------------------
function val = getVal(s, propName)

val = slConfigUIGetVal(s.hDlg, s.hSrc, propName);

% --------------------------------------------------------------------

