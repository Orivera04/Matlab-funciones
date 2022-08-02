function xy = Isomap(D,ndims,mode); 

% isomap - computes Isomap embedding using the algorithm of 
%             Tenenbaum, de Silva, and Langford (2000). 
%
%   xy = Isomap(D,ndims,mode); 
%
%   'D' is either a local distance matrix (with Inf when no connection),
%       or a global one (i.e. it contains already computed geodesic
%       distances between pair of points).
%   OPTIONAL:
%   'ndims' is the number of output dimensions (default =2).
%   'mode' is either 'local' (set if D is a local distance matrix)
%       or 'global' (set if D is a geodesic distance).
%       
%
%   Modifie by Gabriel Peyré
%
%   This code is modified from :
%
%    BEGIN COPYRIGHT NOTICE
%
%    Isomap code -- (c) 1998-2000 Josh Tenenbaum
%
%    This code is provided as is, with no guarantees except that 
%    bugs are almost surely present.  Published reports of research 
%    using this code (or a modified version) should cite the 
%    article that describes the algorithm: 
%
%      J. B. Tenenbaum, V. de Silva, J. C. Langford (2000).  A global
%      geometric framework for nonlinear dimensionality reduction.  
%      Science 290 (5500): 2319-2323, 22 December 2000.  
%
%    Comments and bug reports are welcome.  Email to jbt@psych.stanford.edu. 
%    I would also appreciate hearing about how you used this code, 
%    improvements that you have made to it, or translations into other
%    languages.    
%
%    You are free to modify, extend or distribute this code, as long 
%    as this copyright notice is included whole and unchanged.  
%
%    END COPYRIGHT NOTICE

if nargin<2
    ndims = 2;
end
if nargin<3
    if ~isempty(find(isinf(D)));
        mode = 'local';
    else
        mode = 'global';
    end
end

N = size(D,1);

if strcmp(mode, 'local')
    %%%%% Compute shortest paths %%%%%
    disp('Computing shortest paths...');
    % D = floyd(D);
    Ws = D;
    Ws(find(Ws==Inf)) = 0;
    Ws = sparse(Ws);
    D = dijkstra_fast(Ws, 1:length(Ws));
end

%%%%% Construct low-dimensional embeddings (Classical MDS) %%%%%
disp('Constructing low-dimensional embeddings (Classical MDS)...'); 
opt.disp = 0; 
[xy, val] = eigs(-.5*(D.^2 - sum(D.^2)'*ones(1,N)/N - ones(N,1)*sum(D.^2)/N + sum(sum(D.^2))/(N^2)), ndims, 'LR', opt); 

for i=1:ndims
    xy(:,i) = xy(:,i)*sqrt(val(i,i));
end