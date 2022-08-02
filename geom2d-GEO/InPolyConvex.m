function in=InPolyConvex(qx,qy,x,y)

% help InPolyConvex
%   InPolyConvex: Point-in-polygon testing for convex polygon.
%
%   Determine whether a series of points lie within the bounds of a polygon
%   in the 2D plane.
%
%   SYNTAX:
%
%     in=InPolyConvex(qx,qy,x,y)
%
%     qx  : The points to be tested, vector [Nx1] of x coordinate.
%     qy  : The points to be tested, vector [Nx1] of y coordinate.
%
%     x   : The x coordinate of vertices of the convex polygon [Nx1]
%           The  syntax assumes that the vertices are specified in
%           consecutive order.
%     y   : The y coordinate of vertices of the convex polygon [Nx1]
%           The  syntax assumes that the vertices are specified in
%           consecutive order.
%
%
%     in  : An Nx1 logical array with IN(i) = TRUE if P(i,:) lies within the
%           region.
%
%   Notes: 
%           -InPolyConvex do not support on polygon options so tollerance is not necessary. 
%           -InPolyConvex do not support edges input format of the polygon.         
%           Maybe in the next revision these two feature will be added. 
%
%   EXAMPLE:
%
%          %query points
%          Nq=100;
%          qx=rand(Nq,1);
%          qy=rand(Nq,1);
%
%          %the convex polygon a square
%          x=.2+[0,.5,.5,0]';
%          y=.3+[0,0,.5,.5]';
%
%          in=InPolyConvex(qx,qy,x,y);
%
%          figure;
%          hold on
%          axis equal
%          plot(x,y)
%          plot(qx(in),qy(in),'.r');
%          plot(qx(~in),qy(~in),'.k');
%          legend('Polygon','Inside','Outside')
%
%
%   See also inpolygon convhull
%
% Author: Luigi Giaccari
% Last update: 30/11/2008
% Creation:30/11/2008


%How does it works?
% In this m.file there are trhee similar but different algorithms.
% According to the input type will be chosen the estimate best.
%Empirical values makes the choice among:
% 
% 1- A dot product based inspired from John D'errico inhull.m, this one
%   is faster when the convex polygon has a small number of points.
% 
% 2- A brute cross product algorithm which seem to be faster for not too big set
%   of query points.
%   
% 3- A more sofisticated cross product algorithm which is more suitable for large dataset
%    because a points filter reduces their number before sending to the brute cross product.

%% Preprocessing and errors check


if nargin~=4
    error('Inputs number must be 4 -> (qx,qy,x,y)')
end

if size(x,2)>1 || size(y,2)>1 || size(qx,2)>1 || size(qx,2)>1
    error('Inputs must be [Nx1] vectors, [1xN] vectors or array are not supported')
end
if length(x)~=length(y)
    error('x and y must have the same length')
end

if length(qx)~=length(qy)
    error('qx and qy must have the same length')
end




if size(qx,2)>1;
    qx=qx';
    qy=qy';
end

%close the polygon
if not(x(1)==x(end)) || not(y(1)==y(end))
    x(end+1)=x(1);
    y(end+1)=y(1);
end



Nq=length(qx);%numberof query points
Nc=length(x);%numberof convex hull points

