function [lx,ly]=rope(x,y,level)
%ROPE Generate coordinates of an ellipse enclosing data.                
%       [LX,LY]=ROPE(X,Y,LEVEL) returns coordinates [LX,LY] of an ellipse
%       enclosing LEVEL % of the coordinate pairs in column vectors X and Y. 
%
%       The major axis of the ellipse is the straight line regression of
%       Y on X. The centre of the ellipse is the mean of X and Y and the
%       ratio of the major to minor axes is the ratio of the standard
%       deviations of the data points' distances from the centre, projected
%       onto the major and minor axes.
%
%       The following example illustrates usage:
%
%       x=randn(1000,1)+5;
%       y=x*5+randn(1000,1)*2;
%       plot(x,y,'x')
%       hold
%       [x90,y90]=rope(x,y,90);
%       plot(x90,y90,'-')
%       [x50,y50]=rope(x,y,50);
%       plot(x50,y50,'r-')
%       [p,s]=polyfit(x,y,1);
%       yval=polyval(p,x);
%       plot(x,yval,'k-');
%       
%       Now use AXIS EQUAL:
%        
%       axis equal
%
%       The major axis of the ellipse is on the regression line.
%
%
%  TIP: Ellipse will LOOK distorted if AXIS EQUAL is not used for graph.
%
%       1997; (c) R P Maguire; Paul Scherrer Institute



if (length(x) > size(x,1))
   error('Use column vectors to specify coordinates');
end;


if ((level < 1) | (level > 99))
        error('level must be between 1 and 99');
end;



% least squares straight line fit for prinicpal axes


xmean=mean(x);
ymean=mean(y);
x=x-xmean;
y=y-ymean;
[regression,s]=polyfit(x,y,1);  


angle=atan(regression(1));


[polar(:,1),polar(:,2)]=cart2pol(x,y);
polar(:,1)=polar(:,1)-angle;
[rot_x,rot_y]=pol2cart(polar(:,1),polar(:,2));


width=std(rot_x);
height=std(rot_y);
aspect_ratio=height/width;


max_rx=max(abs(rot_x));
max_ry=max(abs(rot_y));


if (max_rx < max_ry)
        max_rx=max_ry/aspect_ratio;
end


rx_inc=max_rx/100;
rx=rx_inc;


enclosed=0;


while( (rx <= max_rx) & (enclosed < level))


        ry=rx*aspect_ratio;


        enclosed=100*length( find( ...
        ((rot_x ).^2/rx^2) ...
        + ((rot_y ).^2/ry^2) < 1 ...
         ) )/length(rot_x);


rx=rx+rx_inc;
end


if rx >= max_rx
        warning(' Contour at limits of distribution ');
end;


th=0:2*pi/100:2*pi;


rot_lx=rx*cos(th);
rot_ly=ry*sin(th);


[l_polar(:,1),l_polar(:,2)]=cart2pol(rot_lx',rot_ly');


l_polar(:,1)=l_polar(:,1)+angle;
[lx,ly]=pol2cart(l_polar(:,1),l_polar(:,2));
lx=lx+xmean;
ly=ly+ymean; 