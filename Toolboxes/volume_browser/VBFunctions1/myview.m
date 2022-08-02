function myview(varargin)
% Special version of Matlab function "view"; turns on watch while the 
% view is changed.
%
% Written by: E. Rietsch: October 17, 2006
% Last updated:

% The arguments are those of "view"

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

normal_pointer=get(figure_handle,'Pointer');
set(figure_handle,'Pointer','watch')
drawnow

% disp('in myview')%test

switch nargin
case 1
    view(varargin{1})

case 2
    view(varargin{1},varargin{2})

case 3
    view(varargin{1},varargin{2},varargin{3})

otherwise
    error('One, 2, or 3 input arguments required.')
end
%disp(' leaving myview')

drawnow
set(figure_handle,'Pointer',normal_pointer)
   
% disp(' leaving myview now')

% keyboard