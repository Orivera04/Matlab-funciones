function [C,minRad] = minCircle(n,p,m,b)

%  MINCIRCLE    Finds the minimum circle enclosing a given set of 2-D points.
%
% Usage:
%   [C,minRad] = minCircle(n,pts,m,bndry)
%   where:
%   OUTPUT:
%    C: the center of the circle
%    minRad: the radius of the circle
%   INPUT:
%    n: number of points given
%    m: an argument used by the function. Always use 1 for m.
%    bnry: an argument (3x2 array) used by the function to set the points that 
%          determines the circle boundry. You have to be careful when choosing this
%          array's values. I think the values should be somewhere outside your points
%          boundary. For my case, for example, I know the (x,y) I have will be something
%          in between (-5,-5) and (5,5), so I use bnry as:
%                       [-10 -10
%                        -10 -10
%                        -10 -10]
% Notes:
%  1. This function uses the "distance" and "findCenterRadius" functions.
%  2. The n and b arguments are not actually inputs by the user. The should be
%     set as described above. Since this function uses recursion, I couldn't
%     omit them. If you can,do it!
%
%
%
%
%   Rewritten from a Java applet by Shripad Thite (http://heyoka.cs.uiuc.edu/~thite/mincircle/).
%
%           Yazan Ahed (yash78@gmail.com)

c = [-1 -1];
r = 0;

if (m == 2)
    c = b(1,:);
    r = 0;
elseif (m == 3)
    c = (b(1,:) + b(2,:))/2;
    r = distance(b(1,:),c);
elseif (m == 4)
    [C,minRad] = findCenterRadius(b(1,:),b(2,:),b(3,:));
    return;
end

C = c;
minRad = r;

for i = 1:n
    if(distance(p(i,:),C) > minRad)
            if((b(1,:) ~= p(i,:)) & (b(2,:) ~= p(i,:)) & (b(3,:) ~= p(i,:)))
                b(m,:) = p(i,:);
                [C,minRad] = minCircle(i,p,m+1,b);
            end
    end
end
return;