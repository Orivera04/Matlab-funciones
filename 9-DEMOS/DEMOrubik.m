function DEMOrubik(sparse)
% Plot the two faithful representations for the
% subgroup of the 2x2x2 Rubik's cube dealing with
% 180-degree turns.
if nargin == 0
	sparse = 0;
end
disp('|');
disp('|  RUBIK REPRESENTATIONS');
disp('|');
disp('|  This shows two faithful representations of');
disp('|  the 2x2x2 Rubik cube with half turns.');
disp('|  The 3 turns t(blue), r(red), f(green)');
disp('|  are represented by either plane reflections,');
disp('|  (left) or line reflections (right).');
disp('|');
clf;
subplot(1,2,1); rubik(-1,sparse); axis off; GAview([0 10]);
subplot(1,2,2); rubik( 1,sparse); axis off; GAview([0 10]);
b = axis;
subplot(1,2,1); axis(b);
subplot(1,2,2); axis(b);
GAorbiter;

function rubik(s,sparse)
% draws faithful representation with sign s
% sparse = 1: sparse draw
% sparse = 0: draw all
R = unit(((e2-e3)^e1)/I3);
T = unit(((e3-e1)^e2)/I3);
F = unit(((e1-e2)^e3)/I3);
% choice of point affects figure severely
e = unit(e1+0.3*(e2-2*e3));
%e = unit(F+R);
% e = unit(F);
% e = unit(F -0.3*R+0.2*T);
%clf;
GAtext(1.1*e,'e');
r = s*R*e/R; GAtext(1.1*r,'r');
t = s*T*e/T; GAtext(1.1*t,'t');
f = s*F*e/F; GAtext(1.1*f,'f');
%
tr = T*R*e/(T*R); GAtext(1.1*tr,'tr');
rt = R*T*e/(R*T); GAtext(1.1*rt,'rt');
rf = R*F*e/(R*F); GAtext(1.1*rf,'rf');
fr = F*R*e/(F*R); GAtext(1.1*fr,'fr');
ft = F*T*e/(F*T); GAtext(1.1*ft,'ft');
tf = T*F*e/(T*F); GAtext(1.1*tf,'tf');
%
rfr = s*(R*F*R)*e/(R*F*R); GAtext(1.1*rfr,'rfr');
rtr = s*(R*T*R)*e/(R*T*R); GAtext(1.1*rtr,'rtr');
tft = s*(T*F*T)*e/(T*F*T); GAtext(1.1*tft,'tft');
frt = s*(F*R*T)*e/(F*R*T); GAtext(1.1*frt,'frt');
ftr = s*(F*T*R)*e/(F*T*R); GAtext(1.1*ftr,'ftr');
trf = s*(T*R*F)*e/(T*R*F); GAtext(1.1*trf,'trf');
tfr = s*(T*F*R)*e/(T*F*R); GAtext(1.1*tfr,'tfr');
rtf = s*(R*T*F)*e/(R*T*F); GAtext(1.1*rtf,'rtf');
rft = s*(R*F*T)*e/(R*F*T); GAtext(1.1*rft,'rft');
%
rfrt = (R*F*R*T)*e/(R*F*R*T); GAtext(1.1*rfrt,'rfrt');
rftr = (R*F*T*R)*e/(R*F*T*R); GAtext(1.1*rftr,'rftr');
rftf = (R*F*T*F)*e/(R*F*T*F); GAtext(1.1*rftf,'rftf');
rtrf = (R*T*R*F)*e/(R*T*R*F); GAtext(1.1*rtrf,'rtrf');
rtfr = (R*T*F*R)*e/(R*T*F*R); GAtext(1.1*rtfr,'rtfr');
%
% GAview([20 10]); axis off;
if sparse==1
   c2='w';
   DrawPolygon({r,rtr,t},c2);
