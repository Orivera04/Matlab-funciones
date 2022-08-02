function c166_callback_handler(action, varargin)
% C166_CALLBACK_HANDLER callback handler for c166 real-time options

% Copyright 2002-2003 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.3.4.3 $
%   $Date: 2004/04/19 01:18:30 $  
  
  s.action = action;
  s.hSrc = varargin{1};
  s.hDlg = varargin{2};

  switch lower(action)
    
   case 'callback',
        
    s.currentVar = varargin{3};
    s.currentVal = getVal(s, s.currentVar);
    feval([s.currentVar '_callback'], s);
    
   case 'selectcallback',
        
    % Set Hardware tab items to appropriate settings for C166
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdEqTarget', 'on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdHWDeviceType','Infineon C16x');

    slConfigUISetVal(s.hDlg, s.hSrc, 'InitFltsAndDblsToZero','off');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ZeroExternalMemoryAtStartup','off');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ZeroInternalMemoryAtStartup','off');
    slConfigUISetVal(s.hDlg, s.hSrc, 'PurelyIntegerCode','on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'SupportNonFinite','off');
    slConfigUISetVal(s.hDlg, s.hSrc, 'IncludeMdlTerminateFcn','off');
    
    
   case 'unselectcallback',
    
    % Revert the C166 specific settings
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdEqTarget', 'on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ProdHWDeviceType','32-bit Generic');

    slConfigUISetVal(s.hDlg, s.hSrc, 'InitFltsAndDblsToZero','on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ZeroExternalMemoryAtStartup','on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'ZeroInternalMemoryAtStartup','on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'PurelyIntegerCode','off');
    slConfigUISetVal(s.hDlg, s.hSrc, 'SupportNonFinite','on');
    slConfigUISetVal(s.hDlg, s.hSrc, 'IncludeMdlTerminateFcn','on');
    
  end


% --------------------------------------------------------------------
function BuildActionC166_callback(s)

  
  switch s.currentVal
   case {'Run_with_simulator','Download_and_run_with_debugger'}
    setEnable(s, 'XviewStartupOptionsFile', 1);
   otherwise
    setEnable(s, 'XviewStartupOptionsFile', 0);
  end

% --------------------------------------------------------------------
function setEnable(s, propName, state)

% Allow either number or string representation
if strcmp(state,'on'),
    state = 1;
elseif strcmp(state,'off'),
    state = 0;
end

slConfigUISetEnabled(s.hDlg,s.hSrc,propName,state);

% --------------------------------------------------------------------
function val = getVal(s, propName)

val = slConfigUIGetVal(s.hDlg, s.hSrc, propName);
