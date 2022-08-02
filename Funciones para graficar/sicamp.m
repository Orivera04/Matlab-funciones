% sicanp.m: ******************************************************
%
% Satellites In Communications And Navigation - Project
%
% ****************************************************************

   clear all;

% problem 1

   radius = 6378.14;		% earth radius (at ground station)
   
% constellation paths
   
   nplanes = 4;			% number of planes
   nsatpla = 8;			% number of satellites per plane
   altitud = 20000;		% constellation altitude
   inclina = 45;		% constellation inclination in degrees
   numbint = 200;		% number of intervals
   
% interest region

   lat  = [20 40 ];
   long = [60 100];
   
% constants computation
   
   radcons = radius+altitud;	% radius at constellation altitude
   inclina = inclina*pi/180;	% inclination in rad
   anginc  = 2*pi/numbint;	% increment in rad
   depinc  = 2*pi/nplanes;	% dephase increment
   intsat  = 2*pi/nsatpla;	% intersatellite angle

% earth mesh
   
   meshint = 25;
   dfi =   pi/(meshint-1); fiv = [0:dfi:  pi]; fi = kron( fiv',ones( 1,meshint ) );
   dth = 2*pi/(meshint-1); thv = [0:dth:2*pi]; th = kron( thv ,ones( meshint,1 ) );
   xe = radius.*sin( fi ).*cos( th );
   ye = radius.*sin( fi ).*sin( th );
   ze = radius.*cos( fi );

% path traces
   
   theta = kron( [0:anginc:2*pi],ones( nplanes,1 ) ) ;
   phi   = kron( (pi/2)*ones( 1,numbint+1 ),ones( nplanes,1 ) );
   depha = kron( [0:depinc:2*pi-depinc]',ones( 1,numbint+1 ) );

   x1 = radcons.*sin( phi ).*cos( theta );
   y1 = radcons.*sin( phi ).*sin( theta );
   z1 = radcons.*cos( phi );

   y2 = +y1.*cos( inclina )+z1.*sin( inclina );
   zs = -y1.*sin( inclina )+z1.*cos( inclina );
   
   xs = +x1.*cos( depha )+y2.*sin( depha );
   ys = -x1.*sin( depha )+y2.*cos( depha );
   
% satellite positions

   theta = kron( [0:intsat:2*pi-intsat],ones( nplanes,1 ) ) ;
   phi   = kron( (pi/2)*ones( 1,nsatpla ),ones( nplanes,1 ) );
   depha = kron( [0:depinc:2*pi-depinc]',ones( 1,nsatpla ) );

   x1 = radcons.*sin( phi ).*cos( theta );
   y1 = radcons.*sin( phi ).*sin( theta );
   z1 = radcons.*cos( phi );

   y2 = +y1.*cos( inclina )+z1.*sin( inclina );
   zS = -y1.*sin( inclina )+z1.*cos( inclina );
   
   xS = +x1.*cos( depha )+y2.*sin( depha );
   yS = -x1.*sin( depha )+y2.*cos( depha );
   
% interest region

   meshint = 4;
   lat = (90-lat)*pi/180; long = long*pi/180;
   dfi = (lat (1)-lat (2))/(meshint); fiv = [lat(2) :dfi:lat(1) ]; fi = kron( fiv ,ones( meshint+1,1 ) );
   dth = (long(2)-long(1))/(meshint); thv = [long(1):dth:long(2)]; th = kron( thv',ones( 1,meshint+1 ) );
   xi = 1.01*radius.*sin( fi ).*cos( th );
   yi = 1.01*radius.*sin( fi ).*sin( th );
   zi = 1.01*radius.*cos( fi );
   ci = 100*ones( size( xi ) );

% display model

   surf( xe,ye,ze ); grid on; hold on;	% earth
   surf( xi,yi,zi,ci ); grid on; hold on;	% interest region
   
   for idx = 1:nplanes
      plot3( xs(idx,:),ys(idx,:),zs(idx,:),'k-' ); hold on;
      plot3( xS(idx,:),yS(idx,:),zS(idx,:),'ko' ); hold on;
   end
   
% end of file: sicanp.m ******************************************

