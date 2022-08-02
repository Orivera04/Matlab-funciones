% vort_ plots four vorticity plots in Figure CP-11
% in color plates.  The first two plots of stream functions
% are plotted by stream_.   Copyright S. Nakamura, 1995
clear; close;close;clg
fig3=figure(3)
set(fig3,'Position',[100,100,400,400] ,'NumberTitle','off', ...
   'Color',[0,0,0])

clf:clear
load vort_.dat
     ni=51;
     nj=51;
     s=1;
     for j=1:nj
         for i=1:ni
         x(i,j)=vort_(s,1);
         y(i,j)=vort_(s,2);
         p(i,j)=vort_(s,3);
         s=s+1;
     end;
     end;
q=zeros(p);
     for i=1:ni
         for j=1:nj
          xd(i,j)=x(i,nj-j+1);
         end ;
     end ;

     for j=1:nj
         for i=1:ni
          yd(j,i)=y(nj-j+1,i);
         end ;
     end ;

     v=[5.0 3.0 2.0 1.0 0.0 -1.0];
     c=contour(x,y,p,v);
     clabel(c,v)
%    title('vorticity contour  Re=400 (grid 51x51)')
     title('contour')
     xlabel('X') ;   ylabel('Y')

     axis('square')
%print vort1.ps -depsc

fig4=figure(4)
set(fig4,'Position',[515,100,400,400] ,'NumberTitle','off')

clf

pmax=max(max(p))
pmin=min(min(p))


if 1==1,
     for i=1:ni
         for j=1:nj
          q(i,j)=p(i,j);
          if p(i,j)<-1  , q(i,j)= -1 - (p(i,j)+1)/(pmin+1)/3 ; end
          if p(i,j)<-1  , p(i,j)= -1 - (p(i,j)+1)/(pmin+1)*3 ; end
          if p(i,j)>3 , q(i,j)= 3 + (p(i,j)-3)/(pmax-3)/9; end 
          if p(i,j)>3 , p(i,j)= 3 + (p(i,j)-3)/(pmax-3)*10; end 
         end ;
     end ;
end

pcolor(x,y,q)
colormap hsv;  caxis([-1.5 3.5])
axis('square')
shading interp
title('pcolor, shading interp, colormap hsv')
     xlabel('X') ;   ylabel('Y')
%print vort2.ps -depsc
disp 'HIT RETURN'
pause
fig5=figure(5)
set(fig5,'Position',[100,100,400,400] ,'NumberTitle','off')

pcolor(x,y,q)
colormap flag;
axis('square')

shading faceted
title('pcolor, shading faceted, colormap jet')
     xlabel('X') ;   ylabel('Y')
%print vort3.ps -depsc

fig6=figure(6)
set(fig6,'Position',[515,100,400,400] ,'NumberTitle','off')




%subplot(2,2,3)
surf(x,y,p,q)
colormap hsv;  
axis('square')
shading interp
title('surf, shading interp, colormap hsv')
     xlabel('X') ;   ylabel('Y')
%print vort4.ps -depsc





