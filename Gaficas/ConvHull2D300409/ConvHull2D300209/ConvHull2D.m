function chull=ConvHull2D(x,y)
%  chull=ConvHull2D(x,y) returns indices into the x and y vectors of the points on
%     the convex hull. Colinear points wont be part of the convex hull.
% 
%        Input:
%                x[nx1] : vectors of x points
%                y[nx1] : vectors of y points
%        Output:
%                chull[mx1]: index of convex hull points
%
%     Example:
%       N=20;
%       x=rand(N,1);
%       y=rand(N,1);
%       chull=ConvHull2D(x,y);
%       figure(1)
%       hold on
%       plot(x,y,'k.')
%       plot(x(chull),y(chull));
%       title('Convex Hull')
%
%
%     See also convhulln, delaunay, voronoi,
%              polyarea, qhull.
%
%
% For info/questions/suggestions : giaccariluigi@msn.com
%
% Visit:  http://giaccariluigi.altervista.org/blog/
%
% Author: Luigi Giaccari
% Last Update: 30/4/2009
% Creation: 27/11/2008


%Possible improvemets:
%   -each iteration update cros productvectors instead of points id. Should
%   be faster when the p2-p1 vector stays the same.
%   -seed a stable front before starting the main loop. This avoid the c>2
%   check at each iteration.
%   -Substitute the if else (if c>2) statement with if elseif c>2. Can it
%   be faster?
%


%How does it work?
%First delete points that can not be part of the convex hull than apply the
%cross product algorithom



%Errors check:
if nargin ~= 2
    error('MATLAB:ConvHull2D:NotEnoughInputs', 'Needs  2 inputs.');
end

if ~isequal(size(x),size(y))
    error('MATLAB:ConvHull2D:InputSizeMismatch',...
        'x,y have to be the same size.');
end
if ndims(x) > 2 || ndims(y) > 2
    error('MATLAB:ConvHull2D:HigherDimArray',...
        'x,y cannot be arrays of dimension greater than two.');
end





N=length(x);

%quadrilater for point exclusion
pb=zeros(4,1);

%tollerances for point exclusion
toll=[inf;-inf;-inf;-inf];



%% Building the quadrilater
%we find the maximum and minum for (x+y) and (x-y)
% points inside this polygon will be deleted.
%Deleting points costs time, generally slow down the algorithm for a small
%number of points, but make it faster for large models


% Notes on the use of a for-loop
%
%   MATLAB's implementation of Just-in-Time (JIT) accelerators make it
%   feasible to use a for loop as an alternative to a vectorised statement
%   in this situation. Depending on the shape and condition of the dataset,
%   the for-loop may be slightly faster or slower. In the event that an
%   alternative release of MATLAB alters the performance of the JIT
%   accelerators for this situation; the user may wish to substitute the
%   vectorised code below.
%
% % x_plus_y = x+y; x_minus_y = x-y;
% 
% [scratch,ind] = min(x_plus_y); pb(1,:) = [x(ind),y(ind)];
%     
% [scratch,ind] = max(x_minus_y); pb(2,:) = [x(ind),y(ind)];
% 
% [scratch,ind] = max(x_plus_y); pb(3,:) = [x(ind),y(ind)];
% 
% [scratch, ind] = min(x_minus_y); pb(4,:) = [x(ind),y(ind)];
% 


for i=1:N
    if x(i)+y(i)<toll(1)%maximum of differentia
        pb(1,1)=x(i);pb(1,2)=y(i);
        toll(1)=x(i)+y(i);
    end
    if x(i)-y(i)>toll(2)%down left
        pb(2,1)=x(i);pb(2,2)=y(i);
        toll(2)=x(i)-y(i);
    end
    if x(i)+y(i)>toll(3)%maximum of sum
        pb(3,1)=x(i);pb(3,2)=y(i);
        toll(3)=x(i)+y(i);
    end
    if  -x(i)+y(i)>toll(4)%top right
        pb(4,1)=x(i);pb(4,2)=y(i);
        toll(4)=-x(i)+y(i);
    end
end


% Setting tollerances
% Tollerances decides with point escapes the quadrilater and go building the convex hull
% They should be set using a semiplane test, using edges of quadrilater
% but it is easier and computational faster using a rectangle inscribed in it.

% simplified quadrilater boundaries
Mx=min(pb([2,3],1));%max x coordinate
My=min(pb([3,4],2));%max y coordinate
mx=max(pb([1,4],1));%max x coordinate
my=max(pb([1,2],2));%max y coordinate

%deleting internal points
test=(x>=Mx | x<=mx | y>=My | y<=my);
index=1:N;
index=(index(test));%these ones are survivors
x=x(test);%coordinates of survivors
y=y(test);
N=length(x);

%sorting the survivors
[y,sindex] = sort(y);
x = x(sindex);

%% Building the convex hull applying brute crossproduct algorithom
%The algorithom could have been started here but generally many points are
%deleted in the previsious process.
%now that the number of points should be greatly minor it is possible to apply a
%brute algorithom


