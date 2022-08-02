function [i, p, tr] = fn_meshselectpoint(mesh,p)
% function [i p tr] = fn_meshselectpoint(mesh[,p])
%---
% Input:
% - mesh    {vertices,faces}
% - p       3D line (2x3 array as the output of get(gca,'CurrentPoint'))
% - mesh    {vertices,faces} : mesh is displayed and then function waits for
%           button press
%
% Output: 
% - i       indice of the selected vertex
% - p       coordinate of that vertex
% - tr      indice of the selected triangle
%
%------
% Thomas Deneux
% last modification: 07/02/2006


% Select point in figure ?
fflag = nargin<2;
if fflag
    h = figure;
    fn_plotmesh(mesh);
    set(gcf,'SelectionType','extend')
    disp('select point (use second button to move the mesh)')
    waitfor(gcf,'SelectionType','normal')
    p = get(gca,'CurrentPoint');
end


nv = length(mesh{1});
nf = length(mesh{2});
o = p(1,:)';

P = mesh{1}; if size(P,1)~=3, P=P'; end
faces = mesh{2};

% some precomputations (cross products)
Z = repmat(o,1,nf);
A = P(:,faces(1,:)) - Z;
B = P(:,faces(2,:)) - Z;
C = P(:,faces(3,:)) - Z;
AB = B-A;
AC = C-A;
AXB = A([2 3 1],:).*B([3 1 2],:) - A([3 1 2],:).*B([2 3 1],:);
BXC = B([2 3 1],:).*C([3 1 2],:) - B([3 1 2],:).*C([2 3 1],:);
CXA = C([2 3 1],:).*A([3 1 2],:) - C([3 1 2],:).*A([2 3 1],:);

% select triangles that cross line defined by p
p = p(2,:)'-o;
Q = repmat(p,1,nf);
E = sum(AXB.*Q);        %  disp([num2str(i) ' -> a']), continue, end
F = sum(BXC.*Q);   %  disp([num2str(i) ' -> b']), continue, end
tr = find(sign(E)==sign(F)); Q = repmat(p,1,length(tr)); E = E(tr);
F = sum(CXA(:,tr).*Q);   %  disp([num2str(i) ' -> c']), continue, end
tr = tr(find(sign(E)==sign(F))); Q = repmat(p,1,length(tr));

% closest triangle and then closest point
Z = repmat(o,1,length(tr));
dist = sum(A(:,tr).*A(:,tr));
[dum k] = min(dist);
tr = tr(k); 
Q = repmat(p,1,3);
V = [A(:,tr) B(:,tr) C(:,tr)];
QXV = Q([2 3 1],:).*V([3 1 2],:) - Q([3 1 2],:).*V([2 3 1],:);
dist = sum(QXV.*QXV);
[dum k] = min(dist);
i = faces(k,tr);
p = P(:,i);

if fflag    
    hold on, plot3(P(1,faces([1 2 3 1],tr)),P(2,faces([1 2 3 1],tr)),P(3,faces([1 2 3 1],tr)),'r','linewidth',3)
    plot3(p(1),p(2),p(3),'*b')
    pause(.5)
    close(h)
end
