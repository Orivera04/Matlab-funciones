% Initialisation file for the Simulink model aeroblk_HL-20

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.2.3 $  $Date: 2004/04/06 01:04:26 $

disp('Loading data for model aeroblk_HL-20 ...')

%==================================================================
% Useful Constants
%==================================================================

d2r     = pi/180;                 % Conversion Deg to Rad
g       = 9.81;                   % Gravity [m/s/s]
m2ft    = 3.28084;                % metre to feet
Kg2slug = 0.0685218;              % Kg to slug
Kg2lb   = 2.20462;

%==================================================================
% Atmospheric Constants
%==================================================================

T0      = 288.16;                 % Temp. at Sea Level [K]
rho0    = 1.225;                  % Density [Kg/m^3]
L       = 0.0065;                 % Lapse Rate [K/m]
R       = 287.26;                 % Gas Constant J/Kg/K
gam     = 1.403;                  % Ratio of Specific Heats
P0      = 101325.0;               % Pressure at Sea Level [N/m^2]
h_trop  = 11000.0;                % Height of Troposphere [m]

%==================================================================
% Aircraft Configuration Configuration
%==================================================================
S_ref   = 286.45/m2ft^2;            % Reference area [m^2]
d_ref   = 28.24/m2ft;               % Reference length [m]
b_ref   = 13.89/m2ft;               % Reference Span [m]
massBody  = 22932/Kg2lb;            % Mass of Body [Kg]
massFuel  = 2948/Kg2lb;             % Mass of Fuel [Kg] 
mass = massBody+massFuel;
len_veh = 27.31/m2ft;               % Vehicle Length
x_ref   = 0.54*len_veh;             % Reference point from nose
x_cg    = 0.575*len_veh;            % Centre of Gravity (Full)
Ixx     = 1/8*mass*(S_ref/pi);
Iyy     = 1/3*mass*(d_ref/2)^2;
Izz     = Iyy;
Inertia = diag([Ixx Iyy Izz]);

%==================================================================
% Initial Conditions
%==================================================================
load aeroblk_HL20_glideslope;
alpha_0 = alpha0;
Vmw = V*[cos(alpha_0);0;sin(alpha_0)];                    % Velocity in Body Axes
pm_0 = [0;0;0];                         % Initial angular rates (rad/sec)
xme_0 = [-Aimpoint;0;-10000/m2ft];                    % Initial Position
Aimpoint=0;
Euler_0 = [0;-gamma1+alpha_0;0];

%==================================================================
% Actuators
%==================================================================
wn_act = 44.0;                          % Actuator Bandwidth [rad/sec]
z_act = 1/sqrt(2);                      % Actuator Damping

dwf_max  = 30;                          % Limits on Wing Flap Deflection [deg]
dbf_max  = 60;                          % Limits on Body Flap Deflections [deg]
dr_max   = 60;                          % Limits on Rudder Deflections [deg]
max_lim = [dwf_max dwf_max dbf_max dbf_max 0 0 dr_max];
min_lim = [-dwf_max -dwf_max 0 0 -dbf_max -dbf_max -dr_max];
    
% [dwfl dwfr dbfll dbflr dbful dbfur dr] to [da de dr df+ df- ddf];
Act2Aero = 0.5*[1 -1 0 0 0 0 0;1 1 0 0 0 0 0 ;0 0 0 0 0 0 2;0 0 1 1 0 0 0; 0 0 0 0 1 1 0;0 0 1 -1 1 -1 0;];
Aero2Act = pinv(Act2Aero);

%
% Autopilot
%
load aeroblk_HL20_autopilot_gains

%==================================================================
% Aircraft Aerodynamic Coefficients
%==================================================================

% Basic configuration
alpha_vec_0= -10:1:30;
beta_vec_0= -10:1:10;
PolyCoeff = [-9.025e-2  2.632e-2  7.362e-2
              4.070e-2 -2.226e-3 -2.560e-4
              3.094e-5 -1.859e-5 -2.208e-4
              1.564e-5  6.001e-7 -2.262e-6
             -1.386e-6  1.828e-7  2.966e-7
              2.545e-8 -9.733e-9 -3.640e-9
             -1.189e-10 1.710e-10 9.388e-12
              2.564e-3 -5.233e-4 -5.299e-4
              8.501e-4  6.795e-5 -4.709e-4
             -1.156e-4 -1.993e-5  8.572e-5
              3.416e-6  1.341e-6 -4.199e-6
             -4.8562e-4 6.061e-5  1.295e-4];

 [al,be]=meshgrid(alpha_vec_0,beta_vec_0);
 al=al(:);be=be(:);
 temp = [ones(length(al),1) al al.^2 al.^3 al.^4 al.^5 al.^6 abs(be) be.^2 abs(be.^3) be.^4 al.*abs(be)]*PolyCoeff;
 CZ0 = -reshape(temp(:,1),length(beta_vec_0),length(alpha_vec_0));
 Cm0 = reshape(temp(:,2),length(beta_vec_0),length(alpha_vec_0));
 CX0 = -reshape(temp(:,3),length(beta_vec_0),length(alpha_vec_0));

 alpha_vec_Cn0 = [-10 -5 0 5 10 15 20 25 30];
 beta_vec_Cn0 = [0 2 5 10];
 Cn0 = [0 0.46 1.15 2.30
        0 0.56 1.40 2.80
        0 1.00 2.00 4.00
        0 0.50 1.40 3.00
        0 0.80 1.80 3.00
        0 0.60 1.50 3.00
        0 0.70 1.00 1.20
        0 0.17 0.53 0.99
        0 -0.29 -0.24 0.02]*1e-2;
      
 %Side Force and roll stability derivatives
 CYbeta = -0.01242;                  % per deg
 Clbeta = -0.00787;                     
 
 % Symmetric wing flaps (elevator)
 PolyCoeff = [5.140e-3 -1.903e-3 -1.854e-4
              3.683e-5 -1.593e-5  2.830e-6
             -6.092e-6  2.611e-6 -6.966e-7
              2.818e-9  5.116e-8  1.323e-7
             -2.459e-9 -1.626e-9 -2.758e-9];
 temp = [ones(length(alpha_vec_0),1) alpha_vec_0' alpha_vec_0'.^2 alpha_vec_0'.^3 alpha_vec_0'.^4]*PolyCoeff;
 CZde = -temp(:,1);
 Cmde = temp(:,2);
 CXde = -temp(:,3);

