function wiggle(X)
% WIGGLE  Dynamic matrix multiplication.
%   wiggle(X) wiggles the 2-by-n matrix X.
%   Eg: wiggle(house)
%       wiggle(hand)

clf
shg
thetamax = 0.1;
delta = .025;
t = 0;
stop = uicontrol('string','stop','style','toggle');
while ~get(stop,'value')
   theta = (4*abs(t-round(t))-1) * thetamax;
   G = [cos(theta) sin(theta); -sin(theta) cos(theta)];
   dot_to_dot(G*X);
   drawnow
   t = t + delta;
end
set(stop,'string','close','value',0,'callback','close(gcf)')
