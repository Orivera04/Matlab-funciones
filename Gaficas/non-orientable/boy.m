function boy(figNumber,GalleryGUIFlag)
% BOY  Draw Boy's surface.
	
%   Barbara Kuhn , Univerity of Stuttgart. 19/01/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' boy surface                                   '  
         ' by B. Kuhn                                    '  
         '                                               '  
         '                                               '  
         ' File name: boy.m                              '];
gallinit(figNumber,infoStr);

box = [-2 2 -2 2 -2 2];
vue = [0.01 0.01 0.01];

set(gcf,'color',[.7 .8 .9]);
boys(box,vue);
shading interp
%map = [1 0 0];
colormap(autumn);
axis tight;

%----------------------------------------------------------
function boys(box, vue)

ac = 101;
as = 101;
w1 = 0;
w2 = 360;
r1 = 0;
r2 = 1;
%	$$;
w1 = (w1/180.0) * 3.14159265358979;
w2 = (w2/180.0) * 3.14159265358979;
du  = (w2 -w1 )/(ac -1);
u1  = w2 ;
dv  = (r2 -r1 )/(as -1);
v1  = r2  ;
u   = w1 ;
v   = r1 ;
%       $$
%       $$ ------ punkte erzeugen
qq  = 2.236068;
ep  =-.5;
ip = 1;

xx= zeros(as,ac);
yy= zeros(as,ac);
zz= zeros(as,ac);

for i =1 : as
	   v = r1 + (i-1)*dv;
	   for k = 1: ac
		   u =w1 +(k-1)*du ;
		   x1 =v *cos(u );
		   y1 =v *sin(u );
		   n  = v *v *v ;
		   x3 =n *cos(3*u );
		   y3 =n *sin(3*u );
		   n =n *v *v ;
		   x5 =n *cos(5*u );
		   y5 =n *sin(5*u );
		   n =n *v ;
		   x6 =n *cos(6*u );
		   y6 =n *sin(6*u );
		   h1 =2*x6 +2*qq *x3 -2;
		   h2 =2*y6 +2*qq *y3 ;
		   z11 =3*y5 -3*y1 ;
		   z12 =-3*x5 +3*x1 ;
		   z21 =-3*x5 -3*x1 ;
		   z22 =-3*y5 -3*y1 ;
		   z31 =2*y6 ;
		   z32 =-2*x6 -2;
		   n =h1 *h1 +h2 *h2 ;
		   f11 =(h1 *z11 +h2 *z12 )/n ;
		   f22 =(h1 *z21 +h2 *z22 )/n ;
		   f33 =(h1 *z31 +h2 *z32 )/n +ep ;
		   gg =f11 *f11 +f22 *f22 +f33 *f33 ;
		   xx(i,k) =f11 /gg;
		   yy(i,k)=f22 /gg;
		   zz(i,k) =-f33 /gg;
	   end
   end

   surface(xx,yy,zz, ...
    'EdgeColor','none', ...
    'FaceColor',[0.8 0.2 0.2], ...
    'FaceLighting','phong', ...
    'AmbientStrength',0.3, ...
    'DiffuseStrength',0.6, ... 
    'Clipping','off',...
    'BackFaceLighting','lit', ...
    'SpecularStrength',1.1, ...
    'SpecularColorReflectance',1, ...
    'SpecularExponent',7);
l1 = light('Position',[40 100 20], ...
    'Style','local', ...
    'Color',[0 0.7 0.7]);
l2 = light('Position',[.5 -1 .4], ...
    'Color',[1 1 0]);
   axis(box)
   axis('off')
   view(vue)