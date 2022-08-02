function chull=HowDoesItWork()
%Routine for a graphical explanation on how the algorithm works

%generate random numbers
x=rand(200,1);
y=rand(200,1);

%save for future plot
xsaved=x;
ysaved=y;

close all



N=length(x);


% plot
figure(1)
hold on
axis equal
title('Input points','fontsize',16)

plot(x,y,'k.')
id=1:N;
text(x,y,num2str(id'));
pause(4)

%quadrilater for point exclusion
pb=zeros(4,1);

%tollerances for point exclusion
toll=[inf;-inf;-inf;-inf];



%% Building the quadrilater
%we find the maximu aand minum for (x+y) and (x-y)
%the point inside this polygon will bw deleted.
%Delenting points costs time, generally slow down the algorithom for
%a small number of points, but make it faster for large models

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
% but it is easier and computational faster using a rectangle inscribed in
% it.

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


% plot
figure(1)
hold off
plot(0,0)
hold on
axis equal
title('After the filtering','fontsize',16)
plot(x,y,'k.')
id=1:N;
text(x,y,num2str(id'));
pause(4)

%sorting the survivors
[y,sindex] = sort(y);
x = x(sindex);


% plot
figure(1)
hold off
plot(0,0)
hold on
axis equal
title('Sorted in y direction','fontsize',16)
plot(x,y,'k.')
id=1:N;
text(x,y,num2str(id'));
pause(4)

%% Building the convex hull applying brute crossproduct algorithom
%The algorithom could have been started here but generally many points are
%deleted in the previsious process.
%now that the number of points should be greatly minor it is possible to apply a
%brute algorithom


tch=zeros(N,1);%temporay convex hull store
%this is a waste of memory but preallocation gives more speed





%This tries to treat colinear points in a different way
colinear=false;
if y(1)==y(2) || y(end)==y(end-1)
    %     warning('Colinear points Found')
    %     fprintf('\nYour data are a special case which in the past the program\n');
    %     fprintf('has shown a bug. This bug is supposed to be fixed\n' );
    %     fprintf('so please check the results \n'   );
    %     fprintf('and if something is wrong contact the author on matlab exchange\n');

    %count the number of ymin colinear points
    i=1;
    while y(i)==y(i+1)
        i=i+1;
    end
    if i>2
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

    figure(1)
    hold off
    plot(0,0)
    hold on
    title('Going up','fontsize',16)
    plot(x(tch(1:c)),y(tch(1:c)),'b-')
    %   plot([x(p1),x(p2)],[y(p1),y(p2)],'-b')
    plot([x(p2),x(p3)],[y(p2),y(p3)],'r-')
    axis equal
    plot(x,y,'k.')
    id=1:N;
    text(x,y,num2str(id'));
    pause(0.1);

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


%



%first half done let's make the second going down


p1=c-1;
p1=tch(p1);
p2=tch(c);
if colinear || p1==i-1;
    i=i-1;
end

while i>1
    %cross product indexing
    % p1   p2   p3
    %<------.-------->
    % c-1   c   i-1

    p3=i-1;


    figure(1)
    hold off
    plot(0,0)
    hold on
    title('Going down','fontsize',16)
    plot(x(tch(1:c)),y(tch(1:c)),'b-')
    %   plot([x(p1),x(p2)],[y(p1),y(p2)],'-b')
    plot([x(p2),x(p3)],[y(p2),y(p3)],'r-')
    axis equal
    plot(x,y,'k.')
    id=1:N;
    text(x,y,num2str(id'));
    pause(0.1);

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
        %go back
        c=c-1;
        p2=p1;
        p1=tch(c-1);


    end
end


% plot
figure(1)
hold off
plot(0,0)
hold on
axis equal
title('The Convex Hull','fontsize',16)
plot(x(tch((1:c))),y(tch((1:c))),'g-','linewidth',4)
N=length(xsaved);
id=1:N;
plot(xsaved,ysaved,'k.')
text(xsaved,ysaved,num2str(id'));
xlabel('The End','fontsize',16)


% Re-index to undo the sorting and deleting
chull=index(sindex(tch((1:c))))';%convexhull

end





