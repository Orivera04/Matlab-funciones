function varargout = ftsgraphsmenu(varargin)
%FTSWINDOWMENU The Window menu item of FTS GUI.
%
%   FTSWINDOWMENU generates the Window menu item of the
%   financial time series GUI, ftsgui.  Please start the GUI 
%   from the MATLAB command line using
%
%      ftsgui
%
%   See also FTSGUI.
%

%
%   NOTE: Need to be called from ftsgui.m.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $   $Date: 2004/04/06 01:09:28 $

switch nargin,
    case 0,
        mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
            'Tag', 'FTSGUIMainWindow');

        MenuItems = {'&Window', 'winmenu(gcbo); drawnow;', 'windowMenuItem';
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            ;
            '>blank' , ''                       , ''            };
        hWindowMenuItems = makemenu(mainFTSGUIWindow, str2mat(MenuItems{:, 1}), str2mat(MenuItems{:, 2}), str2mat(MenuItems{:, 3}));

        varargout{1} = hWindowMenuItems;

end   % End of SWITCH NARGIN block.

return
