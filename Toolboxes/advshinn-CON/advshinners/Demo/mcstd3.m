clc; disp('Nichols Chart support utilities:'); disp(' ');
disp('The Nichols chart is created using Nichgrid.'); 
help nichgrid;
disp('Example is Figure 7.37 (f0737 in figures subdirectory)'); 
disp(' '); disp('Press any key to display the grid.'); pause;
a = -[.25:.25:1 2 5 10:10:170 179.99];
b = [-24 -18 -12 -9 -7 -5:-1 -.5:.25:.5 1:5 7 9 12];
[x,y] = nichgrid([-360 0 -24 36],a,b,3);
for ii = 1:length(b);
  text(x(1,ii)-12,min(36,y(1,ii)),[num2str(b(ii)) ' db']);
end;
for ii = [1 length(a)-3*(0:5)];
  text(x(ii,1),-24,num2str(a(ii)));
  text(-360-x(ii,1),-24,num2str(-360-a(ii)));
end;
% meta demo3
pause; clear a b x y ii;

clc; disp('Adding to the grid the following transfer function:');
disp('    11.7*(1+0.58s)/(s(1+0.05s)(1+0.1s)(1+1.74s)) ');
disp(' '); disp('Press any key to display the plot.'); pause;
num = 11.7*[.58 1]; den = [conv([.05 1],conv([.1 1],[1.74 1])) 0];
[mag,ph] = bode(num,den,logspace(-1,2));
hold on; plot(ph,20*log10(mag)); hold off;
w = [.5 1 2 5 7 9 12]; [mag,ph] = bode(num,den,w);
hold on; plot(ph,20*log10(mag),'*g');
for ii = 1:length(w);
  text(ph(ii),20*log10(mag(ii)),['w = ' num2str(w(ii))]);
end;
% meta demo3
pause; clear w mag ph ii;

clc; disp(' '); disp('The maximum closed loop response is found using WpMp.');
help wpmp;
disp('Press any key to display the plot.'); pause;
[wp,mp] = wpmp(num,den); [wpmag,wpph] = bode(num,den,wp);
hold on; plot(wpph,20*log10(wpmag),'*r'); hold off;
text(wpph,20*log10(wpmag),['Wp = ' num2str(wp) ', Mp = ' num2str(mp) ' db']);
% meta demo3
pause; clear num den wp mp wpmag wpph;
