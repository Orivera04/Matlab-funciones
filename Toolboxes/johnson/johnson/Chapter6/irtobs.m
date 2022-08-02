function [p,mids]=irtobs(data,th_m,bins);
%
% irtobs - computes observed proportion of correct
%          for groups of latent ability
%
% command:	[p,mids]=irtobs(data,th_m,bins)
%
% input:		data - matrix of response data
%				th_m - estimates at abilities for all people
%				bins - N x 2 matrix that contains bins 
%
% output:	p - observed proportion matrix
%				mids - vector of midpoints of bins

mids=mean(bins')';
k=size(data,2);
N=length(mids);

p=zeros(N,k);

for j=1:N
   ii=find((th_m>bins(j,1))&(th_m<bins(j,2)));
   p(j,:)=mean(data(ii,:));
end

for j=1:N
   ii=find((th_m>bins(j,1))&(th_m<bins(j,2)));
   [j length(ii)]
end
  