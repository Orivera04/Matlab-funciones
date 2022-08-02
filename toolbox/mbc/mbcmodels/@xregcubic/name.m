function n= name(m);
% xregcubic/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:45:27 $

ord= max(get(m,'order'));

switch ord
case 0
	n= 'Mean';
case 1
	n= 'Linear';
case 2
	n= 'Quadratic';
case 3
	n= 'Cubic';
otherwise
	n= ['Poly_',int2str(length(m.N))];
end