tch=zeros(N,1);%temporay convex hull store
%this is a waste of memory points of the convex hull should
%be less than N but preallocation gives more speed



%This if statement tries to deal with colinear points 
colinear=false;
if y(1)==y(2) || y(end)==y(end-1)

    %count the number of ymin colinear points 
    i=1;
    while y(i)==y(i+1)
        i=i+1;
    end
    if i>1
     %sort colinear points    
    [x(1:i),xid]=sort(x(1:i),'descend');
    tempindex=sindex(xid);
     sindex(1:i)=tempindex; 
      %this points are colinear wont be part of convex hull 
    sindex(2:i-1)=[];
    y(2:i-1)=[];
    x(2:i-1)=[];
    
    end
     i=1;
    if x(1)>x(2)%check if x have been sorted
        %count the number of ymax colinear points
        while y(end-i+1)==y(end-i)
            i=i+1;
        end
        if i>1
         %sort colinear points
         colinear=true;
        [x(end-i+1:end),xid]=sort(x(end-i+1:end),'ascend');
        tempindex=sindex(end-i+1:end);
        sindex(end-i+1:end)=tempindex(xid);
         %this points are colinear wont be part of convex hull 
        sindex(end-i+2:end-1)=[];
        x(end-i+2:end-1)=[];
        y(end-i+2:end-1)=[];
        
        end
    else%there are only ymax colinear points
         %count the number of ymax colinear points
        while y(end-i+1)==y(end-i)
            i=i+1;
        end
        if i>1
         %sort colinear points
         colinear=true;
        [x(end-i+1:end),xid]=sort(x(end-i+1:end),'descend');
        tempindex=sindex(end-i+1:end);
        sindex(end-i+1:end)=tempindex(xid);
        %this points are colinear wont be part of convex hull 
        sindex(end-i+2:end-1)=[];
        x(end-i+2:end-1)=[];
        y(end-i+2:end-1)=[];
         end
    end
    N=length(x);
end

%checking orientation for cross product      
if x(1)>x(2) %clockwise

    orientation=1;
else         
    orientation=-1;%counterclockwise
end


% figure(1)
% hold on
% axis equal
% plot(x,y,'k.')
% id=1:N;
% text(x,y,num2str(id'));


c=2;%convex hull vector iterator
i=2;%points vector iterator

%the first edge to start  the convex hull
tch(1)=1;
tch(2)=2;
p1=tch(1);
p2=tch(2);

while i<=N-1

    %cross product indexing
    % p1   p2   p3
    %<------.-------->
    % c-1   c   i+1

    p3=i+1;
    
    %debug
%      figure(1)
%   plot([x(p1),x(p2)],[y(p1),y(p2)],'-b')
%    plot([x(p2),x(p3)],[y(p2),y(p3)],'r-')
%     
    
    
    %cross product
    cp=orientation*((x(p1)-x(p2))*(y(p3)-y(p2))-(x(p3)-x(p2))*(y(p1)-y(p2)));
    
    if cp>0   %add point to chull
       %go forward
        tch(c+1)=i+1; %add point to temporary chull  
        p1=p2;
        p2=p3;
        c=c+1;
        i=i+1;%try next point
    else%remove  point from temporary chull
        %go back  
        if c>2%an exclusion at first iteration may create problems
            c=c-1;
            p2=p1;
            p1=tch(c-1);
        else
            tch(2)=i+1;
            p2=i+1;
            i=i+1;%try next point
           
        end
    
    end


end



%debug
% figure(1)
% hold on
% axis equal
% plot(x,y,'k.')
% plot(x(tch(1:c)),y(tch(1:c)),'r');
% plot(x(tch(1:c)),y(tch(1:c)));
% title('Convex Hull','fontsize',13)
% 



%first half done let's make the second going down
    
p1=c-1;
p1=tch(p1);
p2=tch(c);

%checking y colinearity
if colinear || p1==i-1;%avoid null cross product at first loop
    i=i-1;
end



while i>1
    %cross product indexing
    % p1   p2   p3
    %<------.-------->
    % c-1   c   i-1

    p3=i-1;
    
    
    %debug
%      figure(1)
%   plot([x(p1),x(p2)],[y(p1),y(p2)],'-b')
%    plot([x(p2),x(p3)],[y(p2),y(p3)],'r-')
%     

    %cross product
    cp=orientation*((x(p1)-x(p2))*(y(p3)-y(p2))-(x(p3)-x(p2))*(y(p1)-y(p2)));
    if cp>0   
       %go forward
       
        tch(c+1)=i-1; %add point to temporary chull
        p1=p2;
        p2=p3;
        c=c+1;
        i=i-1;%try next point
    
    else  %remove  point from temporary chull
      
        
        if c>2%an exclusion at first iteration may create problems
             %go back
            c=c-1;
            p2=p1;
            p1=tch(c-1);
        else
            %can not go back use brute force
            tch(2)=i-1;
            p2=i-1;
            i=i-1;%try next point
           
        end  

    end
end

% Re-index to undo the sorting and deleting
chull=index(sindex(tch((1:c))))';%convexhull

end


