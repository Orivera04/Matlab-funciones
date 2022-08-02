function winfun(varargin)
% MATLAB Java Demo Script winfun.m
%
%  Mastering MATLAB Java Example 3:
%    Create a window with buttons, menus and text objects using
%    Java windowing toolkit objects within a function. Use a 
%    switchyard and persistent variables to implement callbacks.
%

%   B.R. Littlefield, University of Maine, Orono, ME 04469
%   6/29/00
%   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

% Import the entire Java Abstract Window Toolkit.
% (It won't hurt to import the same package more than once.)

import java.awt.*

% Make sure we can find the objects we need when servicing callbacks.

persistent win ta mi mq ma abt txt

if (nargin == 0) & (isempty(win))

  % Create some text for the About Box.

  txt=[' Cool Window version 1.3  ';...
       'CopyLeft June 21, 2000 by ';...
       'Mastering MATLAB authors  ';...
       'Hanselman and Littlefield '];

  % Reshape it for use in the textarea as well.

  tstr=reshape(txt',1,prod(size(txt)));
  
  % Create a window using the flow layout model (the simplest)
  %    and set the title. Set the layout using Java syntax.

  win=Frame('Cool Java Window');
  win.setLayout(FlowLayout);

  % Specify the window location, size and color. Use Java syntax
  %    for the location and size, and use MATLAB syntax to set
  %    the background color.

  win.setLocation(50,50);
  win.resize(340,160);
  set(win,'Background',[.7 .8 .9]);
  
  % Create some menus: a 'File' menu and a 'Help' menu.
  
  mf=Menu('File');
  mh=Menu('Help');
  
  % Create a 'Quit' menu item, define a callback to close the window,
  %     and attach it to the File menu.
  
  mq=MenuItem('Quit');
  set(mq,'ActionPerformedCallback','winfun(''quit'')');
  mf.add(mq);

  % Create a 4x21 text area with no scroll bars (3).
  
  ta=TextArea(tstr,4,21,3);
  
  % Don't let the user muck about with the text.
  
  ta.setEditable(0);
  
  % Set the text background color.
  
  set(ta,'Background',[1 1 .9]);
  
  % Create a 'Show Info' menu item and attach it to the Help menu.
  %    Show or hide the textarea when the menu item is selected.
  
  mi=MenuItem('Show Info');
  set(mi,'ActionPerformedCallback','winfun(''info'')');
  mh.add(mi);
  
  % Create an 'About' menu item and attach it to the Help menu.

  ma=MenuItem('About');
  set(ma,'ActionPerformedCallback','winfun(''about'')');
  mh.add(ma);

  % Create a menubar object, add the menus, and attach 
  %   the menubar to the window.
  
  mb=MenuBar;
  mb.add(mf); mb.add(mh);
  mb.setHelpMenu(mh);      % Move the Help menu to the right side.
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
  
  set(bs,'MouseClickedCallback','winfun(''shrink'')')
  set(be,'MouseClickedCallback','winfun(''expand'')')
  set(bl,'MouseClickedCallback','winfun(''left'')');
  set(bu,'MouseClickedCallback','winfun(''up'')');
  set(bd,'MouseClickedCallback','winfun(''down'')');
  set(br,'MouseClickedCallback','winfun(''right'')');
  set(bq,'MouseClickedCallback','winfun(''quit'')');
  
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
  
  % Attach the text area to the window, but don't display it yet.
  
  win.add(ta);
  ta.hide;
  
  % Now add the Quit button.
  
  win.add(bq);

  % Now that the main window has been created, it is time
  %    to create a dialog box for the 'About' menu item.

  abt = Dialog(win, 'About Winfun');
  set(abt,'Background',[.95 .95 .95]);
  abt.setLayout(GridLayout(5,1));
  
  % Add some lines of text

  abt.add(Label(txt(1,:)));
  abt.add(Label(txt(2,:)));
  abt.add(Label(txt(3,:)));
  abt.add(Label(txt(4,:)));

  % and a button bar to close the About box.

  bok = Button('OK');
  set(bok,'ActionPerformedCallback','winfun(''ok'')');
  set(bok,'Background',[.6 .8 .8]);
  abt.add(bok);

  % Set the size of the dialog box but don't make it visible.

  abt.resize(180,110);

  % All done. Now show the main window and exit.

  win.show;

elseif nargin == 1   

  % This is the callback switchyard code.

  switch (varargin{1})

    case 'shrink'
      win.resize(win.getSize.width-4, win.getSize.height-2); win.show;
    case 'expand'
      win.resize(win.getSize.width+4, win.getSize.height+2); win.show;
    case 'left'
      win.move(win.getLocation.x-4, win.getLocation.y); win.show;
    case 'up'
      win.move(win.getLocation.x, win.getLocation.y-2); win.show;
    case 'down'
      win.move(win.getLocation.x, win.getLocation.y+2); win.show;
    case 'right'
      win.move(win.getLocation.x+4, win.getLocation.y); win.show;
    case 'info'
      if (ta.isVisible)
        ta.hide; mi.setLabel('Show Info');
      else 
        ta.show; mi.setLabel('Hide Info');
      end 
      win.show;
    case 'about'
      abt.setLocation(...
         win.getLocation.x+win.getSize.width+20, win.getLocation.y+10);
      abt.show
    case 'ok'
      abt.hide
    case 'quit'
      abt.hide; win.hide;
    otherwise
      error('Invalid callback');
  end

elseif nargin == 0 

  % Reset the hidden window to the initial state and show it.

  win.setLocation(50,50);
  win.resize(340,160);
  ta.hide;
  abt.hide;
  win.show;

else                                  % Should not get here.
    error('Too many arguments.');
end
