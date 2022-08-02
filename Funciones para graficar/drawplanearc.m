function drawplanearc(a,Iphi,color,resolution,long)
% draw arc of rotation from a over Iphi
% - a: the vector
% - Iphi: bivector angle 
% - color
% - resolution in degrees (default pi/16)
if nargin < 4
   resolution = pi/16;
end
%if nargin < 5
%   long = 1;
%end
step = max(4,ceil(norm(Iphi)/resolution));

R = gexp(-Iphi/step/2);
%if long == -1;   
%   R = -reverse(R);
%end
rR = reverse(R);
pt{1}=a;
for i=1:step
   pt{i+1} = grade(R*pt{i}*rR,1);
end
DrawPolyline(pt,color);
iarrow = ceil((step+1)/2);
DrawPolyline({pt{iarrow},pt{iarrow}+gexp(-Iphi/norm(Iphi)*pi/6)*unit(pt{iarrow}-pt{iarrow+1})*norm(a)/10},color);
