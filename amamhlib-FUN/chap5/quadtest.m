function [L,G,names]=quadtest(secs)
%
% [L,G,names]=quadtest(secs)
% ~~~~~~~~~~~~~~~~~~~~~~
% This program compares the accuracy and
% computation times for several integrals
% evaluated using quadl and gcquad
%
% secs  - the number of seconds each integration
%         is repeated to get accurate timing. The
%         default value is 60 seconds.
% L,G   - matrices with columns containing
%         results from quadl and from gcquad.
%         The matrices are structured as:
%         [IntegralValue,PercentError,...
%         FunctionEvaluations,ComputationSeconds]
% names - character matrix with rows
%         describing the functions 
%         which were integrated
%
% User functions called: ftest, gcquad
%---------------------------------------------

global nvals

if nargin==0, secs=60; end

fprintf('\nPRESS RETURN TO BEGIN COMPUTATION > ')
pause

% Summary of the five integrands used
names=strvcat('sqrt(x)','log(x)','humps(x)',...
              'exp(10*x).*cos(10*pi*x)',...
              'cos(20*pi*x-20*sin(pi*x))');
fprintf(['\n\nINTEGRATION TEST COMPARING',...
      ' FUNCTIONS QUADL AND GCQUAD\n'])
fprintf('\nThe functions being integrated are:\n')
disp(names)          
          
% Compute exact values of integrals          
exact=[2/3; -1; quadl(@humps,0,1,1e-12);
      real((exp(10+10*pi*i)-1)/(10+10*pi*i));
      besselj(20,20)];    
  
% Find time to make a loop and call the clock
nmax=5000; nclock=0; t0=clock;
while nclock<nmax
    nclock=nclock+1; tclock=etime(clock,t0);
end
tclock=tclock/nclock; 
          
% Evaluate each integral individually. Repeat
% the integrations for secs seconds to get
% accurate timing.  Save results in array L.
L=zeros(5,4); tol=1e-6; e=exact; warning off;
for k=1:5 
  nquad=0; tim=0; t0=clock;
  while tim<secs
    [v,nfuns]=quadl(@ftest,0,1,tol,[],k);
    nquad=nquad+1; tim=etime(clock,t0);
  end
  tim=tim/nquad-tclock; pe=100*(v/e(k)-1);
  L(k,:)=[v,nfuns,pe,tim];
end
warning on;

% Obtain time to compute base points and weight
% factors for a Gauss formula of order 100
nloop=100; t0=clock;
for j=1:nloop
  [dumy,bp,wf]=gcquad([],0,1,100,1);
end
tbpwf=etime(clock,t0)/nloop;

% Perform the Gauss integration using a
% vector integrand. Save results in array G
          
ngquad=0; tim=0; t0=clock; 
while tim<secs
  v=ftest(bp,6)*wf;
  ngquad=ngquad+1; tim=etime(clock,t0);
end
tim=tim/ngquad+tbpwf-tclock; pe=100*(v./e-1);
G=[v,100*ones(5,1),pe,tim/5*ones(5,1)];

format short e
disp(' ')
disp('            Results Using Function quadl')
disp(...
'    Integral     Function      Percent   Computation')
disp(...
'     values     evaluations     error     seconds')
disp(L)
disp('            Results Using Function gcquad')
disp(...
'   Integral     Function      Percent    Computation')
disp(...
'    values     evaluations     error       seconds')
disp(G)
format short
disp(['(Total time using quadl)/',...
      '(Total time using gcquad)'])
disp(['equals ',...
       num2str(sum(L(:,end))/sum(G(:,end)))])
disp(' ')
 
%=============================================          
          
function y=ftest(x,n)
% Integrands used by function quadl
global nvals
switch n
case 1, y=sqrt(x); case 2, y=log(x); 
case 3, y=humps(x); 
case 4, y=exp(10*x).*cos(10*pi*x);    
case 5, y=cos(20*pi*x-20*sin(pi*x));
otherwise
  x=x(:)'; y=[sqrt(x);log(x);humps(x);
              exp(10*x).*cos(10*pi*x);
              cos(20*pi*x-20*sin(pi*x))];
end
if n<6, nvals=nvals+length(x);  
else, nvals=nvals+5*length(x); end

%============================================= 

% function [val,bp,wf]=gcquad(func,xlow,...
%                    xhigh,nquad,mparts,varargin)
% See Appendix B
