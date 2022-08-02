function macrogrid(choice)
% Call: macrogrid(choice)
% Input:
%    choice ... 1=circle, 2=annulus
% Globals:
%    coord nodes ... Discretisation
% Description:
%    Computes macro-discretisations for some user defined domains. Uses
%    MATLAB's 'delaunay' subroutine.

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Global definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global coord nodes;% Discretisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct 'nodes'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch choice
case 1,% Ball with radius 1
   M = 20;% No of points on the sphere
   L = max(ceil(M/5),2);% No of layers
   ra= linspace(0,1,L); ra(1)= [];% Set of radii (without 0)
   al= linspace(0,2*pi,M); al= al(1:end-1);% Angles (unique!)
   x = [0,kron(ra,cos(al))];% Nodes: 0 and points on spheres with
   y = [0,kron(ra,sin(al))];% radii from 'ra'
   nodes= delaunay(x,y);% Create triangulation
case 2,% Annulus with radii 1/2 - 1
   M = 20;% No of points on each sphere
   L = max(ceil(M/5),2);% No of layers
   ra= linspace(0.5,1,L);% Set of radii
   al= linspace(0,2*pi,M); al= al(1:end-1);% Angles (unique!)
   x = [0,kron(ra,cos(al))];% Nodes: 0 and points on spheres with
   y = [0,kron(ra,sin(al))];% radii from 'ra' (0 to enhance symmetry)
   nodes= delaunay(x,y);% Creates triangulation of the whole sphere
   nt= size(nodes,1); nv= max(max(nodes));% No of triangeles, vertices
   %%% Remove the inner triangles
   xs= [sum(x(nodes'))/3;sum(y(nodes'))/3]';% Barycenters
   nodes(find(sqrt(sum(xs.*xs,2))<0.5),:)= [];% Remove those with |.|<1/2
   irem= setdiff(1:nv,unique(nodes));% Set of removed indices
   x(irem)= []; y(irem)= [];% Remove in coordinate field
   %%% Compute renumbering for omitted quantities
   trans= 1:nv;
   for i=irem trans(i+1:end)= trans(i:end-1); trans(i)= 0; end;
   nodes= trans(nodes);% Insert new numbering
otherwise
   disp('*** Error *** No such example');
end;
%%% Establish counter-clockwise orientation for 'nodes'
nt= size(nodes,1); nv= max(max(nodes));% No of triangeles, vertices
xs= [sum(x(nodes'))/3;sum(y(nodes'))/3]';% Barycenters
for t=1:nt
   xloc= [x(nodes(t,:))',y(nodes(t,:))'];
   if (det([xloc(1,:)-xs(t,:);xloc(2,:)-xs(t,:)])<0)% Test orientation
      nodes(t,:)= fliplr(nodes(t,:));% Change orientation if negative
   end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fill in 'coord'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coord= [x',y'];% Store new coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
