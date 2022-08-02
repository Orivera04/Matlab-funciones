% MATLAB Java Demo Script winapp.m
%
%  Mastering MATLAB Java Example 2:
%    Create a window with buttons, menus and text objects using
%    Java windowing toolkit objects.
%

%   B.R. Littlefield, University of Maine, Orono, ME 04469
%   6/22/00
%   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

% Import the entire Java Abstract Window Toolkit.
% (It won't hurt to import the same package more than once.)

import java.awt.*

% Create a window using the flow layout model (the simplest)
%    and set the title. Set the layout using Java syntax.

win=Frame('A Cool Window');
win.setLayout(FlowLayout);

% Specify the window location, size and color. Use Java syntax
%    for the location and size, and use MATLAB syntax to set
%    the background color.

win.setLocation(50,50);
win.resize(340,160);
set(win,'Background',[.7 .8 .9]);

% Create a menubar object.

mb=MenuBar;

% Create a 'File' menu and attach it to the menubar.

mf=Menu('File');
mb.add(mf);

% Create a 'Quit' menu item, define a callback to close the window,
%     and attach it to the File menu.

mq=MenuItem('Quit');
set(mq,'ActionPerformedCallback','win.hide')
mf.add(mq);

% Create a 'Help' menu, attach it and move it to the right side
%    of the menubar using the setHelpMenu method.

mh=Menu('Help');
mb.add(mh);
mb.setHelpMenu(mh);

% Create a 4x21(?) text area with no scroll bars (3).

ta=TextArea({' Cool Window version 1.1  ',...
             'CopyLeft June 12, 2000 by ',...
             'Mastering MATLAB authors  ',...
             'Hanselman and Littlefield '},4,21,3);

% Don't let the user change the text.

ta.setEditable(0);

% Set the text background to a restful color.

set(ta,'Background',[1 1 .9]);

% Create an 'About' menu item and attach it to the Help menu.
%    Show or hide the text when the menu item is selected.

mn=MenuItem('About');
set(mn,'ActionPerformedCallback',...
       'if (ta.isVisible), ta.hide, else ta.show, end, win.show');
mh.add(mn);

% Attach the menubar to the window.

win.setMenuBar(mb);

% Create some buttons.

bs=Button('Shrink');
be=Button('Expand');
bl=Button('Left');
bu=Button(' Up ');
bd=Button('Down');
br=Button('Right');
bq=Button('Quit');

% Define callbacks for the buttons.

set(bs,'MouseClickedCallback',...
        'win.resize(win.getSize.width-4, win.getSize.height-2), win.show')
set(be,'MouseClickedCallback',...
        'win.resize(win.getSize.width+4, win.getSize.height+2), win.show')
set(bl,'MouseClickedCallback',...
       'win.move(win.getLocation.x-4, win.getLocation.y), win.show');
set(bu,'MouseClickedCallback',...
       'win.move(win.getLocation.x, win.getLocation.y-2), win.show');
set(bd,'MouseClickedCallback',...
       'win.move(win.getLocation.x, win.getLocation.y+2), win.show');
set(br,'MouseClickedCallback',...
       'win.move(win.getLocation.x+4, win.getLocation.y), win.show');
set(bq,'MouseClickedCallback','win.hide')

% Specify some colors for the buttons.

set(bs,'Background',[.5,1,1]);
set(be,'Background',[1,.5,1]);
set(bq,'Background',[1,.6,.6]);
set(bl,'Background',[.6,.5,.4],'Foreground',[1,1,1]);
set(bu,'Background',[.6,.5,.4],'Foreground',[1,1,1]);
set(bd,'Background',[.6,.5,.4],'Foreground',[1,1,1]);
set(br,'Background',[.6,.5,.4],'Foreground',[1,1,1]);

% Add the first row of buttons to the window. Objects will be
%    positioned in the order in which they are added.

win.add(bs);
win.add(bl);
win.add(bu);
win.add(bd);
win.add(br);
win.add(be);

% Attach the text area to the window next, but don't display it yet.

win.add(ta);
ta.hide;

% Now add the Quit button to the window and make the window visible.

win.add(bq);
win.show;

