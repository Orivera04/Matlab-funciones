function  bank45(x,y)
%  adjust plot aspect ratio so that x,y is banked to 45 deg
%  bank45(x,y)

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  compute desired aspect ratio
a = aspect45(x,y);

%  apply it to current axes
set(gca,'DataAspectRatio',[1 1/a 1])
