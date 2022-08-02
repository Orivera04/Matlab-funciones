function GADspheretriangle1(a,b,c)
% The spherical triangle determined by 3 unit vectors
if nargin == 0
	up = {-e2,unit(e1-e2),unit(2*e1+e2+3*e3)};
else
   up = {a,b,c};
end
p = {0,0,0};
P = {0,0,0};
uP = {0,0,0};
color = {'r','g','b'};
label = {'a','b','c'};

% Given three unit vectors
clf;
%sphere;
%h = findobj('Type','surface');
%set(h,'FaceLighting','flat','EdgeColor',[1 1 1]);
%for i=0:2
%   drawgreatcircle(pi*up{mod(i,3)+1}^up{mod(i+1,3)+1}/norm(up{mod(i,3)+1}^up{mod(i+1,3)+1}),'k');
%end
for i=0:2
	%draw(up{i+1},'k'); 
	DrawPoint({up{i+1}},color{i+1}); GAtext(1.2*up{i+1},label{i+1},'k');
   drawarc(up{mod(i+1,3)+1},up{mod(i+2,3)+1},color{i+1},8);
   P{i+1}  = sLog(up{mod(i+1,3)+1}*up{mod(i+2,3)+1}); 
   uP{i+1} = grade(P{i+1}/norm(P{i+1}),2);
   %draw(P{i+1},color{i+1}); 
end
for i=0:2
   p{i+1} = grade(sLog(uP{mod(i+1,3)+1}*uP{mod(i+2,3)+1})*I3 ,1);
   draw(p{i+1},color{i+1}); 
   %DrawPoint({p{i+1}},color{i+1}); 
   %GAtext(1.2*P{i+1},label{i+1},color{i+1});
end


size = max(abs(axis));
axis([-size size -size size -size size]);
axis off;
GAview([10 30]);
shg;


function drawarc(a,b,color,step)
% draw arc between two vectors
% - a,b: the two vectors
% - color
% - step: number of steps
R = gexp(sLog(b/a)/step);
pt{1}=a;
for i=1:step
   pt{i+1} = grade(R*pt{i},1);
end
DrawPolyline(pt,color);
iarrow = ceil((step+1)/2);
plane = a^b/norm(a^b);
DrawPolyline({pt{iarrow},pt{iarrow}+gexp(-plane*pi/6)*unit(pt{iarrow}-pt{iarrow+1})*norm(a)/10},color);

function drawgreatcircle(B,color,step)
% draw great circle denoted by bivector B (giving attitude and area)
if nargin == 2
   step = 32;
end
random = pi*e1+exp(1)*e2+sqrt(2);
x = unit(grade(inner(random,B)*B,1))*sqrt(norm(B)/pi); % starting point
R = gexp(B/norm(B)*2*pi/step);
pt{1} = x;
for i=1:step
   pt{i+1} = grade(R*pt{i},1);
end
pt{step+2} = x;
DrawPolyline(pt,color);
