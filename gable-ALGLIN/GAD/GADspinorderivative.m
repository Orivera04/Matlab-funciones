% |
% |  THE DERIVATIVE OF A SPINOR
% |
i = unit(e1^(e2/2+e3/3)); %/  % rotation plane 
n = 16;                   %/  % number of rotation steps
phi = i*2*pi/n;           %/  % rotation angle bivector
R = gexp(-phi/2); %/
a = e1-e2+e3;              % vector to be rotated
clf; %/
draw(i,'y'); %/
draw(a,'r'); GAtext(1.1*a,'a'); %/
axis off; %/
GAview([-30 30]); %/
axis([-1.1 1.1 -1.7 0.7 -0.5 2]) %/
% |
% |  Vector a and spinor plane 
% |
GAprompt; %/
% |
% |  Derivative is vector proportional to x.i
% |
title('constant i, then   \partial_t(e^{-i\phi/2} a e^{i\phi/2}) = (a \bullet i) \partial_t\phi'); %/
draw(inner(a,phi),'b'); %/
axis([-1.1 1.1 -1.7 0.7 -0.5 2]) %/
GAprompt; %/
% |
% |  Capable of locally rotating the vector a.
% |
for j=1:n %/
   anow = a; %/
   adernow = inner(anow,phi);  % derivative formula %/
   draw(anow,'r'); %/
   draw(adernow,'b'); %/
   DrawPolyline({anow-adernow/2,anow+adernow/2},'b'); %/
   axis([-1.1 1.1 -1.7 0.7 -0.5 2]) %/
	drawnow; %/
   a = R*anow/R; %/
end %/
GAorbiter(-360,10); %/
