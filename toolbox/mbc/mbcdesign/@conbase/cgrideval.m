function [Y,Xout]= cgrideval(c,x,m);
%CONBASE/CGRIDEVAL 
%
% [Y,Xout]= cgrideval(c,x,m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 06:56:55 $



n= length(x);
xn=x;

if nargin>2
    % code the data to [-1,1]
    [LB,UB,mdlrange] = range(m);
    mid= (LB+UB)/2;
    for i= 1:length(x);
        x{i}= 2*(x{i}-mid(i))./mdlrange(i);
    end    
end

s= cellfun('prodofsize',x);
MaxSize= min(10000,prod(s));

if n>1
    % Generate N-D grid for evaluation
    X=x;
    if any(s>1)
        [X{s>1}] = ndgrid(x{s>1});
    end
    if nargout>1
        Xout= xn;
        [Xout{s>1}] = ndgrid(xn{s>1});
    end
else
   X=x;
   X{1}= X{1}(:);
   Xout= xn;
end
   

y= zeros(prod(s),1);
Xg =zeros(MaxSize,n);
for i= find(s==1)
    % setup scalar inputs
    Xg(:,i)= x{i};
end


for i= 1:floor(prod(s)/MaxSize)
    % do evaluations in blocks of MaxSize
    ind= (MaxSize*(i-1)+1:MaxSize*i)';
    for j=find(s>1)
        % non scalar inputs
        Xg(:,j)= X{j}(ind);
    end
    y(ind)= ceval(c,Xg);
end
if MaxSize*i<prod(s)
    % last block
    ind= (floor(prod(s)/MaxSize)*MaxSize+1:prod(s))';
    Xg= Xg(1:length(ind),:);
    for j=find(s>1)
        % non scalar inputs
        Xg(:,j)= X{j}(ind);
    end
    y(ind)= ceval(c,Xg);
end



if length(s)>1
   Y= (reshape(y,s));
else
    Y= y;
end


    