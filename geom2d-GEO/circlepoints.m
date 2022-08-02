function pts=circlepoints(xCenter,yCenter,radius)

% pts=circlepoints(xCenter,yCenter,radius)
%
%This is a simple function that returns the points in a circle with center
%xCenter,yCenter with radius 'radius'
%This is a function intended to return coordinates of a pixel image
%so it will work well only for integer values of xCenter, yCenter and radius

%Suresh Joel, June 24, 2002

if(nargin<3)
   error('Too few arguements');
end

if(rem(xCenter,1)~=0 | rem(yCenter,1)~=0 | rem(radius,1)~=0)
   warning('Increments are by whole numbers and using non-integers might not produce desired results');
end

x = 0;
y = radius;
p = 1 - radius;

pts=[];
pt=GetPoints(xCenter, yCenter, x, y);
pts=[pts pt];
while(x<y)
   x=x+1;
   if(p < 0)
      p =p + (2*x + 1);
   else
      y=y-1;
      p = p+ (2*(x-y) + 1);
   end
   pt=GetPoints(xCenter, yCenter, x, y);
   pts=[pts;pt];
end

pts=sortrows(pts);
prevsz=length(pts)+1;        %Dummy number to make it go atleast once through the loop
while(length(pts)~=prevsz)
   prevsz=length(pts);
   n=1;
   while(n<length(pts)),
      if(pts(n,:)==pts(n+1,:))
         pts(n,:)=[];
      end
      n=n+1;
   end
end


function pt=GetPoints(xCenter,yCenter,x,y)
pt(1,:)=[xCenter + x, yCenter + y];
pt(2,:)=[xCenter - x, yCenter + y];
pt(3,:)=[xCenter + x, yCenter - y];
pt(4,:)=[xCenter - x, yCenter - y];
pt(5,:)=[xCenter + y, yCenter + x];
pt(6,:)=[xCenter - y, yCenter + x];
pt(7,:)=[xCenter + y, yCenter - x];
pt(8,:)=[xCenter - y, yCenter - x];   