DrawPolygon({tf,rftf,rtfr},c2);
DrawPolygon({f,ftr,frt},c2);
DrawPolygon({rfrt,rf,rftr},c2);
DrawPolygon({rft,rfr,trf},c2);
DrawPolygon({rtrf,ft,fr},c2);
DrawPolygon({tft,tfr,rtf},c2);
DrawPolygon({e,tr,rt},c2);
else
c1 = 'w';
c2 = 'y';
c3 = 'w';
if s== -1
DrawPolygon({e,r,rt,rtr,tr,t},c2);
DrawPolygon({rf,rfr,rfrt,trf,rftr,rft},c2);
DrawPolygon({f,fr,frt,rtrf,ftr,ft},c2);
DrawPolygon({tf,tfr,rtfr,rtf,rftf,tft},c2);
%
DrawPolygon({e,t,ft,f,tf,tft},c1);
DrawPolygon({r,rftf,rtf,rf,rft,rt},c1);
DrawPolygon({rfrt,rfr,rtfr,tfr,fr,frt},c1);
DrawPolygon({rftr,trf,rtrf,ftr,tr,rtr},c1);
%
DrawPolygon({tf,tfr,fr,f},c3);
DrawPolygon({tft,e,r,rftf},c3);
DrawPolygon({rft,rftr,rtr,rt},c3);
DrawPolygon({trf,rtrf,frt,rfrt},c3);
DrawPolygon({rf,rtf,rtfr,rfr},c3);
DrawPolygon({t,ft,ftr,tr},c3);
else
DrawPolygon({r,rtr,t},c2);
DrawPolygon({tf,rftf,rtfr},c2);
DrawPolygon({f,ftr,frt},c2);
DrawPolygon({rfrt,rf,rftr},c2);
DrawPolygon({rft,rfr,trf},c2);
DrawPolygon({rtrf,ft,fr},c2);
DrawPolygon({tft,tfr,rtf},c2);
DrawPolygon({e,tr,rt},c2);
%
DrawPolygon({fr,rtr,tf,rft},c3);
DrawPolygon({f,rftr,tfr,rt},c3);
DrawPolygon({t,rtfr,ftr,rf},c3);
DrawPolygon({t,rtfr,ftr,rf},c3);
DrawPolygon({e,frt,rftf,trf},c3);
DrawPolygon({e,frt,rftf,trf},c3);
DrawPolygon({tr,rfr,ft,rtf},c3);
DrawPolygon({r,rfrt,tft,rtrf},c3);
%
DrawPolygon({r,fr,rtr},c1);
DrawPolygon({r,fr,rtrf},c1);
DrawPolygon({t,rtr,rtfr},c1);
DrawPolygon({t,rfrt,rf},c1);
DrawPolygon({tf,rtfr,rtr},c1);
DrawPolygon({tf,rft,trf},c1);
DrawPolygon({tf,trf,rftf},c1);
DrawPolygon({rftf,ftr,rtfr},c1);
DrawPolygon({rftf,frt,ftr},c1);
DrawPolygon({f,frt,rt},c1);
DrawPolygon({f,rftr,rf},c1);
DrawPolygon({f,rf,ftr},c1);
DrawPolygon({rfrt,r,t},c1);
DrawPolygon({fr,ft,rft},c1);
DrawPolygon({rfr,e,trf},c1);
DrawPolygon({e,rt,frt},c1);
DrawPolygon({e,rfr,tr},c1);
DrawPolygon({rt,tr,tfr},c1);
DrawPolygon({tr,rtf,tfr},c1);
DrawPolygon({ft,rfr,rft},c1);
DrawPolygon({tft,rfrt,rftr},c1);
DrawPolygon({rtf,rtrf,ft},c1);
DrawPolygon({tfr,tft,rftr},c1);
DrawPolygon({tft,rtf,rtrf},c1);
end
end
if s== -1
   draw(pi*R/I3,'r');
   draw(pi*F/I3,'g');
   draw(pi*T/I3,'b');
else
   draw(1.2*R,'r');
   draw(1.2*F,'g');
   draw(1.2*T,'b');
   draw(-1.2*R,'r');
   draw(-1.2*F,'g');
   draw(-1.2*T,'b');
end
disp('|  END OF DEMO');
disp('|');

