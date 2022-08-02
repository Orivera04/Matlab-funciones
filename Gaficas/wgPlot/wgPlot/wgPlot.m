function [hE,hV]=wgPlot(adjMat,coord,varargin)
%function [hE,hV]=wgPlot(adjMat,coord,varargin)
%
% Weighted Graph Plot from adjacency matrix [adjMat] and vertices
% coordinate [coord].
%
% INPUT:
%    [adjMat] = N x N sparse square adjacency matrix. 
%     [coord] = N x 2 matrix of vertex coordinates of the graph to be plotted.
%  [varargin] = are specified as parameter value pairs where the parameters are
%     'edgecolormap' = m1 x 3 edge colormap for coloring edges by their 
%                      weight, {default=cool}
%        'edgewidth' = scalar specifying the width of the edges. {default=0.5}
%   'vertexcolormap' = m2 x 3 vertex color map for coloring vertices by their
%                      weight, {default=summer}
%     'vertexweight' = N x 1 vector of vertex weight that overrides using the
%                      diagonal of [adjMat] for specifying vertex size.
%      'vertexscale' = scalar vertex scaling factor for specifying scaling
%                      the size of vertices. {default=100}
%   'vertexmetadata' = N x 1 vector of vertex meta data for coloring the verticies.
% OUTPUT:
%  [hE] = vector/scalar of handles to edges of the drawn graph (1 per color).
%  [hV] = scalar handles to vertices of the drawn graph.
% 
% SEE ALSO: gplot, gplot2, gplotwl, treeplot, spy
%
% By: Michael Wu  --  michael.wu@lithium.com (May 2009)
%
%====================


% Set default parameter values
%--------------------
h=gca; prh; hold on; axis off;
axesArea(h,[6 7 4 5]);
plotParm={};
siz=size(adjMat);
vrtxSiz=100;
edgeMap=cool;
vrtxMap=summer;


% Parse parameter value pairs
%--------------------
nVarArgin=length(varargin);
for kk=1:2:nVarArgin
	switch lower(varargin{kk})
    case 'edgecolormap'
      edgeMap=varargin{kk+1};
    case 'edgewidth'
      plotParm=[plotParm,{'lineWidth',varargin{kk+1}}];
    case 'vertexcolormap'
      vrtxMap=varargin{kk+1};
    case 'vertexweight'
      vrtxWt=varargin{kk+1};
    case 'vertexmetadata'
      vrtxCol=varargin{kk+1};
    case 'vertexscale'
      vrtxSiz=varargin{kk+1};
    otherwise
      error(['wgPlot >< Unknown parameter ''',varargin{kk},'''.']) ;
  end
end


% Determine if diagonal is weighted.
%--------------------
if exist('vrtxWt','var')
  vWt=vrtxWt;
else
  vWt=diag(adjMat);
end
vWeighted=length(setdiff(unique(vWt),0))>1;


% Map edge weight to edge colormap
%--------------------
if ~all(vWt==0)
  adjMat(speye(siz)~=0)=0;
end  % if ~any


% Determine if edges are weighted
%--------------------
[ii,jj,eWt] = find(adjMat);
minEWt=min(eWt);
maxEWt=max(eWt);
eWtRange=maxEWt-minEWt;
eWeighted=eWtRange>0;


% Map edge weight to edge colormap
%--------------------
if eWeighted
  neColor=size(edgeMap,1);
  eWt=ceil((neColor-1)*(eWt-minEWt)/(maxEWt-minEWt)+1);
end  % if eWtRange


% Plot edges
%--------------------
if eWeighted
  hE=[];
  maxX=max(coord(:,1));
  minX=min(coord(:,1));
  maxY=max(coord(:,1));
  minY=min(coord(:,1));  
  legLim=linspace(minX,maxX,neColor+1);
  yStep=(maxY-minY)/20;
  legY=minY-yStep;
  
  for kk=1:neColor
    p=find(eWt==kk);
    nSegment=length(p);
    x=[coord(ii(p),1),coord(jj(p),1),repmat(nan,nSegment,1)]';
    y=[coord(ii(p),2),coord(jj(p),2),repmat(nan,nSegment,1)]';
    hE=[hE,plot(x(:),y(:),'color',edgeMap(kk,:),plotParm{:})];
    % Draw legend bar
    line([legLim(kk),legLim(kk+1)],[legY,legY],'lineWidth',15,'color',edgeMap(kk,:));
  end  % for kk
  
  % Draw Legend Label
  text([legLim(1),legLim(end)],[legY-0.5*yStep,legY-0.5*yStep], ...
    {num2str(minEWt),num2str(maxEWt)},'HorizontalAlignment','center');
else
    nSegment=length(ii);
    x=[coord(ii,1),coord(jj,1),nan(nSegment,1)]';
    y=[coord(ii,2),coord(jj,2),nan(nSegment,1)]';
    hE=plot(x(:),y(:),plotParm{:});
end  % if eWeighted


% Plot vertices
%--------------------
if vWeighted
  % Map vertex weight to vertex size
  %--------------------
  minVwt=min(vWt);
  maxVwt=max(vWt);
  vWt=vrtxSiz*(vWt-minVwt)/(maxVwt-minVwt)+1;
  
  % Map vertex metadata to vertex colormap
  %--------------------
  if exist('vrtxCol','var')
    colormap(vrtxMap);
    hV=scatter(coord(:,1),coord(:,2),vWt,vrtxCol,'filled');
    colorbar;
  else
    hV=scatter(coord(:,1),coord(:,2),vWt,'g','filled');
  end
  
else
  hV=plot(coord(:,1),coord(:,2),'g.');
end
axis tight;



