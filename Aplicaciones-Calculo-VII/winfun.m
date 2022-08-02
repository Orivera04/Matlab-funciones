function winfun(varargin)
% MATLAB Java Demo function winfun.m
%
%  Mastering MATLAB 7 Java Example 5
%    Create a window with buttons, menus and text objects using
%    Java windowing toolkit objects within a function. Use a 
%    local function to implement callbacks. Use persistent variables
%    to maintain visibility of the Java objects between calls.
%

% Import the entire Java Abstract Window Toolkit.

import java.awt.*

% Make sure we can find the Java objects when servicing callbacks.

persistent win ta mi abt mq ma txt x y h w

if isempty(win)

  % Initial function call: create the necessary objects.
  % Start with some text for the About Box.
  txt=[' Cool Window version 1.4  ';...
       ' MM7 example function by  ';...
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
  x=150; y=150; w=430; h=160;
  win.setLocation(x,y);
  win.setSize(w,h);
  set(win,'Background',[.8 .8 .8]);
  
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
  
  % Don't let the user change the text.
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
  set(be,'Background',[.5,1,1]);
  set(bq,'Background',[1,.4,.4]);
  set(bl,'Background',[.9,.9,.9]);
  set(bu,'Background',[.7,.7,.7]);
  set(bd,'Background',[.7,.7,.7]);
  set(br,'Background',[.9,.9,.9]);
  
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
  ta.setVisible(0);
  
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
  abt.setSize(180,110);

  % All done. Now show the main window and exit.
  win.setVisible(1);

elseif nargin == 0 
  % Reset the hidden window to the initial state and show it.
  abt.setVisible(0);
  ta.setVisible(0); mi.setLabel('Show Info');
  x=150; y=150; w=430; h=160;
  win.setLocation(x,y);
  win.setSize(w,h);
  win.setVisible(1);

elseif nargin == 1   % This is a callback.
   switch (varargin{1})
     case 'shrink'   % Shrink width by 4 pixels, height by 2
       w=w-4; h=h-2;
     case 'expand'   % Expand width by 4 pixels, height by 2
       w=w+4; h=h+2;
     case 'left'     % Move 4 pixels to the left
       x=x-4;
     case 'up'       % Move 2 pixels higher
       y=y-2;
     case 'down'     % Move 2 pixels lower
       y=y+2;
     case 'right'    % Move 4 pixels to the right
       x=x+4;
     case 'info'     % Toggle visibility of the text area
       if (ta.isVisible)
         ta.setVisible(0); mi.setLabel('Show Info');
       else 
         ta.setVisible(1); mi.setLabel('Hide Info');
       end 
     case 'about'    % Show the About Box to the right and lower
       abt.setLocation(x+w+20,y+10);
       abt.setVisible(1);
     case 'ok'       % Hide the About Box
       abt.setVisible(0);
     case 'quit'     % Hide the windows
       abt.setVisible(0);
       win.setVisible(0);
       return
     otherwise       % Bad argument
       error('Invalid callback');
   end
   win.setBounds(x,y,w,h); win.setVisible(1); 

else                  % Should not get here.
    error('Too many arguments.');
end

