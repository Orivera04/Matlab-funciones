Scalable Vector Graphics (SVG) Export of Figures

UPDATED VERSION 22-Jan-2006
(Use stable version 12-Dec-2005 for 2D plots in case of problems)

Converts 2D & 3D Matlab plots to the scalable vector format (SVG). This format is specified by W3C (http://www.w3.org) and can be viewed and printed with internet browsers. Plug-ins for the browsers are available from Adobe (http://www.adobe.com/svg or http://www.adobe.com/svg/viewer/install/beta.html) and Corel (http://www.corel.com). Mozilla Firefox (ver. < 1.5) needs at least version 6.0 Build 38363 of the Adobe SVG Viewer. The latest version of plot2svg supports the built-in SVG handling of Firefox 1.5 (with limitation for linear shaded patches).

Editors for the SVG file format can be found at http://www.inkscape.org or http://www.sodipodi.com.

Usage:
> plot2svg   % opens a file dialog to plot the active figure
    or
> plot2svg('myfile.svg', figure handle, pixelfiletype)
    
  pixelfiletype = 'png' (default), 'jpg'         

IMPORTANT: Firefox 1.5 may hang if too many linear shaded patches are used in the figure.

Supported Features
- line, patch, contour, contourf, quiver, surf, ...
- markers
- image (saved as linked png pictures)
- grouping of elements
- alpha values for patches
- subplot
- colorbar
- legend
- zoom
- reverse axes
- controls are saved as png pictures
- log axis scaling
- axis scaling factors (10^x)
- labels that contain Latex commands are interpreted (with some limitations):
\alpha, \Alpha, \beta, \Beta, ... \infity, \pm, \approx
{\it.....} for italic text
{\bf.....} for bold text
^{...} for superscript
_{...} for subscript

How to use SVG files in HTML code
<object type="image/svg+xml" data="./mySVGfile.svg" width="140" height="100"></object>

Changes in Version 22-May-2005
- bugfix line color
- bugfix path of linked jpeg figures
- improved patch handling (interpolation and texture still missing, preliminary depth sorting)
- support of pcolor plots
- preliminary: surface plots are projected on the xy-plane (use 'rotate' command)

Changes in Version 12-Dec-2005
- bugfix viewBox
- improvement of the axis scaling (many thanks to Bill Denney)
- improvement handling of exponents for log-plots
- default pixel format png instead of jpeg (many thanks to Bill Denney)
- bugfix axindex
- bugfix cell array cells (many thanks to Bill Denney)
- improved handling of pixel images (many thanks to Bill Denney)
- to save original figure background use set(gcf,'InvertHardcopy','off')
- improved markers

Changes in Version 8-Jan-2006
- axes handling fully reworked (3D axes)
- rework of axes scaling (3D axes)
- clipping enabled (Use carefully, as all figure data is written to file -> may get large)
- minor grid lines are now supported for linear and log plots
- linear color interpolation on patches (The interploation needs to be emulated as SVG does not support a linear interpolation of colors between three points. This is done by combination of different patches with linear alpha gradients. See limitation for Firefox 1.5.)

Changes in Version 22-Jan-2006
- bugfix 'end'


Limitations:
- axis scaling factors for 3D axes
- plot object of Matlab R14 not supported (use 'v6' switch instead)
- 3D plot functionality limited (depth sorting, light)

Example of a SVG file is included to the zip file.

Reports of bugs highly welcome. 
