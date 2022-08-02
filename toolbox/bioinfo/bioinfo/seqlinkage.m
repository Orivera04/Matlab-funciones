function t = seqlinkage(d, method, names) 
%SEQLINKAGE constructs a phylogenetic tree from pairwise distances.
%
%  TREE = SEQLINKAGE(DIST) computes a phylogenetic tree object from the
%  pairwise distances DIST between the species or products. The input DIST
%  is a matrix (or vector) such as is generated by SEQPDIST.  
%
%  TREE = SEQLINKAGE(DIST,METHOD) creates a phylogenetic tree object using
%  a specified distance method. The available methods are:
%
%     'single'            --- nearest distance (single linkage method)
%     'complete'          --- furthest distance (complete linkage method)
%     'average' (default) --- unweighted average distance (UPGMA) (also
%                             known as group average) 
%     'weighted'          --- weighted average distance (WPGMA) 
%     'centroid'          --- unweighted center of mass distance (UPGMC) 
%     'median'            --- weighted center of mass distance (WPGMC) 
%
%  TREE = SEQLINKAGE(DIST,METHOD,NAMES) passes a list of names to label the
%  leaf nodes (e.g. species or products) in the phylogenetic tree object.
%  NAMES can be a vector of structures with the fields 'Header' or 'Name'
%  or a cell array of strings. In both cases the number of elements
%  provided must comply with the number of samples used to generate the
%  pairwise distances in DIST. 
%
% Example:
%
%     % Load a multiple alignment of amino acids:
%     seqs = fastaread('pf00002.fa');
% 
%     % Measure the 'Jukes-Cantor' pairwise distances:
%     dist = seqpdist(seqs,'method','jukes-cantor','indels','pair');
% 
%     % Build the phylogenetic tree with the single linkage method and pass
%     % the names of the sequences:
%     tree = seqlinkage(dist,'single',seqs)
%     view(tree)
%
% See also SEQPDIST, PHYTREE, PHYTREE/VIEW, PHYTREE/PLOT, PHYTREEWRITE. 

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $  $Date: 2004/04/01 15:58:54 $

% check the input distances
[m, n] = size(d);

if m==n && m>1 % transform to vector form
    D = zeros(m*(m-1)/2,1);
    k=1;
    for j = 1:m-1
        for i = j+1:m
            D(k) = d(i,j);
        end
    end
else
    D=d(:);
end

D=D'; % linkage uses row form
n = numel(D);
m = (1+sqrt(1+8*n))/2; % number of leaves
if m ~= fix(m)
    error('Bioinfo:BadSize',...
   'Size of DIST not compatible with the output of the SEQPDIST function.');
end

% Selects appropiate method
if nargin == 1 % set default switch to be 's' 
    method = 'av';
else
    okmethods = {'single','nearest',...
                 'complete','farthest',...
                 'average','upgma',...
                 'weighted','wpgma',...
                 'centroid','upgmc',...
                 'median','wpgmc'};
    methodkeys = {'si','si','co','co','av','av','we','we','ce','ce',...
                  'me','me','wa','wa'};     
    s = strmatch(lower(method), okmethods); %#ok
    if isempty(s)
        error('Bioinfo:IncorrectMethod','Unknown method name: %s.',method);
    elseif length(s)>1
        error('Bioinfo:IncorrectMethod','Ambiguous method name: %s.',method);
    else
        method = methodkeys{s};
    end
end

% detects the names
if nargin == 3 % names were supplied, check validity
    if iscell(names) || isfield(names,'Header') || isfield(names,'Name') || isfield(names,'LocusName')
        if isfield(names,'Header') % if struct put them in a cell
            names = {names(:).Header};
        elseif isfield(names,'Name')   % if struct put them in a cell
            names = {names(:).Name};
        elseif isfield(names,'LocusName')   % if struct put them in a cell
            names = {names(:).LocusName};
        end
        names = names(:);
        namesSupplied = true;
        if numel(names)~=m
            error('Bioinfo:IncorrectSize',...
            'NAMES must have the same size as number of leaves in the tree')
        end
    else
        error('Bioinfo:IncorrectInputType',...
          'NAMES must be a cell with char arrays or a vector of structures.')
    end
else
    namesSupplied = false;
end

% call the stats linkage program
T = linkage(D,method);

% convert data to a phylogenetic tree object
if namesSupplied
    t = phytree(T,names);
else
    t = phytree(T);
end