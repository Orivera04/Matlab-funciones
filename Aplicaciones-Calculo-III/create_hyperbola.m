function points = create_hyperbola( a,b,phi_rad,X0,Y0,hyp_type,N )
%
% create_hyperbola - create a hyperbola (focies are based on the X axis) from the given 5 parameters
%
% Format:   points = create_hyperbola( a,b,phi_rad,X0,Y0,hyp_type,N )
%
% Input:    a,b,phi_rad,X0,Y0 - defines the hyperbola by the equation:
%                               hype_type = 1 => ((x-x0)/a)^2 - ((y-y0)/b)^2 = 1
%                               hype_type = 2 => ((y-y0)/a)^2 - ((x-x0)/b)^2 = 1                               
%                               with an orientation of phi (which MOVES the hyperbola)
%           N                 - number of output points, EVEN number, default 100
%
% Output:   points            - an array of poinst (x_set1;y_set1;x_set2;y_set2) of size 4x(N/2)
%
% Note:     the number of points must be EVEN, since an hyperbola is composed of 2 lines !
%

% check for missing input
if ~exist('N')
    N = 100;
else
    N = ceil( N/2 )*2;
end

% for debug
% =================
if ( nargin == 0 )
    close all; figure; axis equal; a = axis;
    for x = [0:0.1:2*pi 2*pi],
        X0 = 0; Y0 = 3; hyp_type = 1;   % = 1;
        R  = sqrt(X0^2+Y0^2);
        create_hyperbola( 1,1.5,x,X0,Y0,hyp_type );
        a2 = axis;
        if ( max(abs(a))<max(abs(a2)) )
            t = sqrt(2)*max(abs(a2));
            axis( [-t t -t t] );
        end
        hold on;
        if (R>0) rectangle( 'Position', [-R -R 2*R 2*R], 'Curvature', [1 1] ); end
        plot( 0,0,'*k','markersize',10 );
        hold off; grid; shg; drawnow; 
    end
    return
end
% =================
% end of for debug

% rotation matrix to rotate the axes with respect to an angle phi
R = [ cos(phi_rad) sin(phi_rad); -sin(phi_rad) cos(phi_rad) ];

% the hyperbola
theta1_r        = linspace(-pi*0.42,pi*0.42,N/2);
theta2_r        = pi + theta1_r;
switch hyp_type,
case 1,
    slope = b/a;
    hyperbola_x1_r  = X0 + a./cos( theta1_r );
    hyperbola_x2_r  = X0 + a./cos( theta2_r );
    hyperbola_y1_r  = Y0 + b*tan( theta1_r );
    hyperbola_y2_r  = Y0 + b*tan( theta2_r );
case 2,
    slope = a/b;
    hyperbola_x1_r  = X0 + b*tan( theta1_r );
    hyperbola_x2_r  = X0 + b*tan( theta2_r );
    hyperbola_y1_r  = Y0 + a./cos( theta1_r );
    hyperbola_y2_r  = Y0 + a./cos( theta2_r );
otherwise,
    error( 'iligal value for variable "hyp_type", choose 1 for a horizontal hyperbolam or 2 for a vertical one' );
end
points(1:2,:)   = R * [hyperbola_x1_r;hyperbola_y1_r];
points(3:4,:)   = R * [hyperbola_x2_r;hyperbola_y2_r];

% for debug
if (nargout == 0)
   
    % the axes
    C               = sqrt( a^2 + b^2 );
    switch hyp_type,
    case 1,
        ver_line        = [ [X0 X0]; Y0+b*[-1 1] ];
        horz_line       = [ X0+C*[-1 1]; [Y0 Y0] ];
    case 2,
        ver_line        = [ [X0 X0]; Y0+C*[-1 1] ];
        horz_line       = [ X0+b*[-1 1]; [Y0 Y0] ];
    end
    new_ver_line    = R*ver_line;
    new_horz_line   = R*horz_line;

    % the asymptotes: y = Y0 + slope*(x-X0), y = Y0 - slope*(x-X0)
    max_x           = max( max( [hyperbola_x1_r hyperbola_x2_r] ) );
    min_x           = min( min( [hyperbola_x1_r hyperbola_x2_r] ) );
    line1           = [ [min_x max_x]; Y0 + slope*([min_x max_x] - X0) ];
    line2           = [ [min_x max_x]; Y0 - slope*([min_x max_x] - X0) ];
    asymptote1      = R*line1;
    asymptote2      = R*line2;
    
    % draw
    plot( new_ver_line(1,:),new_ver_line(2,:),'r' );
    hold on;
    plot( new_horz_line(1,:),new_horz_line(2,:),'r' );
    plot( asymptote1(1,:),asymptote1(2,:),'r' );
    plot( asymptote2(1,:),asymptote2(2,:),'r' );
    plot( points(1,:),points(2,:),'r' );
    plot( points(3,:),points(4,:),'r' );
    hold off;
end    