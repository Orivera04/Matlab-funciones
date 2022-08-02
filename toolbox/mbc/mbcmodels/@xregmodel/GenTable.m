function  [Y,Xout,y,Xg]= GenTable(m,x,varargin)
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


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:51:06 $

n= length(x);
xn=x;
for i=1:n;
   % do the coding on each entry individually as this is 
   % computationally much cheaper
   x{i}= code(m,x{i}(:),i);
end

s= cellfun('prodofsize',x);
MaxSize= min(10000,prod(s));

ITypes= InputFactorTypes(m) ;
IT2=  ~all(ITypes==1);
if n>1
   X=x;
   if IT2 
       % transient inputs
       X= i_IT2Grid(x,ITypes,s);
       if nargout>1
           Xout= i_IT2Grid(xn,ITypes,s);
       end
       MaxSize= numel(X{1});
   else
       % Generate N-D grid for evaluation
       X=x;
       if any(s>1)
           [X{s>1}] = ndgrid(x{s>1});
       end
       if nargout>1
           Xout= xn;
           if any(s>1)
               [Xout{s>1}] = ndgrid(xn{s>1});
           end
       end
   end
else
   X=x;
   Xout= xn;
end
   


Xg =zeros(MaxSize,n);
for i= find(s==1)
    % setup scalar inputs
    Xg(:,i)= x{i};
end

if IT2
    Nevals= 1;
    y= zeros(numel(X{1}),1);
else
    y= zeros(prod(s),1);
    Nevals= floor(prod(s)/MaxSize);
end
    
    
for i= 1:Nevals
    % do evaluations in blocks of MaxSize
    ind= (MaxSize*(i-1)+1:MaxSize*i)';
    for j=find(s>1)
        % non scalar inputs
        Xg(:,j)= X{j}(ind);
    end
    y(ind)= eval(m,Xg);
end
if ~IT2 & MaxSize*i<prod(s) 
    % last block
    ind= (floor(prod(s)/MaxSize)*MaxSize+1:prod(s))';
    Xg= Xg(1:length(ind),:);
    for j=find(s>1)
        % non scalar inputs
        Xg(:,j)= X{j}(ind);
    end
    y(ind)= eval(m,Xg);
end



if ~isempty(m.yinv)
   y= m.yinv(y);
end

if ~isreal(y)
   y(abs(imag(y))>1e-6)=NaN;
   y= real(y);
end

if length(s)>1 && ~IT2
   Y= reshape(y,s);
else
    Y= y;
end



function X= i_IT2Grid(x,ITypes,s);

X= x;
if sum(ITypes==1)>1
    [X{s>1 & ITypes==1}] = ndgrid(x{s>1 & ITypes==1});
    MaxSize= numel(X{1});
    sx= size(X{1});
    it2ind= find(ITypes>1);
    for i=it2ind
        X{i}= reshape(X{i},size(X{i}));
    end
    for i= it2ind
        X{i}= reshape( repmat(x{i}(:),MaxSize/length(x{i}),1) , sx ) ;
    end
else
    for i=1:length(x);
        X{i}= X{i}(:);
    end
end