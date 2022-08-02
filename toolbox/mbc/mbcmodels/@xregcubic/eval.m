function y= eval(m,X);
% XREGCUBIC/EVAL evaluate multivariate polynomial
%
% y= eval(m,X);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.4 $  $Date: 2004/02/09 07:45:20 $



nf= nfactors(m);
c= double(m);
if isempty(c)
    y= zeros(size(X,1),1);
elseif ~isempty(X)
   if nf==1
      % 1-d polynomial
      y(1:size(X,1),1)= c(end);
      for i=length(c)-1:-1:1
         y= y.*X + c(i);
      end
      
      
   else
      % reorder if necessary
      if any(diff(m.reorder)~=1)
         X= X(:,m.reorder);
      end
      N= m.N;
      m.N(m.MaxInteract+1:end)=0;
      
      % use mex evaluation for speed
      [y,p]= cubiceval_mex(c,m.N,m.MaxInteract,X');
      
      nx= sum(N(m.MaxInteract+1:end));
      if nx>0
         % terms with no interactions
         Xm=X(:,1:N(m.MaxInteract+1));
         Xi= Xm.^m.MaxInteract;
         for i=m.MaxInteract+1:length(N)
            Xi= Xi.*Xm;
            for j=1:N(i)
               p= p + 1;
               y= y + c(p)*Xi(:,j);
            end
         end
      end
      
   end
else
    % correctly dim'ed output
   y = ones(0,1);
end


% this is obsolete m code now replaced by cubiceval_mex

function [y,p]= i_ceval(m,X);

c= double(m);
% Evaluate using nested multiplication
p=1;  % coefficient index
% Constant Term
y(1:size(X,1),1)= c(1);
N= m.N;


for i=1:N(1)
   % 1st order terms
   p=p+1;
   Yi = c(p);
   for j=i:N(2)
      % 2nd order terms
      p=p+1;
      
      Yj = c(p);
      for k=j:N(3)
         % 3rd order terms
         p=p+1;
         Yj= Yj + c(p)*X(:,k);
      end
      
      Yi= Yi + X(:,j).*Yj; 
   end
   y = y + X(:,i).*Yi;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_recurse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,p]= i_recurse(m,X,y,c,lvl,p,st)
% m     xregcubic model
% X     inputs to evaluate
% y     partial evaluation
% c     model coefficients
% lvl   current level of recursion (= current poly order)
% p     current position in coefficient array
% st    starting value for loop

mord= m.MaxInteract;
for i=st:m.N(lvl)
	p=p+1;
	if lvl < mord
		% increase poly order (level)
		[Yi,p]= i_recurse(m,X,c(p),c,lvl+1,p,i);
	else
		% constant
		Yi= c(p);
	end
	% add nested term
	y = y + X(:,i).*Yi;
end