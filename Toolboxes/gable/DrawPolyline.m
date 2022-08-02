function DrawPolyline(P,c)
% DrawPolyline(P,c) - draw a polyline along the tips of the vector arguments
%  P: a cell array of GA vectors
%  c: an optional color argument
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

l = length(P);
if l < 2
	error('DrawPolyline: requires at least two vector arguments');
end

if nargin == 1
     c = 'b';
elseif nargin > 2
     error('DrawPolyline: takes only 2 arguments');
end
x = zeros(1,l);
y = zeros(1,l);
z = zeros(1,l);
for i = 1:l
	v = m(GA(P{i}));
        if ~GAisa(GAZ(P{i}),'vector')
                error('DrawPolyline: all objects in P must be vectors.');
        end
	x(i) = v(2);
	y(i) = v(3);
	z(i) = v(4);
end
plot3(x,y,z,c);
hold on;
axis('equal');
