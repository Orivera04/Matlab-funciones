% This function generates undersampling of the mesh lines from the matrices 
% usually passed to the SURF command.  Highly resolved surfaces drawings often
% look better than there low resolution counterparts, but the high density
% of mesh lines can obscure surface details.  Undersampling of the mesh lines can
% indicate important contour features, but must be done properly.  The undersampling 
% has to be performed carefully so that the mesh lines still track the surface
% features, something that is not obtained by simply rendering a lower
% resolution wireframe.
%
% SYNTAX: L=wireframe(X,Y,Z,N)
%
% Inputs:
%          X - NxM matrix of X-coordinate data
%          Y - NxM matrix of Y-coordinate data
%          Z - NxM matrix of Z-coordinate data
%          N - 1x1, 1x2, or 2x1 undersampling factor (Latitude x Longitude)
%
% Outputs:
%          L - A vector of handles to the latitudinal and longitudinal lines.
%
% Example:  wireframe;
%
% DBE 2005/12/08
%
% DBE 2005/12/11 - Added support for when X AND Y inputs are vectors.
% DBE 2005/12/12 - Fixed bug that caused stray lines to be generated. 

function L=wireframe(X,Y,Z,N)

% Default example...
if nargin==0
  f=figure; hold on; axis off; set(f,'color',[0 0 0]);
  N=25;  % Undersampling factor...
  [X,Y,Z]=sphere(250);
end

if isscalar(N)
  N=repmat(N,[1 2]);
end

if (isvector(X) & length(X)==size(Z,2)) & (isvector(Y) & length(Y)==size(Z,1))
  [X,Y]=meshgrid(X,Y);
elseif ~isequal(size(X),size(Y)) | ~isequal(size(Y),size(Z))
  error('Input arguments don''t have the right dimensions');
end

XS1=X([1:N(1):end end],:);  XS1(:,end+1)=NaN;  % Force inclusion of last data row & tag with NaN for line breaks
YS1=Y([1:N(1):end end],:);  YS1(:,end+1)=NaN;
ZS1=Z([1:N(1):end end],:);  ZS1(:,end+1)=NaN;

XS2=X(:,[1:N(2):end end]);  XS2(end+1,:)=NaN;  % Force inclusion of last data column & tag with NaN for line breaks
YS2=Y(:,[1:N(2):end end]);  YS2(end+1,:)=NaN;  
ZS2=Z(:,[1:N(2):end end]);  ZS2(end+1,:)=NaN;  

set(gcf,'NextPlot','Add');                    % Add surf lines to current plot...

L(1)=line(lin(XS1'),lin(YS1'),lin(ZS1'));     % Plot the latitudinal lines
  set(L(1),'Color',[0 0 0]);
L(2)=line(XS2(:),YS2(:),ZS2(:));              % Plot the longitudinal lines
  set(L(2),'Color',[0 0 0]);
  
% Continue with the default example...
if nargin==0
  S=surf(X,Y,Z);
    set(S,'Edgecolor','None','BackfaceLighting','Lit');
  view(45,45);
  l=light;
  axis equal
  camzoom(1.5);
  colormap(jet(1024));
end

return;

%  This function linearizes a matrix (m) of any dimension (eg M=m(:)).
%  If an index vector (ind) is given then the the ind entries of m(:) are
%  returned.
%
% SYNTAX: m=lin(m);
%         m=lin(m,ind);
%
% DBE 2003/12/22

function m=lin(m,ind);

m=m(:);

if nargin==2
  m=m(ind);
end

return