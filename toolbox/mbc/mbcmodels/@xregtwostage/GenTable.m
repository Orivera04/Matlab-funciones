function  [Y,X,y,Xcol]= GenTable(TS,x,varargin)
% MODEL/GENTABLE generate an N-D table of model evaluations
%
% [Y,X,y,Xg]= GenTable(m,x,varargin)
%   x is a cell array of values for 
%   
%   Y   N-D array of model evaluations
%   X   N-D array of evaluation points
%   y   vector model evaluation 
%   Xg  nxNf array of evaluation points

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:11 $




nl= nlfactors(TS);
cs= cellfun('prodofsize',x);

xtemp=x;
for i=1:length(x);
   % do the coding on each entry individually as this is 
   % computationally much cheaper
   x{i}= code(TS,x{i}(:),i);
end

if any(cs(1:nl)>1)
   % Local factor grid
   
   [y,Xg,Xl]= i_LocalGrid(TS,x);
   
   
   % make sure local covariates have dimension of 1
	IT2= nl>1 & ~all(InputFactorTypes(TS.Local)==1);
   if IT2
      [xtemp{2:nl}]=deal(0);
   end
   if length(x)>1
      % Generate N-D grid for evaluation
      [X{1:length(x)}]=ndgrid(xtemp{:});
   else
      X=x;
   end
   % Change into NxNg table 
   Xcol= zeros(prod(size(X{1})),length(X));
   for i=1:length(X)
      Xcol(:,i)= X{i}(:);
   end
   if IT2
      % fills out other local (cpfactors
      Xcol(:,2:nl)= repmat(Xl(:,2:nl),size(Xg,1),1);
      for i=2:nl
         X{i}= reshape(Xcol(:,i),size(X{i}));
      end
   end
   
else
   if length(x)>1
      % Generate N-D grid for evaluation
      [X{1:length(x)}]=ndgrid(x{:});
   else
      X=x;
   end
   
   % Change into NxNg table 
   Xcol= zeros(prod(size(X{1})),length(X));
   for i=1:length(X)
      Xcol(:,i)= X{i}(:);
   end
   
   y= eval(TS,Xcol);
   y= yinv(TS,y);
   
   if nargout>1 
      if length(x)>1
         % Generate N-D grid for evaluation
         [X{1:length(x)}]=ndgrid(xtemp{:});
      else
         X=xtemp;
      end
   end      
end


if ~isreal(y)
   y(abs(imag(y))>1e-6)=NaN;
   y= real(y);
end

if length(size(X{1}))>1
   Y= reshape(y,size(X{1}));
end


function [y,Xg,Xl] = i_LocalGrid(TS,x)

nl= nlfactors(TS);
nf= nfactors(TS);

if length(x)>nl+1
   % Generate N-D grid for evaluation
   [XG{1:nf-nl}]=ndgrid(x{nl+1:end});
else
   XG= x(nl+1);
end
Xg= zeros(prod(size(XG{1})),length(XG));
for i=1:length(XG)
   Xg(:,i)= XG{i}(:);
end

IT2= nl>1 & ~all(InputFactorTypes(TS.Local)==1);

if nl==1 | IT2 
	Xl= zeros(length(x{1}),nl);
	for i= 1:nl
		Xl(:,i)= x{i}(:);
	end
else
	[XL{1:nl}] = ndgrid(x{1:nl});
	Xl= zeros(prod(size(XL{1})),nl);
	for i= 1:nl
		Xl(:,i)= XL{i}(:);
	end
end

y= eval(TS,{Xl,Xg});
y= yinv(TS,y);
