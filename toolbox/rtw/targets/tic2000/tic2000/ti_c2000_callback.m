function ti_c2000_callback(action,varargin)
% TI_C2000_CALLBACK - TI C2000 Target
%    dynamic dialog callback handler
%
% $Revision: 1.1.6.3 $ $Date: 2004/04/08 20:58:53 $
% Copyright 2001-2004 The MathWorks, Inc.

s.action = action;
s.hSrc = varargin{1};
s.hDlg = varargin{2};

switch action

    case 'ActivateCallback',

        % Turn off logging if using GRT-based target. For ERT-based target, 
        % this is a user option, so we error out (see sytem target file)
        if strcmp( getVal(s,'SystemTargetFile'), 'ti_c2000_grt.tlc'),
            setVal(s, 'MatFileLogging','off');
        end
        
    case 'SelectCallback',

        % Turn off logging if using GRT-based target. For ERT-based target, 
        % this is a user option, so we error out (see sytem target file)
        if strcmp( getVal(s,'SystemTargetFile'), 'ti_c2000_grt.tlc'),
            setVal(s, 'MatFileLogging','off');
        end
        
        % Disable "Generate code only" checkbox
        setEnable(s, 'GenCodeOnly', 'off');

        % Uncheck and Disable "Generate an example main program" checkbox
        setVal(s, 'GenerateSampleERTMain','off');
        setEnable(s, 'GenerateSampleERTMain','off');
        
        % Set appropriate hardware settings for C2000
        setVal(s, 'ProdEqTarget', 'on');
        setVal(s, 'ProdHWDeviceType','TI C2000');

    case 'UnselectCallback',

        % Re-enable disabled checkboxes
        setEnable(s, 'GenCodeOnly', 'on');
        setEnable(s, 'GenerateSampleERTMain','on');

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


% --------------------------------------------------------------------
function setVal(s, propName, val)

slConfigUISetVal(s.hDlg, s.hSrc, propName, val);

% [EOF] ti_c2000_callback.m
