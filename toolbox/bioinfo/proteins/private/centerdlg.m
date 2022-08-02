
function centerdlg(hMain,hDlg)

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/01/24 09:20:13 $

% Java dialog?
javadlg = isjava(hDlg);

% screen Units in pixels
screenunits = get(0,'Units');
set(0,'Units','pixels');
screensize = get(0,'ScreenSize');
set(0,'Units',screenunits);

% main figure's Units
mainunits = get(hMain,'Units');
set(hMain,'Units','pixels');

% main figure's Position
mainpos = get(hMain,'Position');
set(hMain,'Units',mainunits);

if javadlg
    dlgbounds = hDlg.getBounds;
    
    dlgpos = [dlgbounds.x,...
             screensize(4) - (dlgbounds.y + dlgbounds.height),...
            dlgbounds.width,...
            dlgbounds.height];
else    
    set(hDlg,'Units','pixels');    
    dlgpos = get(hDlg,'Position');   
end

midx = mainpos(1) + mainpos(3)/2;
midy = mainpos(2) + mainpos(4)/2;

newdlgpos = [midx - dlgpos(3)/2,...
        midy - dlgpos(4)/2,...
        dlgpos(3),...
        dlgpos(4)];

% if offscreen, center onscreen
if newdlgpos(1) < 0 || (newdlgpos(1) + newdlgpos(3) > screensize(3))
    newdlgpos(1) = screensize(3)/2 - dlgpos(3)/2;
end

if newdlgpos(2) < 0 || (newdlgpos(2) + newdlgpos(4) > screensize(4))
    newdlgpos(2) = screensize(4)/2 - dlgpos(4)/2;
end

if javadlg
    newbounds = [newdlgpos(1),...
                 screensize(4) - (newdlgpos(2) + newdlgpos(4)),...
                 newdlgpos(3),...
                 newdlgpos(4)];
         hDlg.setBounds(newbounds(1),newbounds(2),newbounds(3),newbounds(4));        
else
    set(hDlg,'Position',newdlgpos)    
end
