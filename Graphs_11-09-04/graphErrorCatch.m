function caughtErr = graphErrorCatch(Vtx, Edge)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     graphErrorCatch.m
% 
% Description:  Consolidated error catching functions in this file 
%
% Input:        (1) Vtx:    number of vertices
%               (2) Edge:   edges input as, ex: [1 2;1 3] if graph has
%                   edges {1,2} and {1,3} and so forth
%
% Output:       some general error catching functions for given graph --
%               documentation for type of errors checked is given at
%               http://xxx
%
% 7/27/03 Jasmine Sandhu - sandhu@aa.washington.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%
%   $Revision: 1.1 $   
%   $Date: 2004/10/30 18:11:38 $
%
%   Version History:
%   ----------------
%   $Log: graphErrorCatch.m,v $
%   Revision 1.1  2004/10/30 18:11:38  jasmine
%   Created Graph Theory folder in STB repository
%
%

caughtErr = 0;     % means no error found

%% Input format of edges is incorrect
if( size(Edge,2) ~= 2 & isempty(Edge) ~= 1) % Edge variable is not empty and not of correct size
    errordlg('Format of edge set is incorrect, ensure each edge is separated by a semi-colon. For ex, a complete graph on 3 vtx, input edges as : [1, 3; 2, 3; 1, 3]', ...
        'Graph Error','on');
    caughtErr = 1;
    return;
end
%% Graph has more edges than possible for complete graph
if( size(Edge,1) > Vtx*(Vtx - 1)/2)
    errordlg(['A simple graph with ',num2str(Vtx),' vertices can have at most ',num2str(Vtx*(Vtx - 1)/2),' edges.  You have input ', ...
            num2str(size(Edge,1)),' Edges'], 'Graph Error','on');
    caughtErr = 1;
    return;
end

%% simple graph required
for ind = 1:size(Edge,1)
    if Edge(ind,1) == Edge(ind,2)
        errordlg(['Graph must be simple, edge: [',num2str(Edge(ind),1),',',num2str(Edge(ind),2),'] is not valid']);
        caughtErr = 1;
        return
    end
end
if( isempty(Vtx) == 1 | Vtx < 2)
    errordlg(['Application requires at least 2 nodes for graph. You''ve entered: [', num2str(Vtx),']']);
    caughtErr = 1;
    return
end
%% Add another error catching mech for ensure edges included are consistent w/ no of VTX!!!
%% NEED 2 FIX -- graph w/ 3 vtx cannot have an edge [1,4]
%% If directed graph, then edges are oriented as r_ij for all i = 1 ..
%% Vtx, and j > i.  Therefore, for K4, the edges are directed as:
%% [1,2], [1,3], [1,4], [2,3], [2,4], [3,4]
%% Another error catcher, ensure edges are not added twice!!