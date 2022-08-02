function [i, p] = fn_meshclosestpoint(P,p)
% function [i p] = fn_meshclosestpoint(vert,p)
% function [i p] = fn_meshclosestpoint(mesh)
%---
% Input:
% - vert    (3xN) array of points 
%           (can be alternatively a {vertices,faces} array, then first cell
%           array element is used)
% - p       3D point (vector) or 3D line (2x3 array as the output of
%           get(gca,'CurrentPoint'))
% - mesh    {vertices,faces} : mesh is displayed and then function waits for
%           button press
%
% Output:
% - i       indice of the vertex that is closest to p
%
%------
% Thomas Deneux
% last modification: 07/02/2006

% Select point in figure ?
fflag = nargin<2;
if fflag
    h = figure;
    fn_plotmesh(P), hold on
    P = P{1}; if size(P,1)~=3, P=P'; end
    plot3(P(1,:),P(2,:),P(3,:),'*')
    set(gcf,'SelectionType','extend')
    disp('select point (use second button to move the mesh)')
    waitfor(gcf,'SelectionType','normal')
    p = get(gca,'CurrentPoint');
else
    if iscell(P), P  = P{1}; end
    if size(P,1)~=3, P=P'; end
end

nv = size(P,2);

if any(size(p)==1)
    dist = P-repmat(p(:),1,nv);
    dist = sum(dist.*dist);
else
    if size(p,1)~=3, p=p'; end
    a = p(:,1);
    b = p(:,2);
    u = b-a; u = u/norm(u);
    U = repmat(u,1,nv);
    AP = P-repmat(a,1,nv);
    APXU = AP([2 3 1],:).*U([3 1 2],:) -  AP([3 1 2],:).*U([2 3 1],:); % produit vectoriel
    dist = sum(APXU.*APXU);
end
[dum i] = min(dist);

if fflag
    plot3(P(1,i),P(2,i),P(3,i),'*r')
    pause(.5)
    close(h)
end

if nargout==2
    p = P(:,i);
end