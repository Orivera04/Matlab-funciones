function post=bayes(prior,like,data)
%
% BAYES Bayes' rule for a independent sequence of outcomes.
%	POST=BAYES(PRIOR,LIKE,DATA) returns a matrix POST of sequential 
%	posterior probabilities, where PRIOR is a column of prior
%	probabilities, LIKE is the corresponding likelihood matrix,
%	and DATA is a vector containing the sequential observations.

n=length(data);
k=length(prior);
post=zeros(n,k);
current=prior;

for i=1:n
   ps=current.*like(:,data(i));
   ps=ps/sum(ps);
   current=ps;
   post(i,:)=ps';
end
  


