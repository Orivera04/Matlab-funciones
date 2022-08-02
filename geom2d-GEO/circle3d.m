% Calculates the N+1 coordinates of a 3D circle,  
% of radius R, center rc = [xc yc zc], and lying on 
% the plane defined by vectors r1 e r2. 
%
% SINTAX: [x,y,z] = circle3d( rc, r1, r2, R , N )
%
% Example:  o = [0 0 0]; ex = [1 0 0];ey = [0 1 0];ez = [0 0 1];
%           R = 5; N = 101;
%          [x,y,z] = circle3d( o, ex, ex+ez, R, N ); plot3(x,y,z)
%

% Written by Orlando Camargo Rodriguez 

function [x,y,z] = circle3d( rc, r1, r2, R, N ) 

x = [];
y = [];
z = []; 

i = sqrt( -1 ); 

ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];

if exist('N') == 0, N = 50; end
if exist('R') == 0, R =  1; end

if length( rc ) ~= 3, disp('Circle'' center should be a 3D vector!'), return, end 
if length( r1 ) ~= 3, disp('r1 should be a 3D vector!'), return, end 
if length( r2 ) ~= 3, disp('r2 should be a 3D vector!'), return, end

R1 = r1 - rc;
R2 = r2 - rc; 

tolerance = 1 - abs( sum( R1.*R2 )/( norm( R1 )*norm( R2 ) ) );

if tolerance < 1e-10, disp('r1 and r2 are colinear within the functions'' tolerance!'), return, end

R1_times_R2 = vector_product( R1 , R2 ); 
R3          = vector_product( R1, R1_times_R2 );  

Ex = R1/norm( R1 );
Ey = R3/norm( R3 );
Ez = R1_times_R2/norm( R1_times_R2 );

delta_theta = 2*pi/N;

theta = [0:delta_theta:2*pi];

z = exp( i*theta );

xc = R*real( z );
yc = R*imag( z );
zc = zeros([1 N+1]); clear z

R(1,1) = sum( Ex.*ex ); R(1,2) = sum( Ex.*ey ); R(1,3) = sum( Ex.*ez ); 
R(2,1) = sum( Ey.*ex ); R(2,2) = sum( Ey.*ey ); R(2,3) = sum( Ey.*ez ); 
R(3,1) = sum( Ez.*ex ); R(3,2) = sum( Ez.*ey ); R(3,3) = sum( Ez.*ez );

for n = 1:N+1

    r(:,n) = R*[xc(n) yc(n) zc(n)]';
    
end 

x = r(1,:) + rc(1);
y = r(2,:) + rc(2);
z = r(3,:) + rc(3);

function a_times_b = vector_product( a , b ) ; 

a_times_b = [ ] ;

a_times_b(1) = a(2)*b(3) - a(3)*b(2);  
a_times_b(2) = a(3)*b(1) - a(1)*b(3); 
a_times_b(3) = a(1)*b(2) - a(2)*b(1); 

