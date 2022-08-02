function plterror(xmr,t2,h2,x2,T2,H2,X2,...
         t4,h4,x4,T4,H4,X4,tr2,Tr2,tr4,Tr4)
% plterror(xmr,t2,h2,x2,T2,H2,X2,...
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%          t4,h4,x4,T4,H4,X4,tr2,Tr2,tr4,Tr4)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Plots error measures showing how different
% integrators and time steps compare with 
% the exact solution using modal response.
%
% User m functions called:  none
%----------------------------------------------

% Compare the maximum error in any component
% at each time with the largest deflection
% occurring during the complete time history 
maxd=max(abs(xmr(:)));
er2=max(abs(x2-xmr)')/maxd;
Er2=max(abs(X2-xmr)')/maxd;
er4=max(abs(x4-xmr)')/maxd;
Er4=max(abs(X4-xmr)')/maxd;

plot(t2,er2,'-',T2,Er2,'--');
title(['Solution Error For Implicit ',...
       '2nd Order Integrator']);
xlabel('time');
ylabel('solution error measure');
lg1=['h= ', num2str(h2),  ...
     ', relative cputime= ', num2str(tr2)];
lg2=['h= ', num2str(H2),  ...
     ', relative cputime= ', num2str(Tr2)];
legend(lg1,lg2,2); figure(gcf); 
disp('Press [Enter] to continue'); pause
% print -deps deislne2

plot(t4,er4,'-',T4,Er4,'--');
title(['Solution Error For Implicit ',...
       '4th Order Integrator']);
xlabel('time');
ylabel('solution error measure');
lg1=['h= ', num2str(h4),  ...
     ', relative cputime= ', num2str(tr4)];
lg2=['h= ', num2str(H4),  ...
     ', relative cputime= ', num2str(Tr4)];
legend(lg1,lg2,2); figure(gcf); 
% print -deps deislne4 