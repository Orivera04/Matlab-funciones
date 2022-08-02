function x=examplmo(mm,kk,f1,f2,x0,v0,wfe,mv)
%
% x=examplmo(mm,kk,f1,f2,x0,v0,wfe,mv)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Evaluate the response caused when a downward
% load at the middle and an upward load at the 
% free end is applied.
%
% mm, kk - mass and stiffness matrices
% f1, f2 - forcing function magnitudes
% x0, v0 - initial position and velocity
% wfe    - forcing function frequency
% mv     - matrix of modal vectors
%
% User m functions called:  frud, animate, inputv
%----------------------------------------------

w=0; n=length(x0); t0=0; x=[];
s1=['\nEvaluate the time response from two',...
  '\nconcentrated loads. One downward at the',...
  '\nmiddle and one upward at the free end.'];
while 1
  fprintf(s1), fprintf('\n\n') 
  fprintf('Input the time step and ')
  fprintf('the maximum time ')
  fprintf('\n(0.04 and 5.0) are typical.')
  fprintf(' Use 0,0 to stop\n')
  [h,tmax]=inputv; 
  if norm([h,tmax])==0 | isnan(h), return, end
  disp(' ')

  [t,x]= ...
     frud(mm,kk,f1,f2,w,x0,v0,wfe,mv,h,tmax);
  x=x(:,1:2:n-1); x=[zeros(length(t),1),x];
  [nt,nc]=size(x); hdist=linspace(0,1,nc);

  clf, plot(t,x(:,nc),'k-')
  title('Position of the Free End of the Beam')
  xlabel('dimensionless time')
  ylabel('end deflection'), figure(gcf)
  disp('Press [Enter] for a surface plot of')
  disp('transverse deflection versus x and t')
  pause 
  print -deps endpos1 
  xc=linspace(0,1,nc); zmax=1.2*max(abs(x(:)));

  clf, surf(xc,t,x), view(30,35)
  colormap([1 1 1]) 
  axis([0,1,0,tmax,-zmax,zmax])
  xlabel('x axis'); ylabel('time') 
  zlabel('deflection')
  title(['Cantilever Beam Deflection ' ...
         'for Varying Position and Time'])
  figure(gcf); 
  print -deps endpos2
  disp(' '), disp(['Press [Enter] to animate',...
        ' the beam motion'])
  pause 
  
  titl='Cantilever Beam Animation'; 
  xlab='x axis'; ylab='displacement';
  animate(hdist,x,0.1,titl,xlab,ylab), close
end