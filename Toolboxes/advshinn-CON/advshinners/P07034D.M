num=[1]; den=[1 2 0]; t=0:.1:10;
clf; sbplot(211);
 [k45,s45] = rootangl(num,den,180-45);
s1 = step(k45*num,poly_add(k45*num,den),t);
 [k60,s60] = rootangl(num,den,180-60);
s2 = step(k60*num,poly_add(k60*num,den),t);
plot(t,s1,'-',t,s2,'-'); grid; xlabel('Time'); ylabel('Amplitude');
title('Uncompensted');
text(1,.5,[' K=' num2str(k45) ' (Problem 7.3)']);
text(2,1.15,[' K=' num2str(k60) ' (Problem 7.4)']);
%
sbplot(212);
num = conv(num,[1 .1]); den = conv(den,[1 .01]);
 [k45,s45] = rootangl(num,den,180-45); k45 = max(k45);
s3 = step(k45*num,poly_add(k45*num,den),t);
 [k60,s60] = rootangl(num,den,180-60); k60 = max(k60);
s4 = step(k60*num,poly_add(k60*num,den),t);
plot(t,s3,'-',t,s4,'-'); grid; xlabel('Time'); ylabel('Amplitude');
title('Compensated');
text(1.5,.65,['K=' num2str(k45) ' (Problem 7.3)']);
text(2,1.2,[' K=' num2str(k60) ' (Problem 7.4)']);
