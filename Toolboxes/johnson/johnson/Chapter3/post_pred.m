function sample=post_pred(Mb,data)
% POSTPRED Posterior predictive distribution of standard deviation(y*)
%       for conduct dataset in Chapter 3

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

N=size(data,1);
p=size(data,2);
y=data(:,1); n=data(:,2); x=data(:,3:p);
m=size(Mb,1);

sample=zeros(m,1);

for i=1:m
   lp=(x*Mb(i,:)');
   p=exp(lp)./(1+exp(lp));
   y=sum((rand(N,4)<(p*ones(1,4)))')'; 
   sample(i)=std(y);
end
