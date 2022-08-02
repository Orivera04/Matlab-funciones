function visfem(graph_out0,u,nodes,coord)
% Call: visfem(graph_out0,u,nodes,coord)
% Input:
%    graph_out0 ... Choice of first visualisation parameter
%    u ... Nx1; Function values in vertices
%    coord nodes ... Discretisation
% Description:
% Visualises linear finite element solutions on unstructered
% triangular grids or bilinears on rectangular grids by different
% methods.
% Data structure:
%    coord ... Nx2; To each vertex its coordinates
%    nodes ... NxM; To each element the numbers of its vertices.
%       Numbering in counter-clockwise sense required.
%       M=3: triangles; M=4: rectangles.

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002 (W. Doerfler). Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Initialisations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
graph_out= graph_out0;
scale    = 0.25;% Scaling factor for 'show_grad'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Show 'u' by different methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n'); fprintf('Graphical output\n');
while(0<graph_out & graph_out<7)
   figure(1);% Bring graphic window into front
   grid off;
   switch graph_out
   case 1,  show_graph(u,nodes,coord);
   case 2,  show_sgraph(u,nodes,coord);
   case 3,  show_mesh(nodes,coord);
   case 4,  show_cmesh(u,nodes,coord);
   case 5,  show_level(u,nodes,coord);
   case 6,  show_grad(u,nodes,coord,scale);
   otherwise, disp('*** ERROR*** No such method');
   end;
   fprintf('Select method\n');
   fprintf('1(2)=(s)graph, 3(4)=(c)mesh, 5=level, 6=grad, else=stop\n');
   graph_out= input('<?>: ');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
