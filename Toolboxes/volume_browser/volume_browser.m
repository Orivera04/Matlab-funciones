function volume_browser(vol,varargin)
% Function creates a GUI to view a three-dimensional volume (entries of
% a three-dimensional matrix); please not that any window created by 
% "volume_browser" will be automatically deleted upon exit from the function.
%
% Adaptation/simplification of function "v3d" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Adapted by: E. Rietsch: October 9, 2006
% Last updated: December  30, 2006: Add time stamp
%
%        varargout = volume_browser(vol,varargin)
% INPUT
% vol    three-dimensional matrix; the first dimension of "vol" is the y-axis,
%        the second the x-axis, and the third the z-axis; 
%        if the volume is arranged differently (with seismic data the first
%        dimension is usually z (depth/time)) then "vol" needs to be 
%        reordered; this can be achieved with Matlab function "permute".
% x      vector of x-coordinates; length(x) == size(vol,2)
% y      vector of y-coordinates; length(y) == size(vol,1) 
% z      vector of z-coordinates; length(z) == size(vol,3) 
%        The three coordinate vectors are optional; if they are omitted
%        they are set to
%           x=1:size(vol,2))';
%           y=1:size(vol,1))';
%           z=1:size(vol,3))';
%        Either all three or none of the coordinate vectors must be given.
% options  the last input argument; a structure with optional parameters.
%        Possible fields are:
%     'equal_axes'  logical variable; if true sets the aspect ratio so that 
%        equal tick mark increments on the x-,y- and z-axis are equal in size.
%        Default:  options.equal_axes='false'
%     'title' title of main figure
%        Default:  options.title=[];   % no title
%     'plot_label' Label to be plotted in the lower left corner of the plot
%        Default:  options.plot_label=[]
%     'plot_time'  Date/time to be plotted in the lower left corner of the plot
%        Default: options.plot_time=datestr(now)
%     'zdir'  direction of z-axis; possible values are: 'normal' and 'reverse'
%        Default:  options.zdir='normal';
%     'xinfo'   three-string cell array of the form
%        {mnemonic,units_of_measurement,description}
%        The first string, "mnemonic", is a kind of abbreviation for the
%        x-coordinate; it is used in menus to identify it; to fit into the 
%        limited space without being truncated it should have no more than
%        about 8-9 characters.
%        The second string denotes the units of measurement (use a blank,' ', 
%        or 'n/a' if the coordinate is dimensionless); 
%        The third string is a description used for axis labels
%        Default: options.xinfo={'x','n/a','X'};
%     'yinfo'   three-string cell array; analogous to "xinfo".
%        Default:  options.yinfo={'y','n/a','Y'};
%     'zinfo'   three-string cell array; analogous to "xinfo".
%        Default:  options.zinfo={'z','n/a','Z'};
%      
% EXAMPLES
%      %	Minimum input
%      vol=randn(10,11,12);
%      volume_browser(vol);
%      
%      %	Axis annotation is specified
%      options.xinfo={'width','m','Width'};
%      options.yinfo={'depth','m','Depth'}; 
%      options.zinfo={'height','ft','Model height'}; 
%      options.plot_label='Sample plot';
%      volume_browser(vol,options)

global V3D_HANDLES

if nargin == 0
   error('At least one input argument is required.')
end

%	Digest input arguments and do some error checking
dims=size(vol);

if length(dims) ~= 3
   error(' The first input argument must be a three-dimensional matrix.')
end

%	Default options
options.equal_axes=false;
options.plot_label=[];
options.plot_time=datestr(now);
options.plot_title=[];
options.xinfo={'x','n/a','X'};
options.yinfo={'y','n/a','Y'};
options.zinfo={'z','n/a','Z'};
options.zdir='normal';
options.debug=false;

if nargin == 2 || nargin == 5
   options=assign_fields(options,varargin{nargin-1});
end

if nargin == 4  || nargin == 5
   x=varargin{1}(:);
   y=varargin{2}(:);
   z=varargin{3}(:);
   if dims(1) ~= length(y)
      error('First dimension of "vol" does not match length of "y".')
   end
   if dims(2) ~= length(x)
      error('Second dimension of "vol" does not match length of "x".')
   end
   if dims(3) ~= length(z)
      error('Third dimension of "vol" does not match length of "z".')
   end

