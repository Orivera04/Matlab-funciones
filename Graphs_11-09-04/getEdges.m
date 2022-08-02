function [graph_edges, neighbors] = getEdges(Vtx, gtype, direct)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     getEdges.m
% 
% Description:  If a complete graph or a complete (K_3) cycle graph .. i.e. hamiltonian cycle is 
%               desired, this function automatically generates the edges. 
%
% Note:         Currently, it is not necessary to include whether graph is 
%               directed or not.  The edges are generated in the same way for directed 
%               and undirected graphs.  
%
% Input:        (1) Vtx:    number of nodes 
%               (2) gtype:  gtype, either 'complete' or 'cycle'
%               (3) direct: 0 for undirected graph 1 for directed
%               By default if inputs 3 & 4 are not provided, the graph is assumed to be complete.
%
% Output:       - Edges for the graph w/ above properties.  Examples
%                 1] Complete undirected graph 
%                 2] Complete directed graph
%                 3] Complete undirected / directed cycle graph
%               - If graph is a cycle graph, then edges are ordered in ascending order to 
%                 create a hamiltonian cycle: 
%                 eg: Vtx = 4, then Edges = [1,2], [2,3], [3,4], [4,1]
%               - Also, for a complete graph, for each node it also outputs
%                 the variable 'neighbors'. This is simply a star with the
%                 node at its center.
%
% 8/25/03 Jasmine Sandhu - sandhu@aa.washington.edu 
%
% ** Update: Added April 11th
%               - Can have a second output containing the neighbors of each node
%
% ** Update: Added May 26th 
%               - associate with each edge and each neighbor (only for complete case) the index of 
%                 the column in the incidence matrix associated with that edge
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   $Revision: 1.2 $   
%   $Date: 2004/10/30 21:46:32 $
%
%   Version History:
%   ----------------
%   $Log: getEdges.m,v $
%   Revision 1.2  2004/10/30 21:46:32  jasmine
%   updated comment section -- code is unchanged
%
%   Revision 1.1  2004/10/30 18:11:38  jasmine
%   Created Graph Theory folder in STB repository
%
%

edgList= [];
num    = 1;
neighbors = []; % neighbors of each node -- non-empty only for complete graph
% Define edges -- for undirected & directed graphs in same manner
% NOTE: If directed graph, then edges are oriented as r_ij for all i = 1 ..
% Vtx, and j > i.  Therefore, for K4, the edges are directed as:
% [1,2], [1,3], [1,4], [2,3], [2,4], [3,4].  Where [1,2] has it's tail @ 1
% and head at 2 --- but this is not that relevant as long as the matrices
% are calculated consistently
%
% NOTE: If undirected, the edges are difined in same way, since direction
% is irrelevant.
temp     = 0;
col_num  = 0;

for ind1 = 1:Vtx
    %---- not very elegant way .. but it works .. should go back in FIX
    if( ind1 > 1), temp = temp + (Vtx - (ind1 - 1)); end
    %----
    for ind2 = ind1 + 1: Vtx
        if( strcmp(gtype,'complete') == 1)  % graph is complete w/ no cycle
            col_num = temp + (ind2 - ind1);
            graph_Edge(num,:) = [ind1, ind2, col_num];
            
            %--------
            % Store edges connecting each node to its neighbors in 3D array
            neighbors(ind2-1,:,ind1) = [ind1, ind2, col_num];
            for i = 1:(Vtx - ind1)
                neighbors(ind1,:,ind2) = [ ind1, ind2, col_num ];
            end
            %-------
        end
        num = num + 1;  % increment each time edge is added
    end
    %% Generate cycle
    if( strcmp(gtype,'cycle') == 1)
        % Generate edges such that there is a hamiltonian cycle in
        % graph, in order described in file description above.        
        if( ind1 == 1), 
            graph_Edge(ind1,:) = [ind1, ind1 + 1];
            if( direct == 0)    % undirected graph
                graph_Edge(ind1 + 1,:) = [ind1, Vtx];
            else 
                graph_Edge(ind1 + 1,:) = [Vtx, ind1];
            end
        else if( ind1 < Vtx & ind1 > 1)
                graph_Edge(ind1 + 1,:) = [ind1, ind1 + 1];
            end
        end 
    end
    %% End generate cycle
end

% Populate data structure graph_props
% Return edges as part of the graph structure
graph_edges = graph_Edge;   

return 