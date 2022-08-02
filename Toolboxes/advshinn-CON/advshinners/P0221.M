num =  19*conv([0.5 1],[0.05 1]);
den = [conv(conv([1 1],[0.1 1]),conv([0.001 1],[0.001 1])) 0];
w = logspace(-2,2);
disp('Num'); disp(num); disp('Den'); disp(den);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
if (isempty(wcg)), gm = Inf; wcg = NaN; end;
if (isempty(wcp)), pm = NaN; wcp = NaN; end;
disp('Gm'); disp(gm); disp('Wcg'); disp(wcg);
disp('Pm'); disp(pm); disp('Wcp'); disp(wcp);
%
clf; hold off; sbplot(221);
semilogx(w,db,'-',w,0*w,'-'); grid; frz_axis; hold on;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
semilogx([wcp wcp],[0 -200],'-b');
text(wcp,0,['W = ' num2str(wcp)]);
% semilogx([wcg wcg],[-gmdb 0],'-b');
% text(wcg,-gmdb,[' G.M. = ' num2str(gmdb)]);
%
hold off; sbplot(223);
semilogx(w,ph,'-',w,0*w-180,'-'); grid; frz_axis; hold on;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
% semilogx([wcg wcg],[-180 -5000],'-b');
% text(wcg,-180,['W = ' num2str(wcg)]);
semilogx([wcp wcp],[0 pm]-180,'-b');
text(wcp,pm-180,['P.M. = ' num2str(pm)]);
hold off;
%
hold off; sbplot(122);
[wp,mp] = wpmp(num,den); mpdb = 20*log10(mp);
disp('Mp'); disp(mpdb); disp('Wp'); disp(wp);
v = polyval(num,sqrt(-1)*w)./polyval(den,sqrt(-1)*w);
vv = 20*log10(abs(v./(1+v)));
semilogx(w,vv,[w(1) wp wp],[mpdb mpdb vv(length(vv))]);
text(w(1),mpdb,[' MP = ',num2str(mpdb),'db @ wp = ',num2str(wp)]);
