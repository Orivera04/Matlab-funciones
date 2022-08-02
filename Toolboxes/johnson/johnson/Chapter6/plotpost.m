function summaries=plotpost(Mb,plotsumm)
% PLOTPOSTS Summarizes posterior distribution for multivariate simulated sample
%
%       SUMMARIES=PLOTPOST(MB,PLOTSUMM) returns 5th, 50th, and 95th percentiles
%       of each column of the matrix of simulated values MB
%       If PLOTSUMM="y", the a errorbar graph of the summaries is displayed.
%-------------------------------------------------------------  
%  Jim Albert - June 15, 1998
%-------------------------------------------------------------

k=size(Mb,2); m=size(Mb,1);
if nargin<2, plotsumm='n';end

probs=[.05 .5 .95];
summaries=zeros(k,3);

cp=((1:m)-.5)/m;

for i=1:k
   summaries(i,:)=interp1(cp,sort(Mb(:,i)),probs);
end

if plotsumm=='y'
errorbar(1:k,summaries(:,2),summaries(:,2)-summaries(:,1),summaries(:,3)-summaries(:,2),'o')
end
