%
%   MATLAB4 User Interface and Handle Graphics Programming Guidelines 
%
%   This help file contains useful tips, tricks, and methods for crafting
%   MATLAB4 applications with a graphical user interface.  Obeying
%   the guidelines listed has been found to yield code which is efficient 
%   (executes quickly and requires fewer lines), changeable, extensible, and 
%   intuitive.  
%
%
%                AN EFFECTIVE GUI PROGRAMMING METHODOLOGY
%
%  o Callbacks should be short and call functions.
%    When MATLAB evals a string, it must interpret it statement by statement.
%    MATLAB must do the same with a script m-file.  It behaves differently with
%    a function: the first time MATLAB encounters the function, it compiles it.
%    MATLAB does not re-interpret the function on subsequent calls.  Thus of the
%    three possibilities (function m-file, script m-file, and long string), 
%    making the callback a function m-file is by far the fastest, especially
%    if the callback is long.
%
%  o Switchyard concept of GUI programming.
%    This involves coding an application with a GUI as a single function.
%    Inside the function is a large if-then-else construct which executes
%    portions of the function based on an input switch.  Callback functions
%    of UI objects (uicontrols and uimenus) and mouse Button functions 
%    (down/motion/up) simply call the function with the appropriate input 
%    argument.  Callbacks are therefore very short and editing them is easier 
%    than changing multi-line string definitions.  A call to the function
%    with no input argument could by default start the program.  Program 
%    specific data and UI object handles are stored either as globals to the 
%    function or in the UserData of the objects.  This makes the application
%    "clear-proof".  For an example of this sort of programming, see "sigdemo1".
%
%    
%                GETTING THE MOST OUT OF HANDLE GRAPHICS 
%      (or, how to create fast and smooth click and drag applications)
%
%  o Draw moveable or changing objects with the 'erasemode' property set to 
%    'xor' or 'background'.  This prevents rerendering the axes when changing 
%    these objects. 'erasemode' is a property of all objects which are children 
%    of axes (line, text, surface, image, patch).
%
%  o Set 'drawmode' (an axes property) to 'fast'.  This prevents MATLAB from
%    sorting 3D objects, which can speed things up significantly.  The side-
%    effect is that 3D surface plots will not work in this mode.
%
%  o Set 'backingstore' (a figure property) to 'off'.  This should give 
%    roughly a factor of two speed-up in normal drawing but turns off the 
%    instantaneous update that normally ocurrs when windows are uncovered.
%
%  o Set 'nextplot' (a figure property) to 'new' when creating a GUI.  That 
%    way when you make plots from the command window they don't appear in the
%    axes of the GUI's figure window.
%
%  o Wherever possible, recycle figure windows by using the 'visible' property
%    of figures instead of creating and destroying them.  When done with the
%    window, set 'visible' to 'off'; when you need the window again, make any
%    changes to the window and THEN set 'visible' to 'on'.  Creating figure
%    windows involves much more overhead than unhiding them.
%
%  o Set a uicontrol's style upon creation.  E.g. uicontrol('Style','edit')
%    is much faster than h=uicontrol;set(h,'Style','edit').
% 
%  o Set a figure's position upon creation.  E.g. figure('Pos',[10 10 200 100])
%    is much faster than f=figure;set(f,'Pos',[10 10 200 100]).
% 

%-----------------------------------------------------------------------------
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1994/01/25 15:57:33 $
%-----------------------------------------------------------------------------
