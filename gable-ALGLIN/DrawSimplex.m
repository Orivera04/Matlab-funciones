function DrawSimplex(S,c1,c2)
% DrawSimplex(S,c1,c2): draw a simplex S using colors c1 and c2
%  S is a cell array of 1,2,or 3 vectors.
%  c1 is the color of the vectors in S
%  c2 is the color of the simplex spanned by S
%  c1 and c2 are optional, although c1 must be specified if c2 is used
%  If c1=='n', then the vectors of S are not drawn.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

if nargin == 1
    c1 = 'b';
    c2 = 'y';
elseif nargin == 2
    c2 = 'y';
elseif nargin ~= 3
    error('DrawSimplex takes no more than 3 arguments');
end

if length(S)==1
    if ~strcmp(c1,'n')
	draw(S{1},GA,c1);
    end
    dx = inner(e1,S{1});
    dy = inner(e2,S{1});
    dz = inner(e3,S{1});

    sc = 0.01*sqrt(abs(norm(S{1})));
    x = sc*[-1 -1 -1 -1]+dx;
    y = sc*[-1  1  1 -1]+dy;
    z = sc*[-1 -1  1  1]+dz;
    patch(x,y,z,c2,'EdgeColor','none');
    x = sc*[ 1  1  1  1]+dx;
    y = sc*[-1  1  1 -1]+dy;
    z = sc*[-1 -1  1  1]+dz;
    patch(x,y,z,c2,'EdgeColor','none');

    y = sc*[-1 -1 -1 -1]+dy;
    x = sc*[-1  1  1 -1]+dx;
    z = sc*[-1 -1  1  1]+dz;
    patch(x,y,z,c2,'EdgeColor','none');
    y = sc*[ 1  1  1  1]+dy;
    x = sc*[-1  1  1 -1]+dx;
    z = sc*[-1 -1  1  1]+dz;
    patch(x,y,z,c2,'EdgeColor','none');

    z = sc*[-1 -1 -1 -1]+dz;
    y = sc*[-1  1  1 -1]+dy;
    x = sc*[-1 -1  1  1]+dx;
    patch(x,y,z,c2,'EdgeColor','none');
    z = sc*[ 1  1  1  1]+dz;
    y = sc*[-1  1  1 -1]+dy;
    x = sc*[-1 -1  1  1]+dx;
    patch(x,y,z,c2,'EdgeColor','none');
    axis tight;

elseif length(S)==2
    if ~strcmp(c1,'n')
        draw(S{1},GA,c1);
        draw(S{2},GA,c1);
    end
    DrawPolyline({.5*(S{2}-S{1})+S{1},S{2}},c2);
    draw(.5*(S{2}-S{1}),S{1},c2);
elseif length(S)==3
    if ~strcmp(c1,'n')
        draw(S{1},GA,c1);
        draw(S{2},GA,c1);
        draw(S{3},GA,c1);
    end
    DrawPolygon(S,c2);

    P = (S{2}-S{1})^(S{3}-S{2});	% plane of triangle
    P = P/norm(P);

    e1v = S{2}-S{1};
    e1p = P*e1v;	% rotate e1p by 90 degrees
    DrawPolyline({.5*e1v+S{1},.4*e1v+S{1}+.05*e1p},'k');

    e2v = S{3}-S{2};
    e2p = P*e2v;	% rotate e2p by 90 degrees
    DrawPolyline({.5*e2v+S{2},.4*e2v+S{2}+.05*e2p},'k');

    e3v = S{1}-S{3};
    e3p = P*e3v;	% rotate e3p by 90 degrees
    DrawPolyline({.5*e3v+S{3},.4*e3v+S{3}+.05*e3p},'k');

end
axis equal;
hold on;
