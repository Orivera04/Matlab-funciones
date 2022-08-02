% MatDraw GUI Toolbox
% Version 5.0 6/17/97
% Copyright (c) 1997 by Keith Rogers
%
% Main Program:
%   matdraw     - Set up menus for current figure and create
%                 the draw palette if it doesn't exist.
%   mdprog      - Called by matdraw, does most of actual work.
%
% Programs which may be called independently:
%   arrow       - Draw 2 and 3D arrows.  By Erik Johnson.
%   labels      - Interactively set title and labels
%   viewer      - Interactively control view for 3D graphs
%                 Modified by Patrick Marchand.
%   pgsetup     - Interactively control page-related figure
%                 properties
%   uihelp      - Creates a help function for a GUI.
%
% Utility functions, may be useful to anyone
%   palette     - Create a palette of tools (user customizable)
%   streamer    - Centered title for pages with many subplots
%   getset      - Sets one property (usually units) then gets another
%   choosecolor - Platform independent interactive color selection
%
% Callbacks, shouldn't be used directly
%  axcback      - Callbacks for the Axis menu
%  dmencback    - Callbacks for the Draw menu
%  drwcback     - Callbacks for the Draw Tools palette
%  figcback     - Callbacks for the Figure menu
%  mdpick       - Finds focus for zoom function (3D too!)
%  mdzoom       - Zoom function, must be called from menu
%  zoom3d       - Handles zooms for 3D objects
%  movetext     - Handles movement and rotation of text
%  select       - Selection, movement, resizing of objects
%  txtcback     - Callbacks for fiddling with text objects
%  vwrcback     - Callbacks for viewer
%  wrkcback     - Callback for WorkSpace menu (not on Macs)
%  mddefs       - Does preferences stuff.
%  
