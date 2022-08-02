function	shim(U,X,Y)
%SHow IMage
%Call:
%					U=shim(U,X,Y)		
%Input:
%				U = data matrix
%               X,Y = coordinates, optional
%Output:
%			image of U
%
%	Vassili Pastushenko	 March 2005
%==============================
U=double(U);

NARG=nargin;
if NARG==2
    error('Y-coordinates not specified');
end

if NARG==1
surf(U)
else
    surf(X,Y,U)
end

shading interp
view(0,90)    
set(gca,'TickDir','out','dataaspectratio',[1 1 1],'Fontsize',15)
axis tight
figure(gcf)

