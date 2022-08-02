% stream_ plots stream line contour and velocity vectors.
% See Figure CP-11 (top two plots) in color plates, 
% see also Figure 2.16 
% Needs a data set, stream_.dat
% Copyright S. Nakamura, 1995
clf;clear;close;close
close
fig1=figure(1);
clf
set(fig1,'Position',[100,100,400,400] , ...
    'NumberTitle','off' , ...
    'Name','Plot os Stream function','Color',[0,0,0])
load stream_.dat
     ni=51;
     nj=51;
     s=1;
     u=zeros(ni);v=u;
     for j=1:nj
         for i=1:ni
         x(i,j)=stream_(s,1);
         y(i,j)=stream_(s,2);
         p(i,j)=stream_(s,3);
         s=s+1;
     end;
     end;

     for j=1:nj
         for i=1:ni
         u(j,i)=0;
         v(j,i)=0;
         if i>1 & i<ni & j>1 & j<nj
            u(j,i) = (p(j+1,i)-p(j-1,i))/(y(j+1,i)-y(j-1,i));
            v(j,i) =-(p(j,i+1)-p(j,i-1))/(x(j, i+1)-x(j, i-1));
         end
     end;
     end;
    for j=1:nj
         for i=1:ni
          yd(j,i)=y(nj-j+1,i);
         end ;
     end ;
     clf
     L=[-0.00577:-0.00577:-0.054,  0, 0.0001, 0.00005];
     c=contour(x,y,p,L);
     clabel(c)
     title('stream function  Re=400 (grid 51x51)')
%    title('contour(x, y, p)')
     xlabel('X ')
     ylabel('Y ')

     axis('square')

fig2=figure(2); 
clf
set(fig2,'Position',[515,100,400,400] ,...
     'NumberTitle','off', 'Color',[0,0,0])
     quiver(x(1:2:ni,1:2:ni),y(1:2:ni,1:2:ni),u(1:2:ni,1:2:ni), ...
            v(1:2:ni,1:2:ni),4, 'g')
     axis('square')
     title('quiver(x, y, u, v, scale, `g`)')
     xlabel('X ')
     ylabel('Y ')








