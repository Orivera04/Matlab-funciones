function varargout = ftshelpmenu(varargin)
%FTSHELPMENU The Help menu item of FTS GUI.
%
%   FTSHELPMENU generates the Help menu item of the
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
%   $Revision: 1.4.2.2 $   $Date: 2004/04/06 01:09:27 $

switch nargin,
    case 0,
        mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
            'Tag', 'FTSGUIMainWindow');
        MenuItems = {'&Help'                        , ''              , 'helpMenuItem'           ;
            '>Help on Financial Time Series GUI'    , 'ftshelpmenu(1)', 'helpFTSGUIMenuItem'     ;
            '>Help on Financial Time Series Toolbox', 'ftshelpmenu(2)', 'helpFTSTbxMenuItem'     ;
            '>-----'                                , ''              , ''                       ;
            '>Help on MATLAB'                       , 'ftshelpmenu(3)', 'helpMATLABMenuItem'     ;
            '>MATLAB Demos'                         , 'ftshelpmenu(4)', 'helpMATLABDemosMenuItem';
            '>-----'                                , ''              , ''                       ;
            '>About Financial Time Series GUI'      , 'ftshelpmenu(5)', 'helpAboutFTSGUIMenuItem';
            '>-----'                                , ''              , ''                       ;
            '>About MATLAB'                         , 'ftshelpmenu(6)', 'helpAboutMATLABMenuItem'};
        hHelpMenuItems = makemenu(mainFTSGUIWindow, str2mat(MenuItems{:, 1}), str2mat(MenuItems{:, 2}), str2mat(MenuItems{:, 3}));

        varargout{1} = hHelpMenuItems;

    case 1,
        switch varargin{1},
            case 1,   % Help on FTSGUI
                helpview([docroot, '\mapfiles\ftseries.map'], 'ftsgui');

            case 2,   % Help on Financial Time Series Tbx
                helpview([docroot, '\toolbox\ftseries\ftseries_product_page.html']);

            case 3,   % Help on MATLAB
                helpview([docroot, '\begin_here.html']);

            case 4,   % MATLAB Demos
                demo;

            case 5,   % About FTSGUI
                [pfname, rcsver, rcsts] = dbver('ftsgui.m');

                ftstbxinfo = ver('ftseries');

                msgtext = {['FTS GUI Version: ', rcsver]; ...
                    ['FTS GUI Time stamp: ', rcsts]; ...
                    ['']; ...
                    ['Financial Time Series Toolbox Version: ', ftstbxinfo(1).Version]; ...
                    ['Financial Time Series Toolbox Date: ', ftstbxinfo(1).Date]};
                hmb = msgbox(msgtext, 'About FTS GUI', 'modal');

            case 6,   % About MATLAB
                uimenufcn(gcbf, 'HelpAbout');

            otherwise,
                error('Valid flags are 1 thru 5.  Thank you...');

        end   % End of SWITCH VARARGIN{1} block.

end   % End of SWITCH NARGIN block.

return



%--------- HELPER FUNCTION(S) ---------------------------------------------%

function [pfname, rcsver, rcsts] = dbver(fname)
%DBVER  displays the RCS Revision and Date stamp of a function
%
%   WARNING:  Use at your own risk!  ;-)
%

%   P. N. Secakusuma, 10-03-1999

pathfname = which(fname);

if ~isempty(pathfname),
    fid = fopen(pathfname);
    while ~feof(fid),
        linedata = fgetl(fid);
        ddlridx = findstr(linedata, '$');
        if ~isempty(ddlridx),
            rev  = linedata(ddlridx(1)+11:ddlridx(2)-1);
            date = linedata(ddlridx(3)+7:ddlridx(4)-1);
            break;
        end
    end
    if nargout == 0,
        disp(['File location:  ', pathfname]);
        disp(['Revision #   :  ', rev]);
        disp(['Revision Date:  ', date]);
    else,
        pfname = pathfname;
        rcsver = rev;
        rcsts  = date;
    end
else,
    error(['Function ', upper(fname), ' cannot be found on MATLABPATH!']);
end

return