elseif nargin <= 2
   x=(1:dims(2))';
   y=(1:dims(1))';
   z=(1:dims(3))';

else
   error('One, 2, 4, or 5 input arguments required.')
end


figure_handle=figure('visible','on', ...
		     'IntegerHandle','off', ...
		     'numbertitle','off', ...
		     'doublebuffer','on', ...
                     'Tag','V3D:FIGURE', ...
                     'render','opengl', ...
		     'renderermode','manual', ...
		     'CloseRequestFcn',@v3d_closereq, ...
                     'name','Volume browser');
time_stamp_no2(options)

%       View options
menuid = uimenu(figure_handle,'Label',' &Views ','ForegroundColor','red');

uimenu(menuid,'Label','Default view','Callback',@v3d_standard_view);
uimenu(menuid,'Label','3D-View','Callback','myview(3);camva(''auto'')');
uimenu(menuid,'Label','xz-Plane','Callback','oldcamva=camva;myview(0,0);camva(oldcamva);clear oldcamva');
uimenu(menuid,'Label','yz-Plane','Callback','oldcamva=camva;myview(90,0);camva(oldcamva);clear oldcamva');
uimenu(menuid,'Label','xy-Plane','Callback','oldcamva=camva;myview(0,90);camva(oldcamva);clear oldcamva');
uimenu(menuid,'Label','Clear figure','Callback','oldcamva=camva;myview(3);camva(oldcamva);cla;clear oldcamva');
uimenu(menuid,'Label','&Grid','Separator','on','Callback',@v3d_menu_grid);
uimenu(menuid,'Label','Color selection','Callback','v3d_color(gcf)');
if options.debug
   uimenu(menuid,'Label','Keyboard','Callback','keyboard');
   uimenu(menuid,'Label','Rehash','Callback','rehash;disp(''Rehash'')');
end

 %	Volume manipulations
menuid = uimenu(figure_handle,'Label',' &Explore volume ','enable','on','ForegroundColor','red');

%	Create submenus
uimenu(menuid,'Label','3-D contours','Callback',{@v3d_contour,figure_handle});
uimenu(menuid,'Label','Iso-displays','Callback','v3d_iso(gcf)');
uimenu(menuid,'Label','Slices','Callback','v3d_slice(gcf)');
uimenu(menuid,'Label','Sliceomat','Callback','v3d_sliceomat(gcf)');
% uimenu(menuid,'Label','V3D_Patch','Callback','v3d_patch(gcf)');

%	Create help menu
create_help_menu(figure_handle)

V3D_HANDLES.figure_handle=figure_handle;

v3d_show(x,y,z,vol,options);   

grid off	% Turn grid off 
v3d_menu_grid   % Toggle grid on and set checkmark in menu


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function v3d_menu_grid(varargin)

global V3D_HANDLES 

%	Find handle for grid
tbgrid=findobj(V3D_HANDLES.figure_handle,'type','uimenu','Label','&Grid');

%	Checked im Menü togglen
if strcmp(get(V3D_HANDLES.axis_handle,'xgrid'),'off')
    grid(V3D_HANDLES.axis_handle,'on')
    set(tbgrid,'Checked','on');   
else
    set(tbgrid,'Checked','off'); 
    grid(V3D_HANDLES.axis_handle,'off')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function time_stamp_no2(option)
% Function creates time stamp and possibly a label on plot
%
% Written by: E. Rietsch: 1995
% Last updated: September 13, 2004: change handle visibilty to "off"
%
%           time_stamp_l(option)
% INPUT
% option   structure with fields "plot_time" and "plot_label".

figure_handle=gcf;
axis_handle=gca;	% Save handle to current axes

h=axes('Position',[0 0 1 1],'Visible','off');

%  	Add date/time stamp  
xt=0.80;
yt=0.02; 
text(xt,yt,option.plot_time,'FontSize',7); 

%	Add label
xt=0.1;
yt=0.02;

%	LaTeX compliance
if ~isempty(option.plot_label)
   txt=strrep(option.plot_label,'\_','#&%');  
   txt=strrep(txt,'_','\_'); 
   txt=strrep(txt,'#&%','\_');

   text(xt,yt,txt,'FontSize',7);
end

set(h,'HandleVisibility','off');

axes(axis_handle);	% Make original axes the current axes
