function mattimer(norder,ktimes,secs)
%
% mattimer(norder,ktimes,secs)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
if nargin==0
    norder=100; ktimes=10; secs=30;
end
fprintf('\nMATRIX MULTIPLY TIMING TEST\n\n')

disp('Get results for a single timer call')

multimer(norder,secs,1); t=zeros(ktimes,3);

secs=max(secs,30); if ktimes==0, return, end

disp('Get results for several timer calls')
for j=1:ktimes
    [t(j,3),t(j,1),t(j,2)]=multimer(norder,secs);
end
T=(max(t)-min(t))./mean(t);

disp(...
'      tfast           tslow           ratio')
for j=1:ktimes
    fprintf('%13.4e   %13.4e   %13.4e\n',t(j,:))
end
disp(' '), disp(...
'Time variation defined by (max(t)-min(t))/mean(t)')
disp(['Variation for tfast = ',num2str(T(1))])
disp(['Variation for tslow = ',num2str(T(2))])

%============================================

function [ratio,tfast,tslow]=multimer(...
	                            norder,secs,doprint)
% [ratio,tfast,tslow]=multimer(...
%                               norder,secs,doprint)

% This function compares the times to perform a
% matrix multiply using the built-in matrix multiply
% and the slow method employing scalar triple looping.
% The ratio of compute times illustrates how much
% faster compiled and vectorized matrix operations 
% can be compared to similar calculations using
% interpreted code with scalar looping. 
% norder - order of the test matrices used. The 
%          default for norder is 100.
% secs   - number of seconds each computation is run
%          to get accurate timing. The default (and
%          minimum value) is thirty seconds.
% doprint- print intermediate results only if this
%          variable is given a value
% ratio  - ratio of slow to fast multiply times
% tfast  - time in seconds to perform a multiply
%          using the built-in precompiled matrix
%          multiply
% tslow  - time in seconds to perform a multiply
%          by triple loop method
%
% User m functions called: matmultf matmults
%
% Typical results obtained on a Dell Dimension
% XPS B733r computer with 128MB of RAM gave the 
% following values using  
% MATLAB Version 6.5.0.180913a (R13)
% >> mattimer(100,0,60);
%
% MATRIX MULTIPLY TIMING TEST
%
% Fast multiply takes 0.0046768 secs.
% Megaflops = 427.6406
% 
% Slow multiply takes 0.10275 secs.
% Megaflops = 19.4653
% 
% tslow/tfast = 21.9694
% 
% >> mattimer(1000,0,60);
%
% MATRIX MULTIPLY TIMING TEST
%
% Fast multiply takes 4.1266 secs.
% Megaflops = 484.6578
% 
% Slow multiply takes 135.99 secs.
% Megaflops = 14.707
% 
% tslow/tfast = 32.9543
% >> 

% Find time to make a loop and call the clock
nmax=5e3; nclock=0; tstart=cputime;
while nclock<nmax
    tclock=cputime-tstart; nclock=nclock+1;
end
% Time to do one loop and call the timer
tclock=tclock/nclock; 

if nargin<3, doprint=0; else, doprint=1; end
if nargin<2, secs=30; end; secs=max(secs,30);
if nargin==0, norder=100; end
a=rand(norder,norder); b=rand(norder,norder);

if doprint
   disp(' ')
   disp('The repeated multiplication of matrices')
   disp(['of order ',num2str(norder),...
         ' may take considerable time.'])
   disp(' ')
end

% Time using intrinsic multiply function
pack; tfast=0; nfast=0; tstart=cputime; 
while tfast<secs
    cf=matmultf(a,b); nfast=nfast+1;
    tfast=cputime-tstart;
end
tfast=tfast/nfast-tclock; 

% Time using Fortran style, triple for:next looping
pack; tslow=0; nslow=0; tstart=cputime; 
while tslow<secs
    cs=matmults(a,b); nslow=nslow+1;
    tslow=cputime-tstart;
end

tslow=tslow/nslow-tclock; ratio=tslow/tfast;
mflops=inline('num2str(2*n^3/1e6/t)','n','t');
if doprint
   disp(['Fast multiply takes ',...
           num2str(tfast),' secs.'])
   disp(['Megaflops = ',...
           mflops(norder,tfast)]), disp(' ')
   disp(['Slow multiply takes ',...
           num2str(tslow),' secs.'])
   disp(['Megaflops = ',...
           mflops(norder,tslow)]), disp(' ')
   disp(['tslow/tfast = ',...
           num2str(tslow/tfast)]), disp(' ')
end

%===========================================

function v=matmultf(a,b)
% v=matmultf(a,b). Matrix multiply using
% precompiled function in MATLAB
v=a*b;

%===========================================

function v=matmults(a,b)
% v=matmults(a,b). Matrix multiply using
% Fortran like triple loop
n=size(a,1); m=size(b,2); K=size(a,2);
v=zeros(n,m);
for i=1:n
   for j=1:m
      t=0;
      for k=1:K
         t=t+a(i,k)*b(k,j);
      end
      v(i,j)=t;
   end
end
