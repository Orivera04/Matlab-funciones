function cghelptool(helpcode, modalFig)
%CGHELPTOOL Help dispatcher tool for cage
%
%  CGHELPTOOL(HELPID) dispatches a help call to the topic identified by
%  HELPID.  HELPID=0 is the default main MBC page.
%
%  CGHELPTOOL(HELPID, HFIG) dispatches a help call that will open the
%  context-sensitive help window, with the given figure handle HFIG as the
%  parenting window.
%
%  See also:  CGHELPMENU,CGHELPBUTTON, CGHELPTOOLBUTTON.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.4.3 $  $Date: 2004/04/04 03:36:49 $

try
    if isempty(helpcode)
        doc('mbc');
    else
        if nargin==1
            helpview(fullfile(docroot, 'toolbox', 'mbc', 'calibrate', 'calibrate.map'), ...
                helpcode);
        else
            helpview(fullfile(docroot, 'toolbox', 'mbc', 'calibrate', 'calibrate.map'), ...
                helpcode, 'CSHelpWindow', modalFig);
        end
    end
catch
    if nargin==1
        helpview(fullfile(docroot, 'nofunc.html'));
    else
        helpview(fullfile(docroot, 'nofunc.html'), 'CSHelpWindow', modalFig);
    end
end
