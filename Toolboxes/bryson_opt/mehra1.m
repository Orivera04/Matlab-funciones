% Script mehra1.m; Mehra & Davis's soln (1972) of problem 3 w. inequality
% constraint, formulated by Jacobsen and Lele (1969), using FMINCON; 
%                                                                 1/10/02
tic
p=-ones(1,20); ub=-.2*p; lb=1.2*p; t=0:.05:1; t1=.025:.05:.975;
optn=optimset('display','iter','maxiter',30);
p=fmincon('mehra1_f',p,[],[],[],[],lb,ub,'mehra1_c',optn);
[f,x,u]=mehra1_f(p); c=mehra1_c(p); x1=x(1,:); x1b=(x1(2:21)+x1(1:20))/2;
%
figure(1); clf; subplot(311); plot(t,x(1,:),t1,-c+x1b,'r--'); grid; 
ylabel('x_1'); axis([0 1 -.6 .1]); 
title('Mehra-Davis Inequality Constraint Problem 3')
subplot(312); plot(t,x(2,:)); grid; ylabel('x_2'); axis([0 1 -1.2 .2]);
subplot(313); plot(t1,u); grid; axis([0 1 -3 8]); ylabel('u'); 
xlabel('Time')
toc

