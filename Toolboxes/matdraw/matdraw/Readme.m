MatDraw package for MATLAB Version 5.2

Keith Rogers	kerog@mit.edu  
8/04/96

**************************
Preliminary Release notes
**************************

This is the second release of MatDraw for MATLAB 5.  It includes
a few modifications which assure compatibility with MATLAB 5.2, but
will still work fine with 5.1 and 5.0. 

******************
Introduction
******************

The m-files in this directory are used to create a draw-program-like
interface for dealing with MATLAB graphs.  When you type "matdraw" at
the MATLAB prompt, they will create a palette with some standard draw
tools and a suite of menus with a number of generally useful functions. 
Figures modified with MatDraw can be saved and restored at a later
time.

This version of MatDraw is SHAREWARE.  Read the license file for 
registration information.  

Features:

-Arrows-

Erik Johnson's function arrow.m has been incorporated into
MatDraw to allow interactive creation and manipulation of 
2D and 3D arrows. 

-Cut, Copy, Paste-  

These standard functions may be applied to line, text, and patch 
objects.  The functionality seemed irrelevant to other types of 
objects.

-Undo-

Undo and redo may be applied to creation and deletion of objects 
via MatDraw tools, movement and resizing of objects through the 
Select Tool, and changes in object properties done through the menus.

-Zoom-

MatDraw's zoom functions allow the user to choose which axes
to zoom in, rbbox zoom, return to original axes, and 3-D zoom.
The 3-D zoom function uses an interactive picking routine to
select a zoom point and then redraws the objects so as to bypass
MATLAB's lack of 3D clipping, producing the desired result instead
of the mess you get when just changing the axis limits on a 
surface.  The 3D viewer may also be used to zoom in on a 3D
view using the new Camera metaphor in MATLAB 5.  This option 
does not work well in figures with subplots.

-Scrolling-

Use the arrow keys to shift the current axis limits by the tick
spacing.

-Labels-

A label dialog box allows you to quickly add and change labels
to a large number of subplots.

-Page Setup- 

A page setup dialog box allows you to adjust the position of
your figure on the page before printing.  This is also useful
for reducing picture size before printing to a postscript file
for importation to a word processor.  Also allows you to 
interactively reshape axes to whatever size you like.

-Expand/Reduce-

Temporarily expand a hard-to-see subplot to take up the entire
screen.  Then reduce it back to its former size and position.

-3D Viewer-

Use sliders to adjust the orientation of your 3D plot and
get an idea of how it will look with a handy previewer.

-Text Functions-

Interactively create, edit, move, and rotate text.  Modify
font, style, size, etc.

-Many others too numerous to mention-

Really.  There're lots.  It's really cool.

----------------------------------------------------

The Palette:

When MatDraw first starts up, it creates a palette of draw tools
in, appropriately enough, a figure called "Draw Tools".  This works
just like one would expect.  Click on the tool to select it.

Each of the tools may also be selected by pressing the key for
its character while in a figure running MatDraw.

+ Tool: This is a standard select tool.  When active, you can select
objects created with MatDraw and then manipulate them in various ways.

	Extend-clicking allows you to select more than one object.

	Extend-clicking on a line or text object to resize it has a 
	snap-to-grid effect as in most draw programs.  Angles are rounded
	to multiples of pi/6 and pi/4, under the assumption that square
	axes are being used.

	Extend-clicking on an ellipse to resize it forces it to a circle.

	Open-clicking on a text object allows you to edit it.

T Tool: This is a standard text tool.  Click where you want to insert
text; a text edit UIControl will be created for you to type in.  When
you're done, hit return, and the UIControl will be deleted and your
text inserted in its place.

/ Tool: This is a standard line drawing tool.  Click and drag to draw
lines.  

	Extend-clicking will give you a line drawn at an even angle.
	Angles are rounded to multiples of pi/6 and pi/4, under the 
	assumption that square axes are being used.

O Tool: This is a standard ellipse drawing tool.  The ellipse is drawn
from one corner of the box defined by dragging the mouse.  The ellipses
and circles are drawn to look proper with 'square' axes.  Changing the 
axis limits after drawing them will cause them to look weird.

	Extend-clicking forces the ellipse to a circle.
	Alt-clicking forces the ellipse to a circle with center at
	the click location

