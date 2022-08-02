function graph_props = findGraphProps(Vtx, graph_Edge, direct)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     findGraphProps.m
% 
% Description:  Function for computing the adjacency matrix, the Laplacian, and node graph_Edge 
%               incidence matrix, degree matrix .. etc
%
% Input:        (1) Vtx:        number of nodes 
%               (2) graph_Edge: the edges are ordered pairs, this can be empty matrix [] if graph is completef
%               (3) graph type: 0 if graph is undirected or 1 if graph is directed
%
% Output:       Data structure called graph_props that contains following properties of generated graph
% 					graph_props.adjMat           : adjacency matrix
% 					graph_props.degMat           : degree matrix
% 					graph_props.incMat           : incidence matrix
% 					graph_props.LapMat           : laplacian matrix
% 					graph_props.normalizedLapMat : normalized laplacian matrix
% 					graph_props.edgList          : a string containing list of edges
%               - If Edges is not empty and graph is a cycle graph, then the cycle parameter
%                 is ignored and only the edges input by user are used
%
% Note:         Use graphErrorCatch function in script that defines edges and vertices for graph.
%               General error catching is done at that level and by graphErrorCatch.m function
%
% References:   Documentation file http://xxx
%
% 7/2/03 Jasmine Sandhu - sandhu@aa.washington.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   $Revision: 1.1 $   
%   $Date: 2004/10/30 18:11:38 $
%
%   Version History:
%   ----------------
%   $Log: findGraphProps.m,v $
%   Revision 1.1  2004/10/30 18:11:38  jasmine
%   Created Graph Theory folder in STB repository
%
%


nin = nargin;
error(nargchk(3,5,nargin));

adjMat = zeros(Vtx, Vtx);   % Adjacency matrix
degVec = zeros(Vtx, 1);     % Used for Degree matrix
incMat = zeros(Vtx, size(graph_Edge,1));  % Incidence matrix

if( isempty(graph_Edge) == 0) % graph is not empty
    edgList= [];
    
    switch direct
        case 0  % graph is undirected
            for ind = 1:size(graph_Edge,1)
                adjMat(graph_Edge(ind,1),graph_Edge(ind,2)) = 1;
                adjMat(graph_Edge(ind,2),graph_Edge(ind,1)) = 1;
                
                % Each time the vertex appears in edge, increment degVec by 1
                degVec(graph_Edge(ind,1),1) = degVec(graph_Edge(ind,1),1) + 1;
                degVec(graph_Edge(ind,2),1) = degVec(graph_Edge(ind,2),1) + 1;
                
                % Incidence matrix -- rows are the Vtx, and columns are the Edges
                % rowIndex and colIndex: example on K3, 
                % for ind = 1
                %   rowI        = [1, 2], colI = 1; 
                %   incMat(1,1) = 1;    % ij entry corresponding with vertex 1, and edge 12
                %   incMat(2,1) = 1;    % ij entry corresponding with vertex 2, and edge 12
                rowI                  = graph_Edge(ind,:);    % row index for ij entry in incMat
                colI                  = ind;            % col index for ij entry in incMat
                incMat(rowI(1), colI) = 1;
                incMat(rowI(2), colI) = 1;
                
                % Create a string of edges called graph_Edge list, useful for
                % displaying edges associated w/ incMat in GUI
                edgList = [edgList, ' {',num2str(graph_Edge(ind,1)),',',num2str(graph_Edge(ind,2)),'}  '];
            end
        case 1  % graph is directed
            for ind = 1:size(graph_Edge,1)
                adjMat(graph_Edge(ind,1),graph_Edge(ind,2)) = 1;    % directed graph ij entry is 1 iff edge goes from i to j
                
                % Each time the vertex appears in edge, increment degVec by 1
                % used to normalize the laplacian
                degVec(graph_Edge(ind,1),1) = degVec(graph_Edge(ind,1),1) + 1;
                degVec(graph_Edge(ind,2),1) = degVec(graph_Edge(ind,2),1) + 1;
                
                % Incidence matrix -- rows are the Vtx, and columns are the Edges
                % rowIndex and colIndex: example on directed K3, edge [1,2] directed from 1 to 2
                % for ind = 1
                %   rowI        = [1, 2], colI = 1; 
                %   incMat(1,1) = 1;    % ij entry corresponding with vertex 1, and edge 12
                %   incMat(2,1) = 1;    % ij entry corresponding with vertex 2, and edge 12
                rowI                  = graph_Edge(ind,:);    % row index for ij entry in incMat
                colI                  = ind;            % col index for ij entry in incMat
                incMat(rowI(1), colI) = -1;             % tail of directed edge
                incMat(rowI(2), colI) =  1;             % head of directed edge
                
                % Create a string of edges called edge list, useful for
                % displaying edges associated w/ incMat in GUI
                edgList = [edgList, ' {',num2str(graph_Edge(ind,1)),',',num2str(graph_Edge(ind,2)),'}  '];
            end
        otherwise
            errordlg('The graph is neither directed, nor undirected');
            return
    end
    %%% Set common output parameters
    degMat = diag(degVec, 0);       % Degree matrix
    if( direct == 1)
        LapMat = incMat * incMat';  % Laplacian matrix defined for both directed graph
    else
        LapMat = degMat - adjMat;   % Laplacian matrix for undirected graph, assume arbitrary orientation
    end
    chkInv = det(degMat);           % check to see if it is singular
    
    if( chkInv == 0)
        for ind = 1:length(degVec)
            if( degVec(ind)) == 0, invDegVec(ind) = 0; end
            if( degVec(ind)) ~= 0, invDegVec(ind) = 1/degVec(ind); end
        end
        invDegMat = diag(invDegVec, 0);
        normLap   = invDegMat  *LapMat;    % Fax Laplacian for singular deg matrix
    else
        normLap   = inv(degMat)*LapMat;    % Fax Laplacian [Normalized laplacian]
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    edgList= ['N/A'];
    degMat = zeros(Vtx);
    LapMat = degMat - adjMat;
    normLap= LapMat;    
end

% Populate data structure graph_props
graph_props.adjMat           = adjMat;
graph_props.degMat           = degMat;
graph_props.incMat           = incMat;
graph_props.LapMat           = LapMat;
graph_props.normalizedLapMat = normLap;
graph_props.edgList          = cellstr(edgList);