if Nc<10%there are a small number of chull points


    %% Dot product algorithm Inspired by John D'Errico
    % this one can be vectorized easier so for a small number of edges
    % is faster

    % We want to test if:  dot((x - p),nrmls) >= 0
    % If so for all faces of the hull, then x is inside
    % the hull. Change this to dot(x,nrmls) >= dot(p,nrmls)
    %     fprintf('Dot algorithm\n')



    nrmls=[-y(2:end)+y(1:end-1),(x(2:end)-x(1:end-1))];%normals
    l=realsqrt(sum(nrmls.^2,2));
    zero=l<1e-10;%checking for zero length
    l(zero)=1;
    if any(zero)
        warning('Double points detected check inputs and results')
         nrmls(zero,:)=[];
        x(zero)=[];
        y(zero)=[];
        l(zero)=[]; 

    end
   
    nrmls(:,1)=nrmls(:,1)./l;%normalized normals
    nrmls(:,2)=nrmls(:,2)./l;
    nrmls(zero,:)=0;%put zero to avoid degenerancy







    %centre of polygon
    C=[sum(x)/Nc,sum(y)/Nc];
    % ensure the normals are pointing inwards
    if nrmls(1,1)*x(1)+nrmls(1,2)*y(1)>=nrmls(1,1)*C(1)+C(2)*nrmls(1,2)
        nrmls = -nrmls;
    end

    pN = sum(nrmls.*[x(1:end-1),y(1:end-1)],2);%dot product between points and normals

    % test, be careful in case there are many points
    in = repmat(false,Nq,1);
    % if nrmls is too large, we need to worry about the
    % dot product grabbing huge chunks of memory.
    memblock = 1e6;
    blocks = max(1,floor(Nq/(memblock/(Nc-1))));
    reppN = repmat(pN,1,length(1:blocks:Nq));%replicate to vectorize operation
    for i = 1:blocks
        j = i:blocks:Nq;
        if size(reppN,2) ~= length(j),
            reppN = repmat(pN,1,length(j));
        end
        in(j) = all((nrmls*[qx(j),qy(j)]' -  reppN) >=0,1)';
    end

    return

elseif Nq<500000%there are a small number of query points


    %% Brute Cross product algorithm
    %     fprintf('Brute Cross algorithm\n')

    pb=zeros(4,1);%Polygon for rapid point esclusion inclusion
    toll=[inf;-inf;-inf;inf];%tollerances for building the Polygon

    %now we just find 4 of the 8 points of the polygon
    %this are the points of the bounding box of the chull

    for i=1:Nc


        if  y(i)<toll(1)% min y
            pb(2,1)=x(i);pb(2,2)=y(i);
            toll(1)=y(i);
            idminy=i;%id of minimum y
        end


        if  y(i)>toll(2)
            pb(2,1)=x(i);pb(6,2)=y(i);%max y
            toll(2)=y(i);
            idmaxy=i;%id of maximumy
        end
        if  x(i)>toll(3)
            pb(3,1)=x(i);pb(3,2)=y(i);%max x
            toll(3)=x(i);
        end
        if  x(i)<toll(4)
            pb(4,1)=x(i);pb(4,2)=y(i);%min x
            toll(4)=x(i);
        end


    end


    % Starting edge intersection algorithom

    %reshape the chull vector ,put the minum y in firstposition
    %this makes more eficient the query point search
    x=[x(idminy:end);x(1:idminy-1);x(idminy)];
    y=[y(idminy:end);y(1:idminy-1);y(idminy)];

    %sort the query point in y direction
    [qy,sindex]=sort(qy);
    qx=qx(sindex);





    c=1;%query point search start from y
    while qy(c)< toll(1)%find the first valur with y>ymin
        c=c+1;
    end

    %going up
    Ne=abs(idmaxy-idminy);%number of edges between idmin and idmax

    in=false(Nq,1);


    %y grow up looping
    for i=1:Ne
        p1=i;%id of the edge under analsis
        p2=i+1;

        while c<=Nq && qy(c)<=y(p2)%Analyze all the quary points with  y(p1)<y<=y(p2)
            if  qx(c)<toll(2) && qx(c)> toll(4)
                %cross product between query point and current
                in(c)=((x(p2)-qx(c))*(y(p1)-qy(c))-(x(p1)-qx(c))*(y(p2)-qy(c)))<=0;
            end
            c=c+1;%next point

        end

    end

    %Now the same but with decreasing y
    c=Nq;
    for i=Ne:Nc
        p1=i;
        p2=i+1;
        while c>0 && qy(c)>=y(p2)%Analyze all the quary points with  y(p1)<y<=y(p2)

            if in(c) && qx(c)< toll(2) && qx(c)> toll(4)
                %cross product between query point and current edge
                in(c)=((x(p2)-qx(c))*(y(p1)-qy(c))-(x(p1)-qx(c))*(y(p2)-qy(c)))<=0;
            end
            c=c-1;%next point

        end

    end

    %reindexing due to delete process and sorting
    in(sindex)=in;
    return


else %Points are too many we need a filtering

    %% Cross product algorithm with filtering
    %     fprintf('Filtering Cross algorithm\n')


    pb=zeros(8,1);%Polygon for rapid point esclusion inclusion
    toll=[inf;inf;-inf;-inf;-inf;-inf;-inf;inf];%tollerances for point esclusion


    %now we just find the bounding box +
    %max(x+y),min(x+y),max(x-y),min(x-y)
    %this is the polygon
    for i=1:Nc
        if x(i)+y(i)<toll(1)% down left
            pb(1,1)=x(i);pb(1,2)=y(i);
            toll(1)=x(i)+y(i);
        end

        if  y(i)<toll(2)% min y
            pb(2,1)=x(i);pb(2,2)=y(i);
            toll(2)=y(i);
            idminy=i;
        end
        if x(i)-y(i)>toll(3)%down right
            pb(3,1)=x(i);pb(3,2)=y(i);
            toll(3)=x(i)-y(i);
        end
        if  x(i)>toll(4)
            pb(4,1)=x(i);pb(4,2)=y(i);%max x
            toll(4)=x(i);
        end
        if x(i)+y(i)>toll(5)%top right
            pb(5,1)=x(i);pb(5,2)=y(i);
            toll(5)=x(i)+y(i);
        end
        if  y(i)>toll(6)
            pb(6,1)=x(i);pb(6,2)=y(i);%max y
            toll(6)=y(i);
            idmaxy=i;
        end

        if  -x(i)+y(i)>toll(7)%top left
            pb(7,1)=x(i);pb(7,2)=y(i);
            toll(7)=-x(i)+y(i);
        end
        if  x(i)<toll(8)
            pb(8,1)=x(i);pb(8,2)=y(i);%min x
            toll(8)=x(i);
        end


    end

    %simplified rectangle boundaries
    %the polygon is too complicated is better to take a rectangle
    %inscribed in it
    Mx=min(pb([3,5],1));%max x coordinate
    My=min(pb([5,7],2));%max y coordinate
    mx=max(pb([1,7],1));%max x coordinate
    my=max(pb([1,3],2));%max y coordinate

    %Now we exclude all the points  which we are sure they are in or out
    index=1:Nq;
    %This points are in
    in=((qx<=Mx & qx>=mx & qy<=My & qy>=my));%points inside the rectangle are in

    out=(qx> toll(4) | qx< toll(8) | qy> toll(6) | qy< toll(2) );%points outside thebounding box are out

    %the others point must pass the edge intersection check
    %but now should be a minor number of points
    out=(in | out);%these are not outside it is just not to create a new logical vector

    index(out)=[];%index of survivors
    qx=qx(~out);%coordinates of survivors
    qy=qy(~out);
    Nq=length(qx);%new number of query points



    %% Starting edge intersection algorithom

    %reshape the chull vector ,put the minum y in firstposition
    x=[x(idminy:end);x(1:idminy-1);x(idminy)];
    y=[y(idminy:end);y(1:idminy-1);y(idminy)];
   
    %sort the query point in y direction
    [qy,sindex]=sort(qy);
    qx=qx(sindex);

    c=1;%query point iterator

    Ne=abs(idmaxy-idminy);%number of edges between ymin and ymax
    in1=false(Nq,1);

    % For each edge test the points with  y(p1)<y<=y(p2)
    %y grow up looping ->going up
    for i=1:Ne
        p1=i;%index of the chull edge
        p2=i+1;
        while c<=Nq && qy(c)<=y(p2)   %for all the points y(p1)<y<=y(p2)
            
            %cross product between query point and current edge
            in1(c)=((x(p2)-qx(c))*(y(p1)-qy(c))-(x(p1)-qx(c))*(y(p2)-qy(c)))<=0;
            c=c+1;%next query point
        
        end

    end
    c=Nq;

    %Now the same but with decreasing y
    for i=Ne:Nc
        p1=i;
        p2=i+1;
        while c>0 && qy(c)>=y(p2)
            if in1(c)%Points marked as out can not be in any more
                %cross product between query point and current edge
                in1(c)=((x(p2)-qx(c))*(y(p1)-qy(c))-(x(p1)-qx(c))*(y(p2)-qy(c)))<=0;
            end
            c=c-1;%next query point

        end

    end

    %reindexing due to delete process and sorting
    in(index(sindex))=in1;
    return


end

end


