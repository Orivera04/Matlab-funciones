function [y,ss] = perform_curve_warping( c, x, s )

% perform_curve_warping - perform a warping with respect to a central curve.
%
% y = perform_curve_warping( c, x, s );
%
%   'c' is a curve, i.e. a 2xP matrix.
%   'x' is a set of 3D points, i.e. a 2xn matrix.
%   's' is optional and is the curvilinear absice.
%
%   'ss' is the curvilinear absice.
%   'y' is the position of the warped points.
%
%   yi = y(:,i) is the position of the ith point.
%   yi(1) is the curvilinear absisce of the nearest point
%   from xi=x(:,i) on the curve c (with linear interpolation).
%   yi(2) is the signed distance between 
%   xi and the curve.
%
%   For example, if 'c' is just a straight line, 
%   then the warping is just a rotation that
%   aligns the line with the Y axis.
%
%   Copyright (c) 2004 Gabriel Peyré


global verb;
if isempty(verb)
    verb = 1;
end

if ~size(c,1)==2
    error('A curve must have 2 rows');
end

detection_type = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute curilinear abscice
if nargin<3 | length(s)==0
    s = compute_cuvilinear_abscice(c);
end

ss = s; % for future uses

N = size(c,2);
P = size(x,2);

if detection_type==1
    cx = [c(1,:), 10+rand];
    cy = [c(2,:), -10+rand];
    tri = delaunay(cx,cy);
    nxy = prod(size(cx));
    S = sparse(tri(:,[1 1 2 2 3 3]),tri(:,[2 3 1 3 1 2]),1,nxy,nxy);
    i1_list = dsearch(cx,cy,tri,x(1,:),x(2,:), S);
end


if 1 && detection_type==1
i1 = i1_list;
d1 = (c(1,i1-1)-x(1,:)).^2 + (c(2,i1-1)-x(2,:)).^2;
d2 = (c(1,i1+1)-x(1,:)).^2 + (c(2,i1+1)-x(2,:)).^2;
i2 = i1 + (d2>d1)*2 - 1;


x1 = c(:,i1);
x2 = c(:,i2);

I = find( s(i1)>s(i2) );
xtmp = x1(:,I); x1(:,I) = x2(:,I); x2(:,I) = xtmp;
itmp = i1(I); i1(I) = i2(I); i2(I) = itmp;

u = x2-x1;
w = x-x1;

nu = u(1,:).^2+u(2,:).^2;

lambda = ( u(1,:).*w(1,:)+u(2,:).*w(2,:) )./nu;
lambda = clamp(lambda); 

xx(1,:) = (1-lambda).*x1(1,:)+lambda.*x2(1,:);
xx(2,:) = (1-lambda).*x1(2,:)+lambda.*x2(2,:);

v = x-xx;

% uu = [-u(2,:);u(1,:)];      % u orthogonal

y(1,:) = sqrt( v(1,:).^2+v(2,:).^2 ) .* sign( u(1,:).*v(2,:)-u(2,:).*v(1,:) ); % distance to curve
y(2,:) = (1-lambda).*s(i1)' + lambda.*s(i2)';                     % curvlinear abscice

return;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OLD CODE
% not using the Matlab fast point location algorithm tsearch.

for i=1:P
    
    p = x(:,i);
    
    % find closest point
    if detection_type==1
        i1 = i1_list(i);
    else
        D = [ c(1,:) - p(1); c(2,:) - p(2) ];
        D =  D(1,:).^2 + D(2,:).^2;
        [tmp,i1] = min(D);            % first closest    
    end
    % find second closest point
    d1 = Inf; d2 = Inf;
    if i1>1
        d1 = sum( (c(:,i1-1)-p).^2 );
    end
    if i1<N
        d2 = sum( (c(:,i1+1)-p).^2 );
    end
    
    x1 = c(:,i1);
    if d1<d2
        i2 = i1-1;
    else
        i2 = i1+1;
    end
    x2 = c(:,i2);
    
    
    % swap x1/x2 if x1 is after x2
    if s(i1)>s(i2)
        xtmp = x1; x1 = x2; x2 = xtmp;
        itmp = i1; i1 = i2; i2 = itmp;
    end
    
    % interpolate intersection
    lambda = dot( x2-x1,p-x1 )/dot( x2-x1,x2-x1 );
    lambda = clamp(lambda); 
    
    xx = (1-lambda)*x1+lambda*x2;
    
    u = x2-x1;
    v = p-xx;
    
    if i1==1
        uu = [-u(2),u(1)];      % u orthogonal
        y(1,i) = dot( uu,v )/norme(u);
        y(2,i) = dot( u,v )/norme(u);      % should be <0
    elseif i2==N
        uu = [-u(2),u(1)];      % u orthogonal
        y(1,i) = dot( uu,v )/norme(u);
        y(2,i) = s(i2) + dot( u,v )/norme(u);      % should be <0
    else
        % ordinary case 
        y(1,i) = norme(v) * sign(u(1)*v(2)-u(2)*v(1));         % distance to curve
        y(2,i) = (1-lambda)*s(i1) + lambda*s(i2);                     % curvlinear abscice
    end

end