function [ok] = mbcocxdlg
%MBCOCXDLG Checks MBC OCX and prompts users to install them if needed
%
%  OK = MBCOCXDLG returns true if the MBC ActiveX controls are working
%  correctly and false if there are still problems.  If the ActiveX
%  controls initially appear to not be working, a dialog is presented to
%  the user that gives them the opportunity to fix the problems.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 06:49:00 $

% Check current ocx status
if ~i_cancreate
    msg = sprintf( ['MBC has detected a problem with its ActiveX controls installation.\n\n' ...
        'Do you want MBC to attempt to fix the problem?'] );
    choice = questdlg( msg,...
        'MBC Toolbox',...
        'Fix', 'Cancel',...
        'Fix' );
    switch choice
        case 'Fix'
            result = evalc( 'mbcconfig -setup' );
            switch result
                case sprintf( 'Installation successful.\n' )
                    if i_cancreate
                        ok = true;
                    else
                        uiwait( errordlg( 'MBC has been unable to fix the ActiveX problems.', ...
                            'MBC Toolbox', 'modal' ) );
                        ok = false;
                    end
                otherwise
                    uiwait( warndlg( 'An error occurred during installation of the ActiveX controls.', ...
                        'MBC Toolbox', 'modal' ) );
                    ok = false;
            end
        case 'Cancel'
            ok = false;
    end
else
    ok = true;
end



%----------------------------------------
function ok = i_cancreate
% %eturns false if we had an error creating one of our controls

% Test our key activex controls to make sure they all work correctly
try
    a = actxcontrol( 'MWMBCControls.listviewctrl', [0 0 0 0], 'command' );
    delete( a );
    a = actxcontrol( 'MWMBCControls.treeviewctrl', [0 0 0 0], 'command' );
    delete( a );
    a = actxcontrol( 'MWMBCControls.ImageListCtrl', [0 0 0 0], 'command' );
    delete( a );
    ok = true;
catch
    ok = false;
end
