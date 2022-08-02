% frame rotation
% Given a frame {e_i} and a rotated version {f_i},
% reconstruct the rotor.
% See Lasenby and Doran, handout 5
clf;
E1=e1;
E2=unit(e1+e2);
E3=unit(e2+2*e3);
draw(E1,'b'); GAtext(1.1*E1,'e_1');
draw(E2,'b'); GAtext(1.1*E2,'e_2');
draw(E3,'b'); GAtext(1.1*E3,'e_3');
axis off;
axis([-1 1 -1 1 -1 1]);
title('Here is a frame \{e_i\} ...');
GAprompt;
% original rotation parameters and rotor
a = (0.2*e1+0.3*e2-0.5*e3);
a = a/norm(a);
phi = 9/4*pi;
bivangle = I3*a*phi;
R = gexp(-bivangle/2);
% rotated frame
f1 = R*E1/R;
f2 = R*E2/R;
f3 = R*E3/R;
draw(f1,'g'); GAtext(1.1*f1,'f_1');
draw(f2,'g'); GAtext(1.1*f2,'f_2');
draw(f3,'g'); GAtext(1.1*f3,'f_3');
title('... and a second rotated frame \{f_i\}.');
axis([-1 1 -1 1 -1 1]);
GAprompt;
title('What was the rotation?');
GAorbiter(-40,10);
GAprompt;
% reciprocal frame of E:
IE = E1^E2^E3;
rE1 = (E2^E3)/IE;
rE2 = (E3^E1)/IE;
rE3 = (E1^E2)/IE;
% the trick
r = 1+f1*rE1+f2*rE2+f3*rE3;
rotplane = -2*grade(sLog(r),2);
title('rotor  \propto  1+f_1e^1+f_2e^2+f_3e^3');
axisangle = rotplane/I3;
% we are really done and could go to the drawplanearc now
% prefer to draw rotation axis: quicker!
angle = norm(axisangle);
sign=1;
if angle > pi 
   angle = pi-angle;
   sign=-1
end
ax = sign*unit(axisangle);
draw(ax,'r');
axis([-1 1 -1 1 -1 1]);
GAprompt;
draw(sign*rotplane,'w'); % why is a sign needed here?
drawplanearc(E1,rotplane,'r');
drawplanearc(E2,rotplane,'r');
drawplanearc(E3,rotplane,'r');
axis([-1 1 -1 1 -1 1]);
GAorbiter(-360,20);