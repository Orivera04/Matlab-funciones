%BUCKYDEM Connectivity graph of the Buckminster Fuller geodesic dome.

%	Mark W. Reichelt, 6-30-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

[B,V] = bucky;
H = sparse(60,60);
k = 31:60;
H(k,k) = B(k,k);
x = V(:,1);
y = V(:,2);

if ssinit(figNumber)
  subplot(1,1,1);		% clean up if the stop button was hit
  gplot(H,V,'m-')
  axis('equal','off');
  hold on
  gplot(B-H,V,'c-');
  hold off

  str = str2mat( ...
    ' Press the "Start" button for an explanation of the', ... 
    ' relationship between graphs and matrices and a good ', ...  
    ' application of SPARSE matrices.', ...
    ' ', ...
    ' ', ...
    ' >> gplot(H,V,''m-'')', ...
    ' >> axis(''equal'',''off'');', ...
    ' >> hold on', ...
    ' >> gplot(B-H,V,''c-'');', ...
    ' >> hold off' ...
  );

  ssdisp(figNumber,str);

  if figNumber, return; end
end                                       

% Beginning of the demo ==================

%% begin the expo text

str = str2mat( ...
  ' A graph is a set of nodes with specified connections between', ...
  ' them.', ...
  ' ', ...
  ' An example is the connectivity graph of the Buckminster Fuller', ...
  ' geodesic dome (also a soccer ball or a carbon-60 molecule).', ...
  ' ', ...
  ' In MATLAB, the graph of the geodesic dome can be generated', ...
  ' with the BUCKY function:', ...
  ' ', ...
  ' >> [B,V] = bucky' ...
);
ssdisp(figNumber,str);

if sspause(figNumber), return; end;


subplot(1,2,1)
p = plot([0 1 1 0 0],[1 1 0 0 1],[0 1 1 0],[1 1 0 0],'.');
d = 0.25;
text([-0.25, 1.2 -0.25, 1.2],[1.2, 1.2, -.2, -.2],['1234']')
set(gca,'Units','pixels')
set(p,'MarkerSize',30);
axis([-1 2 -1 2])
axis off
subplot(1,2,2)
A = [0 1 1 0 ; 1 0 0 1 ; 1 0 0 1 ; 0 1 1 0];
%plotmat(A)
xtemp = [1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4];
ytemp = [1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4];
t = ['0110100110010110']';
text(xtemp-.5,ytemp-.5,t,'HorizontalAlignment','center');
set(gca,'xLim',[0,4],'YLim',[0 4],'Visible','off')
line([0 0],[0 4])
line([4 4],[0 4])
line([0 0.25],[0 0])
line([0 0.25],[4 4])
line([4 3.75],[0 0])
line([4 3.75],[4 4])

str = str2mat( ...
  ' A graph can be represented by its adjacency matrix.', ...
  ' ', ...
  ' To construct the adjacency matrix, the nodes are numbered', ...
  ' 1 to N.  Then element (i,j) of the matrix is set to 1 if node i is', ...
  ' connected to node j, and 0 otherwise.' ...
);
ssdisp(figNumber,str);

if sspause(figNumber), return; end;


subplot(1,1,1)
gplot(B(1:30,1:30),[x(1:30) y(1:30)],'m-')
for j = 1:30
  text(x(j),y(j),int2str(j));
end
axis('equal','off');

str = str2mat( ...
  ' Here are the nodes in one hemisphere of the bucky ball,', ...
  ' numbered pentagon by pentagon.', ...
  ' ', ...
  ' ', ...
  ' >> gplot(B(1:30,1:30),[x(1:30) y(1:30)],''m-'')', ...
  ' >> for j = 1:30, text(x(j),y(j),int2str(j)); end', ...
  ' >> axis(''equal'',''off'');' ...
);
ssdisp(figNumber,str);                                    

if sspause(figNumber), return; end;


spy(B(1:30,1:30)), title('spy(B(1:30,1:30))')

str = str2mat( ...
  ' To visualize the adjacency matrix of this hemisphere, we', ...
  ' use the SPY function to plot the silhouette of the nonzero', ...
  ' elements.', ...
  ' ', ...
  ' >> spy(B(1:30,1:30)), title(''spy(B(1:30,1:30))'')', ...
  ' ', ...
  ' ', ...
  ' Note that the matrix is symmetric, since if node i is', ...
  ' connected to node j, then node j is connected to node i.' ...
);
ssdisp(figNumber,str);                                       

if sspause(figNumber), return; end;


gplot(B(1:30,1:30),[x(1:30) y(1:30)],'m-')
axis('equal','off'); hold on
gplot(B(31:60,31:60),[x(31:60) y(31:60)],'c-')
for j = 31:60
  text(x(j),y(j),int2str(j));
end
hold off

str = str2mat( ...
  ' Now we extend our numbering scheme to the whole graph', ...
  ' by reflecting the numbering of one hemisphere into the', ...
  ' other.', ...
  ' ', ...
  ' ', ...
  ' >> gplot(B(1:30,1:30),[x(1:30) y(1:30)],''m-'')', ...
  ' >> axis(''equal'',''off''); hold on', ...
  ' >> gplot(B(31:60,31:60),[x(31:60) y(31:60)],''c-'')', ...
  ' >> for j = 31:60, text(x(j),y(j),int2str(j)); end' ...
);
ssdisp(figNumber,str);                                   

if sspause(figNumber), return; end;


spy(B), title('spy(B)')

str = str2mat( ...
  ' Finally, here is a SPY plot of the final sparse matrix.', ...
  ' ', ...
  ' >> spy(B), title(''spy(B)'')' ...
);
ssdisp(figNumber,str);

if sspause(figNumber), return; end;


gplot(H,V,'m-')
axis('equal','off');
hold on
gplot(B-H,V,'c-');
hold off

str = str2mat( ...
  ' In many useful graphs, each node is connected to only a', ...
  ' few other nodes.  As a result, the adjacency matrices', ...
  ' contain just a few nonzero entries per row.', ...
  ' ', ...
  ' This demo has shown one place where SPARSE matrices', ...
  ' come in handy.' ...
);
ssdisp(figNumber,str);


% End of the demo ========================
