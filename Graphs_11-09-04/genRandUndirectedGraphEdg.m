function randomProps = genRandUndirectedGraphEdg(Vtx, graph_Edge, threshold)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     genRandUndirectedGraphEdg.m
% 
% Description:  Function for generating random edges on an 'UNDIRECTED' graph. 
%               The model randomly generates (x,y) positions of each node
%               in a unit square, it then measures the distance between a
%               node and all other nodes -- if this is < threshold distance
%               it adds the edge otherwise it doesn't add the edge. 
%
%               If an edge between two nodes is specified in graph_Edge,
%               then the threshold criteria is not used for that particular
%               edge.
%
% Input:        (1) Vtx: number of nodes 
%               (2) graph_Edg: the edges are ordered pairs, this can be empty matrix
%                   [] if entire graph is random and user does not force
%                   any edges. Format for this matrix, ex: [1 2;1 3;1 4]
%                   containing edge {1,2} and {1,3} and {1,4}
%               (3) threshold: distance threshold
%
% Output:       Edges for a randomly generated graph output as a data structure
%                   randomProps.nodeLoc = nodeLoc;      % randomly generated (x,y) location of each node
% 				    randomProps.Edges   = graph_Edge;   % all the edges of graph
% 				    randomProps.addEdge = addE;         % new edges (randomly) generated
% 				    randomProps.dist    = dist;         % distance associated
% 				with each edge. This is mostly used for error checking
%
% 7/2/03 Jasmine Sandhu - sandhu@aa.washington.edu 
%
% **Update 8/26/04: The random graph functionality was incorrect, this has been fixed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   $Revision: 1.1 $   
%   $Date: 2004/10/30 18:11:38 $
%
%   Version History:
%   ----------------
%   $Log: genRandUndirectedGraphEdg.m,v $
%   Revision 1.1  2004/10/30 18:11:38  jasmine
%   Created Graph Theory folder in STB repository
%
%


% reorder edges r_ij ex: given edges = [1,2; 2,4; 5,4; 1,3]
% reordering gives: edges = [1,2; 1,3; 2,4; 4,5], since graph is assumed to
% be undirected for this function this reorder does not alter the graph
% undirected graph -- no need to preserve order of each edge [=> each row]
temp = sort(graph_Edge, 2);
graph_Edge = sortrows(temp);
randomProps.usrEdge = graph_Edge;
% Randomly generate location of each node in unit square (x,y)
nodeLoc   = rand(Vtx, 2);

vect = [];
dist = [];  % distance between 2 nodes (2-norm)
addE = [];
for ind    = 1:Vtx - 1
    temp   = ones(Vtx - ind, 1);
    curLoc = [nodeLoc(ind,1).*temp, nodeLoc(ind,2).*temp];    % make an array for location of current node
    % array format [Node#, distance between Node# and remaining nodes > Node #]. 
    % ex: say there are 3 Vertices with randomly selected (x,y) positions for each node.
    %     During iteration 1, the distance between node 1, 2 and node 1, 3 is determined
    %     During iteration 2, the distance between node 2,3 is determined and this is the 
    %     last iterations, since there are no more edges to consider.
    dummy = curLoc - nodeLoc(ind + 1:Vtx,:);
    vect  = [vect; [ind.*temp, dummy]];
    
    % If Edge is not empty, then use tempD variable to ensure there are no
    % loops and graph is simple
    if( isempty(graph_Edge) == 0); tempD = graph_Edge(:,1) == ind; end
    for count = 1:size(dummy,1)
        if( exist( 'tempD') == 1)
            % If user inputs edges, take those into account so there are no
            % loops .. i.e. ensure graph is simple
            [val index] = max(tempD);
            % Edge already present
            if( graph_Edge(index,:) ~= [ind, count + ind] )
                temp  = norm(dummy(count,:));
                dist  = [dist; [ind, temp]];
                if( temp <= threshold)
                    % add edge to set of edges
                    addE = [addE; [ind, count + ind]];
                end
                tempD = tempD(index + 1:size(tempD,1), :);  % delete the previous rows on tempD
            end
            % Change tempD for this index to 0 since it has already been accounted for and the next time 
            % around the loop the next one is chosen
            tempD(index) = 0;
        else
            % user did not input any edges, therefore all edges are
            % randomly generated
            temp  = norm(dummy(count,:));
            dist  = [dist; [ind, temp]];
            if( temp <= threshold)
                % add edge to set of edges
                addE = [addE; [ind, count + ind]];
            end
        end
    end
end
graph_Edge = [graph_Edge; addE];
graph_Edge = sortrows(graph_Edge);  % resort rows after new ones have been added

% Random graph is empty
if( isempty(graph_Edge)); randomProps.emptyGraph = 1; else, randomProps.emptyGraph = 0; end

randomProps.nodeLoc = nodeLoc;
randomProps.Edges   = graph_Edge;
randomProps.addEdge = addE;
randomProps.dist    = dist;
return