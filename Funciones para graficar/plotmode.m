function plotmode(a,b,x,y,eigs,modes,indx)
%
% plotdmode(a,b,x,y,eigs,modes,indx)
% This function makes animated plots of the
% function for of an elliptic membrane for
% various frequencies
% a,b    - major and minor semi-diameters
% x,y    - arrays of points defining the
%          curvilinear coordinate grid
% eigs   - vector of sorted frequencies
% modes  - array of modal surfaces for 
%          the corresponding frequencies
% indx   - vector of indices designating
%          each mode as even (1) or odd (2)

range=[-a,a,-b,b,-a,a]; 
nf=25; ft=cos(linspace(0,4*pi,nf));
boa=[',   B/A = ',num2str(b/a,4)];
while 1
   disp(' ')
   jlim=input(['Give a vector of mode ',...
               'indices (try 10:2:20) > ? ']);
   if isempty(jlim) | any(jlim==0), break, end
   for j=jlim
      if indx(j)==1, type='EVEN'; f=1;
      else, type ='ODD '; f=-1; end
      u=modes(:,:,j); [um,k]=max(abs(u(:)));
      u=u/(2/a*u(k)); hold off
            
      for kk=1:nf
         surf(x,y,ft(kk)*u)
         axis equal, axis(range)
         xlabel('x axis'), ylabel('y axis')
         zlabel('u(x,y)')
         title([type,' MODE ',num2str(j),...
         ',  OMEGA = ',num2str(eigs(j),4),boa])
         %colormap([127/255 1 212/255])
         colormap([1 1 0])
         drawnow, shg
      end
      pause(1);
   end
end