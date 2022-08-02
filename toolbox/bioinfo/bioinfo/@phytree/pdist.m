function [dist,comm] = pdist(tr,varargin)
%PDIST computes the pairwise patristic distance.
%
%   D = PDIST(TREE) returns a vector D containing the patristic
%   distances between every possible pair of leaf nodes in the phylogenic
%   tree object TREE. The distance is computed following the path through
%   the branches of the tree.  
%   
%   The output vector D is arranged in the order of ((2,1),(3,1),...,
%   (M,1),(3,2),...(M,3),.....(M,M-1)), i.e. the lower left triangle of the
%   full M-by-M distance matrix.  To get the distance between the Ith and
%   Jth nodes (I > J) use the formula D((J-1)*(M-J/2)+I-J). M is the
%   number of leaves)
%   
%   D = PDIST(...,'NODES',N) indicates the nodes to be included in the
%   computation. N can be 'leaves' (default) or 'all'. In the former
%   case the output will be order as before, but M is the total number of
%   nodes in the tree, i.e. NUMLEAVES+NUMBRANCHES.
%
%   D = PDIST(...,'SQUAREFORM',true) coverts the output into a square
%   format, so that D(I,J) denotes the distance between the Ith and the Jth
%   node. The output matrix is symmetric and has a zero diagonal.
%   
%   [D,C] = PDIST(TREE) returns in C the index of the closest common parent
%   nodes for every possible pair of query nodes.
%
%   Example:
%
%      % get the tree distances between every leaf
%      tr = phytreeread('pf00002.tree')
%      dist = pdist(tr,'nodes','leaves','squareform',true)
%
%   See also SEQPDIST, SEQLINKAGE, PHYTREE, PHYTREETOOL.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Author: batserve $ $Date: 2004/03/09 16:15:21 $

% set default
squaredOutput = false;
outNodes = 'leaves';

numBranches = size(tr.tree,1);
numLeaves = numBranches + 1;
numLabels = numBranches + numLeaves; 

% process input arguments
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'nodes','squareform'};
    for ind = 2 : 2: nargin
        pname = varargin{ind-1};
        pval = varargin{ind};
        k = strmatch(lower(pname), okargs); %#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % nodes
                    okNodes = {'leaves','all','branches'};
                    h = strmatch(lower(pval),okNodes ); %#ok
                    if isempty(h)
                       error('Bioinfo:IncorrectReferenceNode',...
                             'Incorrect node selection')
                    else 
                        outNodes = okNodes{h};
                    end
            case 2 % squareform
                    squaredOutput = (pval == true);
            end
        end
    end
end


% create indexes to work only the lower leff triangle
m = numLabels*(numLabels-1)/2;
p = cumsum([1 (numLabels-1):-1:2]);
I = ones(m,1);   I(p) = [2 3-numLabels:0]; 
J = zeros(m,1);  J(p) = 1;
H = I;           H(p) = 2:numLabels;
I = cumsum(I); J = cumsum(J); H = cumsum(H);

switch outNodes
    case 'leaves'
        outSelection = (I <= numLeaves) & (J <= numLeaves);
    case 'all' 
        outSelection = (I>0);
    case 'branches'
        outSelection = (I > numLeaves) & (J > numLeaves);
end
% find closest common branch for every pair of nodes
% diagonal is invalid ! but not needed

% initializing full matrix 
commf = repmat(int16(0),numLabels,numLabels);
children = repmat(false,1,numLabels);
for ind = numBranches:-1:1
   children(:) = false;
   children(ind+numLeaves) = true;
   for ind2 = ind:-1:1
       if children(ind2+numLeaves)
           children(tr.tree(ind2,:))=true;
       end
   end 
   commf(children,children)=int16(ind);
end

% output vector with the lower leff triangle closest common branches
comm = double(commf(H));

% compute the distance to root for every node
cdist = tr.dist; 
for ind = numBranches:-1:1
    cdist(tr.tree(ind,:)) = cdist(tr.tree(ind,:)) + cdist(ind+numLeaves);
end

% compute pairwise distance
dist = cdist(I)+cdist(J)-2*cdist(comm+numLeaves);

dist = dist(outSelection);
comm = comm(outSelection);

if squaredOutput
    dist = squareform(dist);
    comm = squareform(comm);
end
