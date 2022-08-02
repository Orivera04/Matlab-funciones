function v3d_standard_view(varargin)
% Create the standard view of the volume

% Written by: E. Rietsch: October 20, 2006
% Last updated:

% INPUT
% figure_handle  handle of the volume browser figure

global V3D_HANDLES

% figure_handle=varargin{3};

ud=get(V3D_HANDLES.figure_handle,'userdata');

v3d_show(ud.x,ud.y,ud.z,ud.v,getappdata(V3D_HANDLES.figure_handle,'options'));
