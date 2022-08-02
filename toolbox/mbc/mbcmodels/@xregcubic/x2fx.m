function FX= x2fx(m,X)
% xregcubic/X2FX  regression X matrix for xregcubic
%
% FX= x2fx(m,X)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:44 $


nf= nfactors(m);
% Check X is correct size
if size(X,2)~=length(m.reorder)
   error(sprintf('An Nx%d matrix is required for evaluating',length(m.reorder)));
end


if nf==1
	% 1-d polynomial
	n=size(m,1)-1;
	% Construct Vandermonde matrix.
	FX= zeros(size(X,1),size(m,1));
	FX(:,1) = 1;
	for j = 1:n;
		FX(:,j+1) = X.*FX(:,j);
	end
else
	% reorder if necessary
	if any(diff(m.reorder)~=1)
		X= X(:,m.reorder);
	end
	N= m.N;
	m.N(m.MaxInteract+1:end)=0;
	if m.MaxInteract<=3
		% cubic algorithm
		FX= i_cubic(m,X);
	else
		% recusive algorithm for higher orders
		FX= zeros(size(X,1),size(m,1));
		FX = i_recurse(m,X,FX,1,1);
	end
	
	% non interactive terms
	nx= sum(N(m.MaxInteract+1:end));
	if nx>0
		p = size(FX,2)-nx;
		Xm=X(:,1:N(m.MaxInteract+1));
		Xi= Xm.^m.MaxInteract;
		for i=m.MaxInteract+1:length(N)
			Xi= Xi.*Xm;
			for j=1:N(i)
				p=p+1;
				FX(:,p)= Xi(:,j);
			end
		end
	end
	
end













function FX= i_cubic(m,X);

% Ones Vector made here

% Constant Term
FX= zeros(size(X,1),size(m,1));
Xi= FX;
FX(:,1)= 1; % ones(size(X,1),1);       

fxpos=2;
for i=1:m.N(1)         
   % First Order Terms
   
   xipos= 0;
   for j=i:m.N(2)      
      % 2nd Order Terms (includes 3rd order for efficiency)
      % Xj = [ Ones X(:,j:m.N(3))];
      %        [ X(:,j) , X(:,j).^2 , X(:,j).*X(:,j+1) , ... , X(:,j).*X(:,m.N(3))]
      % Augment to Xi
      
      xipos= xipos+1;
      Xj= X(:,j);
      Xi(:,xipos)= Xj;
      for k=j:m.N(3)
         xipos= xipos+1;
         Xi(:,xipos)= Xj.*X(:,k);
      end 
      % Xi= [Xi  X(:,j*ones(1,size(Xj,2))).*Xj]; 
      % Note Xj only includes constant, 1st and 2nd order terms
   end
   % multiply Xi by X(:,i) to make 1st, 2nd and 3rd order terms
   % Augment to FX
   Xii= X(:,i);
   FX(:,fxpos) = Xii;
   fxpos=fxpos+1;
   for k= 1:xipos
      FX(:,fxpos) = Xii.*Xi(:,k);
      fxpos=fxpos+1;
   end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_recurse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [FX,p]= i_recurse(m,X,FX,lvl,st)
% m     xregcubic model
% X     inputs to evaluate
% FX    partial regression matrix 
% lvl   current level of recursion (= current poly order)
% st    starting value for loop

mord= m.MaxInteract;
FX(:,1) =  1;
p=1;
for i=st:m.N(lvl)
	Xi= X(:,i);
	p=p+1;
	FX(:,p) = Xi;
	if lvl < mord
		% next level
		[FXI,ni]= i_recurse(m,X,FX,lvl+1,i);
		% the first column of FXI is all ones so skip this
		for j=2:ni
			% multiply by Xi and place in correct column
			p=p+1;
			FX(:,p)= Xi.*FXI(:,j);
		end
	end
end

