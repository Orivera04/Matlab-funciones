function [varargout] = overtimeCtl(action, varargin)
% OVERTIMECTL is a helper function can be used to give user option to stop
% execution of time consuming routine.
% Usage: 
% 1. setup overtime: overtimeCtl('setup', 5)
% 2. start timer: overtimeCtl('start')
% 3. check timer: UserStop = overtimeCtl('check'), where UserStop indicate
% whether user choose to stop or not.
% 4. close timer/dialog: overtimeCtl('close').

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $


persistent dlgHandle; % dialog handle
persistent timeLimitinSecond; % over time setup in second
persistent startTime; % start time
persistent userStopTag;  % whether user choose to stop or not

switch action
    case 'start'
        startTime = clock;
        userStopTag = 0;
        dlgHandle = '';
    case 'close'  % close by program
        if ishandle(dlgHandle)
            delete(dlgHandle);
        end
    case 'setup'
        timeLimitinSecond = varargin{1};
        if ishandle(dlgHandle)
            delete(dlgHandle);
        end
    case 'check'  % busy program 
        current = clock;
        if etime(current, startTime) > timeLimitinSecond
            if isempty(dlgHandle) || ~ishandle(dlgHandle)
                dlgHandle = msgbox(sprintf(['The requested operation may take a long time to complete.\n', ...
                    'To interrupt it, click OK at any time.']), 'Please wait ...', 'modal');
                set(dlgHandle, 'DeleteFcn', 'overtimeCtl(''UserStop'')');  % setup call back
            end
            drawnow;
            %uiwait(dlgHandle);
        end
        varargout{1} = userStopTag;
    case 'UserStop' % user closed program to choose stop it
        userStopTag = 1;
    otherwise
        error('Incorrent action specified');
end
