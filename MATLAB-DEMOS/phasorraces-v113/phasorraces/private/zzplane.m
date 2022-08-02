function  [hzero,hpole] = zzplane(z, p, zmax)
%ZZPLANE      plot zeros (o) and poles (x) in the z-plane
%
% Usage:   [hzero,hpole] = zzplane( Zeros, Poles, RadiusMax )
%        Zeros : vector of zeros
%        Poles : vector of poles  (OPTIONAL)
%                 (can be [], if 3rd arg is needed)
%    RadiusMax : size of plot for scaling  (OPTIONAL)
%                 (disables auto scaling calculations)
%     hzero = handle to the zeros
%     hpole = handle to the poles
%

%  27-Oct-98 Jim McClellan
%  03-Aug-02 Rajbabu, added code to dipslay multiplicity of Poles/Zeros
  
if( nargin == 1 )
   p = [];
end
rmax = max( [ abs(z(:)); abs(p(:)) ] );
rmin = min( [ abs(z(:)); abs(p(:))] );
if( rmax/rmin > 100 )
   disp('***** WARNING: DYNAMIC RANGE of ROOTS is > 100 *****' )
   disp('     ===> may need to replot to see them all <===' )
end
if( nargin < 3 )   %--- need to figure out the scaling
   zmax = 1.333;
   if( rmax > 50 )
      zmax = 10*ceil( ceil( rmax )/10 );
   elseif( rmax > 10 )
      zmax = 5*ceil( ceil( rmax )/5 );
   elseif( rmax > 1.333 )
      zmax = ceil( rmax );
   elseif( rmax < 0.09 )
      zmax = 10 .^ fix( log10(rmax) );
   end
elseif( rmax > zmax )
   disp('*** WARNING: some roots are too big to fit on plot ***')
end
plot( [-zmax;zmax],[0;0],':');
hold on
plot([0;0],[-zmax;zmax],':')
axis( zmax*[-1 1 -1 1])
axis('square')
%axis('equal')
if( zmax <= 20 )        %--- then put a UNIT CIRCLE on the plot
   oh=plot( sin(0:.01:2*pi),cos(0:.01:2*pi),':' );
end
posx = get(gca,'position');
marksize = sqrt(posx(3))*13;
hzero=[];hpole=[];
if ~isempty(z)
   hzero = plot(real(z),imag(z),'o');
   set(hzero,'MarkerSize',marksize)
   set(hzero,'linewidth',1.7)
end
if ~isempty(p)
   hpole = plot(real(p),imag(p),'x');
   set(hpole,'MarkerSize',marksize*1.2)
   set(hpole,'linewidth',1.7)
end
%xlabel('REAL PART');ylabel('IMAGINARY PART')

% From zplane.m 

handle_counter = 2;	
%fuzz = diff(xl)/80; % horiz spacing between 'o' or 'x' and number
fuzz=0;
[r,c]=size(z);
if (r>1)&(c>1),  % multiple columns in z
   ZEE=z;
else
   ZEE=z(:); c = min(r,c);
end;
for which_col = 1:c,      % for each column of ZEE ...
   z = ZEE(:,which_col);
   [mz,z_ind]=mpoles(z);
   for i=2:max(mz),
      j=find(mz==i);
      for k=1:length(j),
         x = real(z(z_ind(j(k)))) + fuzz;
         y = imag(z(z_ind(j(k))));
         if (j(k)~=length(z)),
            if (mz(j(k)+1)<mz(j(k))),
               oh(handle_counter) = text(x,y,num2str(i),'FontWeight','bold',...
					 'FontUnits','Normal'); 
               handle_counter = handle_counter + 1;
            end
         else
            oh(handle_counter) = text(x,y,num2str(i),'FontWeight','bold',...
				      'FontUnits','Normal');
            handle_counter = handle_counter + 1;
         end
      end
   end
end
[r,c]=size(p);
if (r>1)&(c>1),  % multiple columns in z
   PEE=p;
else
   PEE=p(:); c = min(r,c);
end;
for which_col = 1:c,      % for each column of PEE ...
   p = PEE(:,which_col);
   [mp,p_ind]=mpoles(p);
   for i=2:max(mp),
      j=find(mp==i);
      for k=1:length(j),
         x = real(p(p_ind(j(k)))) + fuzz;
         y = imag(p(p_ind(j(k))));
         if (j(k)~=length(p)),
            if (mp(j(k)+1)<mp(j(k))),
               oh(handle_counter) = text(x,y,num2str(i),'FontWeight','bold',...
					 'FontUnits','Normal');
               handle_counter = handle_counter + 1;
            end
         else
            oh(handle_counter) = text(x,y,num2str(i),'FontWeight','bold',...
				      'FontUnits','Normal');
            handle_counter = handle_counter + 1;
         end
      end
   end
end
set(oh(2:length(oh)),'vertical','bottom','horizontal','right');

hold off


