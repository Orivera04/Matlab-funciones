function ui=NewtFit(x,y,z,u,xi,yi,zi)
% Syntax: ui=NewtFit(x,y,z,u,xi,yi,zi)
% 3D interpolation. It may be used where griddata3 fails to find a
% triangularization of the datagrid (x,y,z).
% The function uses a modified 4 point Newton interpolation formula
% for vector arguments in 3D instread of scalars used in 1D.
% The interpolation is performed for the 4 nearest neighbors for each
% point in the (xi,yi,zi).
% u=u(x,y,z) is the data from which ui(xi,yi,zi) is interpolated
% x,y,z,u are vectors of same size and xi,yi,zi are also vectors.
% The fit is exact (u=ui) for points (xi,yi,zi) that coinside
% with data points (x,y,z). Note: NewtFit also delivers result for points outside
% the domain (i.e., extrapolation), but results may be inaccurate then.
%
% Created by: Per Sundqvist, Gothenburg University 2005
%
% %Example: Prepare data in random non-uniform grid
% xyz=rand(10003,3);
% x=xyz(:,1);y=xyz(:,2);z=xyz(:,3);
% u=x.^3+sin(pi*y).^2.*z.^2;
% 
% %Gridpoints to fit:
% xyz=rand(8007,3);
% xi=xyz(:,1);yi=xyz(:,2);zi=xyz(:,3);
%
% %Interpolate
% ui=NewtFit(x,y,z,u,xi,yi,zi);
%
% %compare and plot
% uui=xi.^3+sin(pi*yi).^2.*zi.^2;%exact
% plot(uui,ui,'.');pause(4)
% hist(uui-ui,60);
% standard_deviation=std(uui-ui)


%Covert to column and row vectors;
x=x(:);y=y(:);z=z(:);u=u(:);
sz=size(xi);    %Original input size
xi=xi(:);yi=yi(:);zi=zi(:);

%find index of 4 nearest neighbors for each ri
I4=find4near(x,y,z,xi,yi,zi);

% Newton 4-point interpolation with 3D vectors
f0=u(I4(1,:));
f1=u(I4(2,:));
f2=u(I4(3,:));
f3=u(I4(4,:));
D10=sqrt((x(I4(2,:))-x(I4(1,:))).^2+(y(I4(2,:))-y(I4(1,:))).^2+(z(I4(2,:))-z(I4(1,:))).^2);
D12=sqrt((x(I4(2,:))-x(I4(3,:))).^2+(y(I4(2,:))-y(I4(3,:))).^2+(z(I4(2,:))-z(I4(3,:))).^2);
D20=sqrt((x(I4(3,:))-x(I4(1,:))).^2+(y(I4(3,:))-y(I4(1,:))).^2+(z(I4(3,:))-z(I4(1,:))).^2);
D30=sqrt((x(I4(4,:))-x(I4(1,:))).^2+(y(I4(4,:))-y(I4(1,:))).^2+(z(I4(4,:))-z(I4(1,:))).^2);
D31=sqrt((x(I4(4,:))-x(I4(2,:))).^2+(y(I4(4,:))-y(I4(2,:))).^2+(z(I4(4,:))-z(I4(2,:))).^2);
D32=sqrt((x(I4(4,:))-x(I4(3,:))).^2+(y(I4(4,:))-y(I4(3,:))).^2+(z(I4(4,:))-z(I4(3,:))).^2);


A1=(f1-f0)./D10;
A2=((f2-f0)./D20+(f0-f1)./D10)./D12;
A3=(D12.*((f3-f0)./D30+(f0-f1)./D10)+D31.*((f1-f0)./D10+(f0-f2)./D20))./D12./D31./D32;
dv0=sqrt((xi-x(I4(1,:))).^2+(yi-y(I4(1,:))).^2+(zi-z(I4(1,:))).^2);
dv1=sqrt((xi-x(I4(2,:))).^2+(yi-y(I4(2,:))).^2+(zi-z(I4(2,:))).^2);
dv2=sqrt((xi-x(I4(3,:))).^2+(yi-y(I4(3,:))).^2+(zi-z(I4(3,:))).^2);

ui=f0+A1.*dv0+A2.*dv0.*dv1+A3.*dv0.*dv1.*dv2;
ui=reshape(ui,sz);

function I4=find4near(x,y,z,xi,yi,zi)
% Find the 4 nearest neighbor-indexes for each point ri
% I4 is a 4xN matrix, where N is the length of xi.
% Divide into blocks of memory reasons

%Covert to column and row vectors;
x=x(:);y=y(:);z=z(:);
xi=xi(:)';yi=yi(:)';zi=zi(:)';

Nd=length(x);
Nv=length(xi);
p=floor(Nv*Nd/1e6); %1000x1000 matrix maximum
if p~=0
    n=floor(Nv/p);
    n_rest=Nv-p*n;
    Rij=zeros(Nd,p);Idx=zeros(Nd,p);I4=zeros(4,Nv);   %allocate memory
    for j=1:p
        ind=(1+(j-1)*n:1:j*n);
        Rij=(x*ones(1,n)-ones(Nd,1)*xi(ind)).^2+...
            (y*ones(1,n)-ones(Nd,1)*yi(ind)).^2+...
            (z*ones(1,n)-ones(Nd,1)*zi(ind)).^2;
        [Rij,Idx]=sort(Rij);
        I4(1:4,ind)=Idx(1:4,:);
    end
    ind=(n*p+1:1:Nv);clear Rij Idx;
    Rij=(x*ones(1,n_rest)-ones(Nd,1)*xi(ind)).^2+...
        (y*ones(1,n_rest)-ones(Nd,1)*yi(ind)).^2+...
        (z*ones(1,n_rest)-ones(Nd,1)*zi(ind)).^2;
    [Rij,Idx]=sort(Rij);
    I4(1:4,ind)=Idx(1:4,:);
else
    Rij=(x*ones(1,Nv)-ones(Nd,1)*xi).^2+...
            (y*ones(1,n)-ones(Nd,1)*yi).^2+...
            (z*ones(1,n)-ones(Nd,1)*zi).^2;
    [Rij,Idx]=sort(Rij);
    I4=Idx(1:4,:);
end

