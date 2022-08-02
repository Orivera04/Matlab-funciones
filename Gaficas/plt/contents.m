% plt.p: A substitute for plot.  Paul Mennen (paul@mennen.org)    17-Dec-05
%
% examples:                 (nt = number of traces)
% ---------                 ---------------------------------------------
% plt                     : opens the workspace plotter
% plt(y)                  : same as plot(y) except cursors are provided
% plt(x,y)                : same as plot(x,y) except cursors are provided
% plt(x1,y1,x2,y2,...)    : up to 25 traces may be ploted on one axis
% plt(x,y,'Title','t')    : Specify plot title
% plt(x,y,'Xlim',[0 8])   : Specify x-axis limits
% plt(x,y,'Ylim',[1 5])   : Specify y-axis limits
% plt(x,y,'YlimR',[0 2])  : Specify y-axis limits for the right hand axis
% plt(x,y,'LabelX','a')   : Specify x-axis label
% plt(x,y,'LabelY','b')   : Specify y-axis label
% plt(x,y,'LabelYR','c')  : Specify y-axis label for the right hand axis
% plt(x,y,'FigName','d')  : Specify figure name
% plt(x,y,'PltBKc',c)     : Specify plot background color (c = 1x3)
% plt(x,y,'FigBKc',c)     : Specify figure background color (c = 1x3)
% plt(x,y,'TRACEc',c)     : Trace color. (c = nt x 3)
% plt(x,y,'DELTAc',c)     : Specify delta cursor color (c = 1x3)
% plt(x,y,'xyAXc',c)      : Specify axis color (c = 1x3)
% plt(x,y,'xyLBLc',c)     : Specify axis label color (c = 1x3)
% plt(x,y,'CURSORc',c)    : Specify cursor color (c = 1x3)
% plt(x,y,'GRIDc',c)      : Grid color. (c = 1x3)
% plt(x,y,'Styles',s)     : Line styles (s is a string array of nt rows)
%                           (s may also be a string of nt characters)
% plt(x,y,'Markers',s)    : Trace markers (s is a string array of nt rows)
% plt(x,y,'ENAcur',e)     : To enable cursors on all traces, e=ones(1,nt)
% plt(x,y,'DIStrace',d)   : To enable viewing of all traces, d=zeros(1,nt)
% plt(x,y,'Position',p)   : p = [x(left) y(bottom) height width] in pixels
% plt(x,y,'AxisPos',p)    : Modify plot axis and/or traceID box positions
% plt(x,y,'TRACEid',t)    : Trace ID labels (t = nt x 6) t=0 to disable
% plt(x,y,'NewLimit',s)   : Evaluate string s when x or y limits are changed
% plt(x,y,'ENApre',m)     : Enable metric prefixes. m=[ENAx ENAy] (0 or 1)
% plt(x,y,'ENApre',m)     : Enable metric prefixes. m=[ENAx ENAy] (0 or 1)
% plt(x,y,'Quiver',[3 5]) : Identifies the 3rd and 5th traces as quiver plots
% plt(x,y,'Qhead',[l w])  : Specify Quiver arrow head relative length/width
% plt(x,y,'Options',s)    : s is a string containing one or more of these options:
%                           'Ticks'         disables grid lines
%                           'Menu'          enables the menu bar
%                           'Xlog'/'Ylog'   specifies log x-axis / y-axis
%                           '-All'/'+All'   removes/adds all menubox items
%                           '-Help'/'+Help' removes/adds Help from menubox
%                           '-Mark'/'+Mark' removes/adds Mark from menubox
%                           '-Xlog'/'+Xlog' removes/adds X lin log toggle from menubox
%                           '-Ylog'/'+Ylog' removes/adds Y lon log toggle from menubox
%                           '-Grid'/'+Grid' removes/adds Grid from menubox
%                           '-Figmenu'/'+F' removes/adds Menu from menubox
%                           '-Zout'/'+Z'    removes/adds ZoomOut from menubox
%                           '-Rotate'/'+R'  removes/adds XY<-> from menubox
%
% As with plot, plt returns a vector of line handles.
% The arguments may be in any order except that the y argument must immediately
% follow the x vector when plotting y vs. x.
% For example, these all do the same thing:
%   plt('Title','Fig 4.1',x,y,'Ylim',[0 8],x,y2);
%   plt(x,[y;y2],'Title','Fig 4.1','Ylim',[0 8]);  % if y is a row vector
%   plt('Title','Fig 4.1','Ylim',[0 8],x,[y y2]);  % if y is a column vector
% If y is real, then plt(y) is the same as plt(1:length(y),y).
% If y is complex, then plt(y) is the same as plt(real(y),imag(y)).
% Line styles may also specify markers. For example, this plots 8 lines that
% alternate between solid & dotted:  plt(1:50,(1:8)'*(1:50),'Style','-.-.-.-.');
% The right hand y-axis is enabled if either the YlimR or the LabelYR arguments
% are given. Only the last x,y pair specified is plotted on the right hand axis.
% 
% Note that the figure window size is adjustable using the mouse
% Up to 99 traces may be plotted.
%
% AUXILIARY plt functions ---------------------------------------------------------
% plt version             : returns plt version
% plt help                : displays plt help file (type 'help plt' for brief help)
% plt close               : closes all plt figure windows
% plt('ftoa',fmtstr,x)    : returns ascii conversion of scaler "x" using format fmtstr
% plt('vtoa',fmtstr,v)    : returns ascii conversion of vector "v" using format fmtstr
% plt('metricp',x)        : returns [MetrixPrefix Multiplier]
% plt('slider',...)       : functions for creating and using pseudo slider objects
% plt('edit',...)         : functions for creating and using edit text objects
% plt('pop',...)          : functions for creating and using popup text objects
% plt('grid',...)         : grid line functions
% plt('cursor',...)       : cursor functions
%
% The cursor ID is stored in the axis userdata allowing access to cursor functions.
% For example these two lines return the cursor position and sets the x-axis limits
%    Cursor_Position = plt('cursor',get(gca,'UserData'),'get','position');
%    plt('cursor',get(gca,'UserData'),'set','xlim',[x0 x1]);
% type 'plt help' for more information on the auxiliary plt functions