# Tool: This is a box drawing tool.  It draws boxes.

----------------------------------------------------

Menu Functionality:

WORKSPACE

New Figure      Generates a new figure, compelete with menus.

Load            Presents a dialog box for loading data files.

Save Workspace  Save workspace to file.  If Save As has already
                been used, overwrites the formerly selected file,
                otherwise, presents a dialog box.

Save As         Save workspace to a new file. Controlled by dialog
                box.

Save Figure     Saves the figure using MATLAB's print -dmfile command.
                Note that this sometimes generates a .mat file in
                addition to the .m file used to restore the figure.
				
Add to Path     Presents a standard dialog box for selecting files.
				The directory containing any file selected will
				be added to the MATLABPATH.

Print           Prints the figure using the print string specified
                in the preferences dialog.  This may be set to go
                either to a printer or a file.  In the latter case,
                you will be prompted for the filename, etc.

Preferences     Brings up a dialog box for setting various aspects of
                the MatDraw environment.  Each user can have his own
                mdprefs.mat file.


EDIT

Undo			These functions all do what you would expect.
Cut
Copy
Paste


TEXT

Font    Change the font of the current text.  If the font selected
        is not available, behavior is as described in the MATLAB 5
        manual. The fonts displayed in this menu are determined by
		the contents of the sys.fnt file in this directory.

Style   Change the style of the current text.  Includes Plain, Light,
        Demi, Bold, Italic, and Oblique.

Size    Change the size of the current text.

DRAW

Line Style
Marker
Line Width
Pen Color
Fill Color
Arrow 
Back
Forward
Send to Back
Send to Front

These should all be self-explanatory.
Note that the Marker menu has submenus for MarkerFaceColor,
MarkerPenColor, and MarkerSize.  The last 4 menu items can be
a help when dealing with the overlapping axes you get from plotyy.

FIGURE

Page Setup		Brings up a dialog box that allows you to manipulate
				the current figure's page-related properties. See 
				below for more details.

WYSIWYG         Changes the figure size to match the page size;
                this should give you a good idea of how your figure
				will look when printed out.
				
Colormap        Changes the colormap.

Full/Short		On some platforms MATLAB has some basic menus
Menus           which have the same functionality as some MatDraw
				menu items.  MatDraw's default behavior is to hide
				these menus so that they don't interfere with its
				work.  By choosing Full menus you can restore these
				menus, but doing so will cause MatDraw to remove
				conflicting accelerators.

AXIS

Labels          Puts up a new figure with UIControls for changing 
	            the current axes' labels. See below for more details.

Expand/Reduce	Expands the current axes to fill the entire figure, and
				Reduces it to its former size and position.

Clear           Clears the current axis.

Grid            Toggles the grid.

Freeze/Auto     Freezes the current axis limits or restores
                auto-ranging.

Aspect             Normal, Square, Image, or Equal.

X, Y, and Z Opts   Individual axis controls, including:
                        Linear/Logarithmic scaling 
                        Auto Min -> Sets the lower axis limit to -inf.  
                        Auto Max -> Sets the upper axis limit to inf.

Hold on/off

Zoom            Zoom functions, see below for more details.

Viewer          Presents sliders on a separate figure window which
                control the viewpoint.

----------------------------------------------------

Keyboard functions

Accelerators for the various menu items are noted in the 
menus themselves.  MatDraw also recognizes some keys pressed
while a figure running MatDraw is in the foreground.  The file
keys.gif contains a diagram showing these keys and the default menu 
accelerators.

1-9:  Set the current axes to the number pressed, counting from
	  top to bottom and right to left.

+:	  Select the Select Tool
T:	  Select the Text Tool
/:	  Select the Line Tool
O:	  Select the Ellipse Tool
#:	  Select the Box Tool

Arrow Keys:  Shift axis limits by tick spacing in appropriate
			 direction.

<DEL>: Delete the currently selected object.

Note that some computers may have different keyboard mappings for
the arrow keys.  If the arrow key functions do not work on your
computer, try using the command 

set(gcf,'KeyPressFcn','get(gcf,''CurrentCharacter'')-0');

Then press each of the arrow keys in turn to find out what number
MATLAB thinks it produces. You can then go into the file select.m
and search on "Left Arrow" to find the numbers that need to be
replaced to make your arrow keys work properly.

