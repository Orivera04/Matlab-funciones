function background_callback(varargin)
% Change background color
%
% Modified by E. Rietsch: October 15, 2006

handles=varargin{3};

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

axis_handle=get(figure_handle,'CurrentAxes');

%	Switch from white to black background and vice versa
whitebg(figure_handle);

%       Check background color
if mean(get(axis_handle,'color'))==0 
   set(handles.bgschwarz,'Value',1);
else
   set(handles.bgschwarz,'Value',0);
end
