% testvander.m
% script file to test vandermonde implementations

x=(1:20)';      % column vector for input data
m=20;               % highest power to compute


sf={'vander1','vander2','vander3','vander4','vander5','vander6'};
t=zeros(size(sf));

for k=1:length(t)
   tic
   for i=1:500
      eval(sf{k})
   end
   t(k)=toc;
end
tr=t/min(t)