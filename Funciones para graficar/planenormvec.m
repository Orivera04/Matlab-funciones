function vec = planenormvec(p1,p2,p3)

% PLANENORMVEC Calculate the normal vector of a plane in 3D.
%
%   VEC = PLANENORMVEC(PT1,PT2,PT3) calculats the normal
%   vector of a plane that includes three points PT1, PT2,
%   PT3. When the plane is expressed as ax + by + cz = 1,
%   VEC(1) = a, VEC(2) = b, VEC(3) = c.
%   Points should be a 1 x 3 vector, specifying x, y and z
%   values for each column.
%
%   (Example)
%   p1 = [3,4,5];
%   p2 = [8,-4,0];
%   p3 = [0,0,1];
%   vec = planenormvec(p1,p2,p3);
%   x = -10:0.5:10;
%   y = -10:0.5:10;
%   [xi,yi] = ndgrid(x,y);
%   z = (1-vec(1)*xi-vec(2)*yi)/vec(3);
%   figure;
%   h = mesh(x,y,z','LineWidth',1);hidden off;hold on;
%   xlabel('x');ylabel('y');zlabel('z');
%   plot3(p1(1),p1(2),p1(3),'*b',p2(1),p2(2),p2(3),'*r',...
%      p3(1),p3(2),p3(3),'*k');
%   

%   10 Mar 2005, Yo Fukushima

A = [p1;p2;p3];
if cond(A) ~= inf % when not singular
    d = [1;1;1];
    vec = inv(A)*d;
else % when it passes [0,0,0]
    B = [p1(1),p1(2);p2(1),p2(2)];
    if cond(B) == inf
        error('Three points are badly placed.');
        break
    end
    d = [-p1(3);-p2(3)];
    foo = inv(B)*d;
    vec = [foo(1);foo(2);1];
end

