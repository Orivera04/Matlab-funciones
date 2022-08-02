function [uv]=CircularParametrizer(t)
%  CIRCULARPARAMETRIZER:
%     [uv]=CircularParametrizer(t) returns a set of 2D coordinates from a
%     3D triangulated surface. 2D points are disposed inside a circle of
%     unit radius so they represent a parametrization of the initial
%     surface. The triangulation is represented by the n x 3 t array.
% 
%  
%   Triangulation requirements:
%  
%     The triangulation must be manifold with just one boundary. The boundary
%     of the surface will also be the bonudary of the parametric space.
%     In all others cases errors maybe generated.      
%
%   Algorithm informations:
%
%     The parametrization if perfomed using the Springs collapse method.
%     This ensure no self-intersecant triangles  will be in the Output.
%
%   For examples see the demo file.
%
%   Author: Giaccari Luigi, giaccariluigi@msn.com,
%              http://giaccariluigi.altervista.org/blog/ 
%   Created: 5/4/2009
%     
%     See also DelaunayTri, voronoi, trimesh, trisurf, triplot, griddata, convhull,
%              dsearch, tsearch, delaunay3, delaunayn, qhull.




%errors check

if nargin>1
     error('Only one input supported');
end   

if nargout>1
     error('Only one output supported');
end   

[m,n]=size(t);
if n~=3
    error('Input must be a n x 3 array');
end


%Main

startprogram=clock;
fprintf('Program started\n\n')

%find edge,lfag boundary ones
e = sortrows( sort([t(:,[1,2]); t(:,[1,3]); t(:,[2,3])],2) );
idx = all(diff(e,1)==0,2);                                                 % Find shared edges
idx = [idx;false]|[false;idx];                                             % True for all shared edges
ebnd = e(~idx,:);                                                           % Boundary edges
                                            % Unique edges and bnd edges for tri's

%find boundary nodes
np=max(max(t));%number of points
pbnd=false(np,1);
pbnd(ebnd(:))=true;



n=sum(pbnd);
ne=size(e,1);

fprintf('\t\t-Boundary recostruction ....................')
start=clock;
pb=BoundaryRecostruction(ebnd);%to sort the point of the boumdary in the correct order
time=etime(clock,start);
fprintf('Done %4.4f s\n',time)

fprintf('\t\t-Assembling System .........................')
start=clock;
%connection/stiffness matrix
K=sparse([e(:,1);e(:,2)],[e(:,2);e(:,1)],ones(ne+ne,1),np,np,ne+ne+np);


%inizializzazioni uv
uv=zeros(np,2);
passo=(2*pi)/n;
teta=linspace(0,2*pi-passo,n);
r=1*ones(1,n);

uv(pb,1)=r.*cos(teta);
uv(pb,2)=r.*sin(teta);
%force vector
ffxy=K(~pbnd,pbnd)*uv(pbnd,:);

%stiffness
K=-K(~pbnd,~pbnd)+diag(sum(K(~pbnd,:),2));
time=etime(clock,start);
fprintf('Done %4.4f s\n',time)

%solve system
start=clock;
fprintf('\t\t-Solve the system ..........................')
uv(~pbnd,:)=K\ffxy;
time=etime(clock,start);
fprintf('Done %4.4f s\n',time)

time=etime(clock,startprogram);
fprintf('\nProgram exited in %4.4f s\n',time)

end



function [pb]=BoundaryRecostruction(eb)
     

    if isempty(eb)
        error('No boundary edges');
    end
     
    %start new boundary
    pb=eb(1,:);
    startpoint=pb(1);

    searchpoint=eb(1,2);
    eb(1,1)=0;eb(1,2)=0;%delete current edge
    count=3;

    while startpoint~=searchpoint
        [r,c]=find(eb==searchpoint,1);%se la ricerca è vuota è finito un spigolo
    
        if c==1
            pb(count)=eb(r,c+1);
            searchpoint=eb(r,c+1);
            count=count+1;
        elseif c==2
            pb(count)=eb(r,c-1);
            searchpoint=eb(r,c-1);
            count=count+1;
        else
            error('Boundary is not closed');
        end
        eb(r,1)=0;eb(r,2)=0;



    end
    pb(end)=[];%delete last point
    
    if length(pb)<size(eb,1)
        warning('Surface may contains more than one boundary');
    end

end

