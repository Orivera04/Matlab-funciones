function tess=QuickerHull(P)
%  QuickerHull N-D Convex hull.
%     K = QuickerHull(X) returns the indices K of the points in X that 
%     comprise the facets of the convex hull of X. X is an m-by-n array
%     representing m points in n-D space. If the convex hull has p facets
%     then K is p-by-n. 
%  
%     CONVHULLN first attemps to clear points that can not be part of the
%     convex hullthan  uses Qhull. For dimensions higher than six and
%     points number less than 1000 no filtering is done.
%  
%
%   
%  
%     Example:
%
%           X=rand(1000,3);
%           tess=QuickerHull(X);
% 
%
%  
%     See also convhulln, convhull, qhull, delaunayn, voronoin, 
%              tsearchn, dsearchn.
%
%Author: Luigi Giaccari(giaccariluigi@msn.com)
%Created:04/01/2009
%Last Update 08/012009
%
       
       
%erroro check
if nargin>1
    error('only one input supported')
end

[N,dim]=size(P);

if dim>1
    if dim>5 || N<1000  
        %run the normal convhull for high dimensions and a few points
         tess=convhulln(P);
          return
    end
   
    else
        error('Dimension of points must be>1');
end


%%Filtering points

ncomb=2^dim;%number of combinations among the dimensions
comb=ones(ncomb/2,dim);%preallocate combination
forbregion=zeros(2^dim,1);


%get all combinations using binary logic
for i=2:dim    
    c=2^(dim-i);
    comb(:,i)=repmat([ones(c,1);-ones(c,1)],2^(i-2),1);
end
comb=[comb;-comb];%use  combinations simmetry

%for each combination get forbidden region point
for i=1:ncomb/2
    vect=zeros(N,1);
     for j=1:dim
       vect=vect+P(:,j)*comb(i,j);
     end
     [foo,forbregion(i)]=max(vect);
      [foo,forbregion(i+ncomb/2)]=min(vect);
end

%get the simplyfied forbidden region
%for each dimension get upper and lower limit

deleted=true(N,1);
for i=1:dim
    
    %get combination with positive dimension
    index=comb(:,i)>0;
    
    %upper limit
    simplregion=P(forbregion(index),i);
    upper=min(simplregion);
    
     %lower limit
     simplregion=P(forbregion(~index),i);
     lower=max(simplregion);
     
     deleted=deleted & P(:,i)<upper & P(:,i)>lower;

end

%delete points id that can not be part of the convhull
index=1:N;
index(deleted)=[];


%Run QuickHull with the survivors
tess=convhulln(P(~deleted,:));


%reindex
tess=index(tess);


end
