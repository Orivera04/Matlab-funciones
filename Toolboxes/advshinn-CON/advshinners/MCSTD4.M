clc; disp('Root Locus support utilities:'); disp(' ');
disp('Certain CRITICAL values help us plot/evaluate the root locus accurately');
disp(' ');
% disp('Bld_rl   :');
disp('Rlaxis   :');
disp('Rlpoba   :');
disp('Rootmag  :');
disp('Rootangl :');
pause; clc;
disp('Example is Figure 6.60b (f0660b in figures subdirectory)');
disp(' '); disp(' G(s)H(s) = 1.6*K*(s+10)/(s(s+1)(s+4)(s+4)) ');
disp(' '); disp('or (in MATLAB notation)'); disp(' ');
disp('num = 1.6*[1 10];'); num = 1.6*[1 10]
disp('den = [conv([1 1],conv([1 4],[1 4])) 0];');
den = [conv([1 1],conv([1 4],[1 4])) 0]
disp(' '); disp('Press any key to display the root locus plot.'); pause;

clc; 
% disp('Bld_rl : Not yet done!');
axis([-14 4 -5 5]); plot([-14 4],[-5 5],'.'); axis([-14 4 -5 5]); 
hold on; rlocus(num,den); hold off; pause;
% meta demo4

clc; disp('The real axis portion of the plot is found using Rlaxis');
disp(' '); help rlaxis;
disp('realaxis = rlaxis(num,den);');
realaxis = rlaxis(num,den)
pause; clear realaxis;

clc; disp('The point of break-away/in is found using Rlpoba');
help rlpoba;
disp('[kbreak,sbreak] = rlpoba(num,den);');
[kbreak,sbreak] = rlpoba(num,den);
format short e; kbreak = kbreak, format short; sbreak = sbreak
disp('Press any key to display break away/in points'); pause;
hold on; plot(real(sbreak),imag(sbreak),'*'); hold off;
for ii = 1:length(sbreak)
  text(real(sbreak(ii)),imag(sbreak(ii)),[' K = ' num2str(kbreak(ii))]);
end;
% meta demo4
pause; clear kbreak sbreak ii;

clc; disp('The imaginary axis crossing is found using Rootangl at 90 degrees');
disp('This represents the location where the root locus becomes unstable');
help rootangl;
disp('[kimag,simag] = rootangl(num,den,90);');
[kimag,simag] = rootangl(num,den,90)
disp('Press any key to display imaginary axis crossings'); pause;
hold on; plot([simag; -simag],'*'); hold off;
for ii = 1:length(simag)
  text(real(simag(ii)),imag(simag(ii)),[' K = ' num2str(kimag(ii))]);
  text(real(simag(ii)),-imag(simag(ii)),[' S = ' num2str(-imag(simag(ii))) 'j']);
end;
% meta demo4
pause; clear kimag simag ii;

clc; disp('An arbitrary angle can be found using Rootangl');
disp('This represents a particular zeta in the discrete domain');
help rootangl;
disp('Choosing a damping of .707 (Corresponding to 45 degrees)');
disp('[k45,s45] = rootangl(num,den,90+45);');
[k45,s45] = rootangl(num,den,90+45)
disp('Press any key to display root locus on 45 degree angle'); pause;
hold on; plot(s45,'*'); plot([0 -100],[0 100],'g--'); hold off;
for ii = 1:length(s45)
  tt = [' K = ' num2str(k45(ii)) ' @ S = ' num2str(real(s45(ii)))];
  if (imag(s45(ii)) >= 0); tt = [tt '+']; end;
  tt = [tt num2str(imag(s45(ii))) 'j'];
  text(real(s45(ii)),imag(s45(ii)),tt);
end;
% meta demo4
pause; clear k45 s45 ii tt;

clc; disp('The unit circle crossing is found using Rootmag for unity (1),');
disp('Representing continuous domain location where the root locus becomes unstable');
help rootmag;
disp('[kcircle,scircle] = rootmag(num,den,1);');
[kcircle,scircle] = rootmag(num,den,1)
disp('Press any key to display root locus on the unit circle'); pause;
hold on; plot(scircle,'*'); plot(sin(0:.1:2*pi),cos(0:.1:2*pi),'g--'); hold off;
for ii = 1:length(scircle)
  tt = [' K = ' num2str(kcircle(ii)) ' @ S = ' num2str(real(scircle(ii)))];
  if (imag(scircle(ii)) >= 0); tt = [tt '+']; end;
  tt = [tt num2str(imag(scircle(ii))) 'j'];
  text(real(scircle(ii)),imag(scircle(ii)),tt);
end;
% meta demo4
pause; clear kcircle scircle ii tt;
clear num den;
