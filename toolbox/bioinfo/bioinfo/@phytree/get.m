function varargout = get(tr,varargin)
%GET Get information about a phylogenetic tree object.
%   [VALUE1,VALUE2, ...] = GET(TREE,'NAME1','NAME2', ...) returns the
%   contents of the specified fields for the PHYTREE object TREE.
%
%   The valid choices for 'NAME' are:
%     'POINTERS'    : branch to leaf/branch connectivity list
%     'DISTANCES'   : edge length for every leaf/branch
%     'NUMLEAVES'   : number of leaves
%     'NUMBRANCHES' : number of branches
%     'NUMNODES'    : number of nodes (numleaves + numleaves)
%     'LEAFNAMES'   : names of the leaves
%     'BRANCHNAMES' : names of the branches
%     'NODENAMES'   : names of all the nodes
%
%   Examples:
%     tr = phytreeread('pf00002.tree')
%     protein_names = get(tr,'LeafNames')
%
%   See also PHYTREE, PHYTREEREAD, PHYTREE/SELECT, PHYTREE/GETBYNAME.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Author: batserve $ $Date: 2004/04/01 15:58:49 $

tr=struct(tr);
okargs = {'pointers','distances','numleaves','numbranches',...
    'numNodes','leafnames','branchnames','nodenames'};
for ind = 2 : nargin
    pname = varargin{ind-1};
    k = strmatch(lower(pname), okargs); %#ok
    if isempty(k)
        error('Bioinfo:UnknownParameterName',...
            'Unknown parameter name: %s.',pname);
    elseif length(k)>1
        error('Bioinfo:AmbiguousParameterName',...
            'Ambiguous parameter name: %s.',pname);
    else
        switch(k)
            case 1 % pointers
                varargout{ind-1} = tr.tree; %#ok
            case 2 % distances
                varargout{ind-1} = tr.dist;
            case 3 % numleaves
                varargout{ind-1} = size(tr.tree,1)+1;
            case 4 % numbranches
                varargout{ind-1} = size(tr.tree,1);
            case 5 % numNodes
                varargout{ind-1} = 2*size(tr.tree,1)+1;
            case 6 % leafnames
                varargout{ind-1} = tr.names(1:size(tr.tree,1)+1);
            case 7 % branchnames
                varargout{ind-1} = tr.names(size(tr.tree,1)+2:2*size(tr.tree,1)+1);
            case 8 % nodenames
                varargout{ind-1} = tr.names;
        end
    end
end
