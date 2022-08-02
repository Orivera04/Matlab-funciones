function vecinit(coords)
%VECINIT  Initiate function variables.
%   VECINIT([COORDS]) initiates the three coordinate variables with
%   aspect to the string COORDS = 'cart' | 'cyl' | 'sph'
%   into the callers workspace.

% Copyright (c) 2001-08-25, B. Rasmus Anthin.

if ~nargin
   coords='cart';
end
f=scalar('',coords);
[x,y,z]=vars(f);
vars=strvcat(x,y,z)';
for i=vars
   evalin('base',[deblank(i') '=scalar(''' deblank(i') ''',''' coords ''')'])
end