% Differential Wing Flaps (ailerons)
PolyCoeff = [-2.503e-4  1.471e-4  9.776e-4  3.357e-3 -2.769e-3  2.538e-3 
              4.987e-5  4.673e-5 -2.703e-5 -1.661e-5 -4.377e-5  1.963e-5
             -2.274e-6 -8.282e-6 -8.303e-6 -3.280e-6  9.952e-6 -3.725e-6
             -1.407e-7  4.891e-7  6.645e-7  5.526e-8 -3.642e-7  3.539e-8
              5.135e-9 -8.742e-9 -1.273e-8 -3.269e-10 4.692e-9 -1.778e-10];
temp = [ones(length(alpha_vec_0),1) alpha_vec_0' alpha_vec_0'.^2 alpha_vec_0'.^3 alpha_vec_0'.^4]*PolyCoeff;
CZda = -temp(:,1);
Cmda = temp(:,2);
CXda = -temp(:,3);
CYda = temp(:,4);
Cnda = temp(:,5);
Clda = temp(:,6);

% Positive Body Flaps
PolyCoeff = [3.779e-3 -9.896e-4 1.310e-4
             -7.017e-7 -1.494e-9 1.565e-6
             1.400e-10 6.303e-11 -1.542e-9];
temp = [ones(length(alpha_vec_0),1) alpha_vec_0' alpha_vec_0'.^2]*PolyCoeff;
CZdfp = -temp(:,1);
Cmdfp = temp(:,2);
CXdfp = -temp(:,3);

% Negative Body Flaps
PolyCoeff = [3.711e-3 -1.086e-3 -4.415e-4
            -3.547e-5  1.570e-5 -4.056e-6
            -2.706e-6 -4.174e-7 -4.657e-7
             2.938e-7 -1.133e-7  0
            -5.552e-9  2.723e-9  0];
temp = [ones(length(alpha_vec_0),1) alpha_vec_0' alpha_vec_0'.^2 alpha_vec_0'.^3 alpha_vec_0'.^4]*PolyCoeff;
CZdfn = -temp(:,1);
Cmdfn = temp(:,2);
CXdfn = -temp(:,3);

% Differential Body Flaps
PolyCoeff = [-6.043e-4  2.672e-5 -5.107e-5   7.453e-4
             -1.858e-5 -3.849e-5  1.108e-5  -1.811e-5
              8.000e-7  4.564e-7 -1.547e-8  -1.264e-7
             -4.845e-8  1.798e-8 -1.552e-8   9.972e-8
              1.360e-9 -4.099e-10 1.413e-10 -2.684e-9];
temp = [ones(length(alpha_vec_0),1) alpha_vec_0' alpha_vec_0'.^2 alpha_vec_0'.^3 alpha_vec_0'.^4]*PolyCoeff;
CXddf = -temp(:,1);
CYddf = temp(:,2);
Cnddf = temp(:,3);
Clddf = temp(:,4);
 
% All-movable rudder
PolyCoeff = [5.173e-4 -5.116e-5   5.812e-4  1.855e-3  -1.278e-3  2.260e-4
             7.359e-5 -1.516e-5   1.410e-5  1.128e-5   1.320e-5 -1.299e-5
            -8.270e-7  1.729e-6  -2.585e-6  6.069e-6  -4.720e-6  5.565e-6
            -6.034e-7 -2.481e-8   3.051e-7 -1.780e-7   2.371e-7 -3.382e-7
             2.016e-8 -7.867e-10 -8.161e-9 -1.886e-12 -3.340e-9  6.461e-9];
temp = [ones(length(alpha_vec_0),1) alpha_vec_0' alpha_vec_0'.^2 alpha_vec_0'.^3 alpha_vec_0'.^4]*PolyCoeff;
CZdr = -temp(:,1);
Cmdr = temp(:,2);
CXdr = -temp(:,3);
CYdr = temp(:,4);
Cndr = temp(:,5);
Cldr = temp(:,6);

% Damping Coefficients (per rad/sec)
alpha_vec_damping = [0 5 10 12 14 16 18 20 22 25 30];
Cmq = [-2.03 -1.58 -1.16 -1.76 -1.76 -1.75 -1.74 -2.52 -2.99 -5.71 -8]*1e-1;
Cnp = [3.81 3.53 2.19 2.44 1.79 1.67 2.01 2.22 3.07 3.79 8.50]*1e-1;
Clp = [-4.98 -6.0 -3.98 -5.79 -4.25 -4.99 -6.49 -6.19 -8.10 -8.72 -24.10]*1e-1;
Cnr = [-7.94 -8.37 -9.21 -9.22 -8.67 -9.22 -9.46 -10.07 -10.90 -12.86 -20.41]*1e-1;
Clr = [4.96 5.98 8.40 8.06 6.86 5.72 6.03 8.99 9.57 13.57 44.90]*1e-1;
