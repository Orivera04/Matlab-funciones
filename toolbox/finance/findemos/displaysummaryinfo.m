function displaysummaryinfo(infoCellArray)
%DISPLAYSUMMARYINFO Display DE parameter information.
%   DISPLAYSUMMARYINFO(INFOCELLARRAY) displays the text information for a 
%   selected line object. INFOCELLARRAY is a cell array that contains the
%   summary information (i.e., input control parameters and convergence
%   criteria) as the selected line object's 'UserData' field. When the 
%   user clicks on a line object, a text object is created to display the
%   contents of INFOCELLARRAY; the text is displayed inside a patch object
%   that, for appearances, simply frames the text so grid lines don't show
%   through (the patch object just makes it look better, and makes the 
%   text easier to read). When the user releases the mouse button, the 
%   text and patch is deleted.
%
%   See also DEGATOOL, GETSUMMARYINFO, DEGADEMO, RUNBUTTONCALLBACK.

% Author(s): R.A. Baker, 06/18/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/04/14 21:45:25 $

%
% Wrap the display code inside a TRY block. This just insulates the code
% from annoying errors that occur when the user inadvertantly double-clicks
% the line object whose summary information is to be displayed.
%

try

%
%  Get the axis limits (in data units) and find the center of the axis.
%
   xyLimits     =  axis;
   xMin         =  xyLimits(1);
   xMax         =  xyLimits(2);
   yMin         =  xyLimits(3);
   yMax         =  xyLimits(4);
   xCenter      =  xMin + (xMax - xMin)/2;
   yCenter      =  yMin + (yMax - yMin)/2;

   hold on      % Retain the current axis limits.

%
%  Create a TEXT object located at the (xCenter,yCenter) position above.
%
   textHandle  =  text(xCenter               , yCenter            , infoCellArray , ...
                       'tag'                 , 'helpText'         , ...
                       'HorizontalAlignment' , 'center'           , ...
                       'VerticalAlignment'   , 'middle'           , ...
                       'Fontname'            , 'courier'          , ...
                       'FontSize'            , 8                  , ...
                       'visible'             , 'off'              , ...
                       'color'               , get(gco , 'color'));
%
%  Get the size of the text object (in data units) so we can size the patch frame.
%
   textExtent  =  get(textHandle , 'extent');

%
%  Create a PATCH object (which must always be in data units) to bound the 
%  text object created above. The patch just makes a visually-appealing frame
%  for the text. Adjust the size of the patch to hold the text.
%
   x  =  [textExtent(1)  
          textExtent(1)+textExtent(3)  
          textExtent(1)+textExtent(3)  
          textExtent(1)];

   y  =  [textExtent(2)
          textExtent(2)   
          textExtent(2)+textExtent(4) 
          textExtent(2)+textExtent(4)];

   patchHandle =  patch('xdata'     , x       , 'ydata'     , y          , ...
                        'visible'   , 'on'    , 'edgeColor' , 'white'    , ...
                        'faceColor' , 'black' , 'tag'       , 'helpPatch');

   drawnow     % Update the screen.

%
%  Now turn on the help text so it's visible on top of the patch frame.
%
   set(textHandle , 'visible'  , 'on');

   hold off

end
