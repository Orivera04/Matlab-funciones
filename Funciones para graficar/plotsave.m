function plotsave(wex,wfd,pefd,wfe,pefem)
%
% function plotsave(wex,wfd,pefd,wfe,pefem)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function plots errors in frequencies 
% computed by two approximate methods.
%
% wex        - exact frequencies
% wfd        - finite difference frequencies
% wfe        - finite element frequencies
% pefd,pefem - percent errors by both methods
%
% User m functions called:  none
%----------------------------------------------

% plot results comparing accuracy 
% of both frequency methods
w=[wex(:);wfd(:);wfd]; 
wmin=min(w); wmax=max(w);
n=length(wex); wht=wmin+.001*(wmax-wmin); 
j=1:n;
 
semilogy(j,wex,'k-',j,wfe,'k--',j,wfd,'k:')
title('Cantilever Beam Frequencies')
xlabel('frequency number')
ylabel('frequency values')
legend('Exact freq.','Felt. freq.', ...
       'Fdif. freq.',2); figure(gcf) 
disp(['Press [Enter] for a frequency ',...
      'error plot']), pause 
print -deps beamfrq1 

plot(j,abs(pefd),'k--',j,abs(pefem),'k-')
title(['Cantilever Beam Frequency ' ...
       'Error Percentages'])
xlabel('frequency number') 
ylabel('percent frequency error') 
legend('Fdif. pct. error','Felt. pct. error',4)
figure(gcf)
disp(['Press [Enter] for a transient ',...
'response calculation'])
pause
print -deps beamfrq2