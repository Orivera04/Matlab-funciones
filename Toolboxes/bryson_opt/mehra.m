% Script mehra.m; Mehra & Davis's soln (1972) of problem 2 w. inequality
% constraint, formulated by Jacobsen and Lele (1969), using FMINCON; 
%                                                                 1/10/02
tic
p=-ones(1,20); ub=-.2*p; lb=1.2*p; t=0:.05:1; t1=.025:.05:.975;
optn=optimset('display','iter','maxiter',30);
p=fmincon('mehra_f',p,[],[],[],[],lb,ub,'mehra_c',optn);
[f,x,u]=mehra_f(p); c=mehra_c(p); x2=x(2,:); x2b=(x2(2:21)+x2(1:20))/2;
%
figure(1); clf; subplot(311); plot(t,x(1,:)); grid; ylabel('x_1')
axis([0 1 -.25 0]); title('Mehra-Davis Inequality Constraint Problem 2')
subplot(312); plot(t,x(2,:),t1,-c+x2b,'r--'); grid; ylabel('x_2'); 
axis([0 1 -1.1 .1]); subplot(313); plot(t1,u); grid; axis([0 1 -4 12]);
ylabel('u'); xlabel('Time')
toc