This also applies to the delete key. 
----------------------------------------------------

Page Setup

The Page Setup dialog box is pretty much self explanatory.
Two things to note, however:  

Changes do not take effect unless the OK or Apply  button is pressed.  
If the Cancel button is pressed, the figure's properties remain 
unchanged.

By clicking and dragging on the picture at the bottom, the 
size of the figure and its position on the page can be modified.
The size and position of axes on the page may also be adjusted
in this manner.  Alt- or Extend- clicking will cause your click
to apply to the figure even if you are clicking over an axes 
inside it.  This is necessary for cases where the axes occupy
a significant portion of the figure.

Using the WYSIWYG option in the Figure Menu allows you to see
the results of altering the placement of the figure on the page.

----------------------------------------------------

Labels

The Page Title field produces a title that is centered
on the figure, not an individual axes.  This is useful
when you have a number of subplots and want a single,
centered title.  It is the same functionality as the 
Page Title menu item in previous versions of MatDraw.

To the right of the edit uicontrols is a display showing
the positions of the axes in the current figure, with the
current axes outlined in white.  Click on the desired axes
to select it, and then enter or edit the label information.
The selected axes labels are automatically loaded into the
appropriate fields for editing.  If the axes has no labels
at present, the contents of the fields are left alone so that
you can rapidly apply the same labels to a series of plots.
Hit the Apply button to register changes without leaving the
dialog box.  

----------------------------------------------------

Zoom

The zoom function provided by the Mathworks usurps the current
figure's WindowButtonDownFcn while it is in use, and does not
restore it when done.  Since the user may have other uses for
their WindowButtonDownFcn, MatDraw's zoom usurps the function
only until a single zoom is completed and then restores the 
original WindowButtonDownFcn.  So each time you want to zoom 
in or out, you have to activate it either from the menu or
using the keyboard accelerators.  That said, MatDraw's zoom
provides the following advantages:

-Axes Control-

Using the Zoom submenu, the user can select which axes he or
she wants to zoom in on.  This gives oscilliscope-like functionality
in that you can change your X and Y scales separately.

-Rbbox Zoom- 

Like the Mathworks zoom function, MatDraw's zoom allows a
region to be selected by rbbox.  This also obeys the selected
zoom axes.

-3D Zoom- 

If you just change your axes limits on a 3D graph you will
likely discover that MATLAB doesn't do 3D clipping.  This 
means that to do a 3D Zoom that looks nice you have to do 
some fancy footwork.

When zooming in on a 3D graph, MatDraw first asks the you
to select a focus point in 3-space.  When you click on the axes,
a 3D crosshairs is drawn to show you where you are.  By moving
the mouse you adjust your position in the XY plane, with the
bottom left corner of the figure corresponding to the MinX MinY
corner of the XY plane.  By alt-clicking, you switch to adjusting
your position on the Z axis.  By normal clicking again, you switch
back to the XY plane.  When you are satisfied with your location,
extend-click to register your choice.

MatDraw then stores your surfaces and lines in a sort of clipboard 
and extracts the data that fits within the new X and Yaxis limits.
Z Data too large or too small for the Z axis limits is truncated
at the new axis limits.  The data in your surface and line objects
is then set to these new values to produce the desired visual 
effect.  Of course, the data is still there, and further zooms,
either in or out, will use the original data.

-Back to original limits-

As with the Mathworks zoom, MatDraw's zoom allows you to return
to your original axis limits.

-Adjust Zoom Factor-

The default zoom factor is 2.  It can be adjusted by selecting
the Mag Factor menu item from the Zoom submenu of the Axis Menu.

----------------------------

Defaults:

Items created from within MatDraw use the property values which are 
checked in the Draw Menu and Text Menu submenus.  To change these
defaults choose the relevant menu item when no objects are selected.

If you want to change the defaults at startup, go into the file
drwcback.m.  The defaults are set early on in the file, and
the comments should explain what's what fairly well.

----------------------------

Bugs/Requirements

MatDraw requires at least MATLAB 5.0 to run.

If you find a bug in MatDraw, please report it to me at 
kerog@mit.edu, preferably including any 
error messages generated and screenshots of strange graphic
behavior.
