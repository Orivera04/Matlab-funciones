function highlight(A,xy,sep)
%HIGHLIGHT	Plot a mesh with subgraph highlighted.
%	highlight(A,xy,sep) plots a picture of the mesh A with
%	coordinates xy, highlighting the subgraph induced
%	by the vertices in sep.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[n,n] = size(A);
[i,j] = find(A);

% Plot main graph with vertices before edges.

[ignore, p] = sort(max(i,j));
i = i(p);
j = j(p);
X = [ xy(i,1) xy(j,1) NaN*ones(size(i))]';
Y = [ xy(i,2) xy(j,2) NaN*ones(size(i))]';
d = 'r-';
xymin = min(xy);
xymax = max(xy);
range = max(xymax-xymin);
plot (X(:), Y(:), d);
axis([xymin(1) xymin(1)+range xymin(2) xymin(2)+range]);
axis('square');
hold on;

% Highlight sep set.

B = A(sep,sep);
xB = xy(sep,1);
yB = xy(sep,2);
[i,j] = find(B);
X = [xB(i) xB(j) NaN*ones(size(i))]';
Y = [yB(i) yB(j) NaN*ones(size(i))]';
plot (X(:), Y(:), 'w-');
if n < 1200
   plot(xB,yB,'wo');
else
   plot(xB,yB,'w.');
end

hold off;
