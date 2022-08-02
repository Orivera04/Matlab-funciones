% Surface plot for XOR FIS
blackbg;
subplot(2,2,1);
xorfis = readfis('xor.fis');
gensurf(xorfis);
view([-20 55]);
set(gca, 'box', 'on');
%frot3d on
