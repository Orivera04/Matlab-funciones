function xdot=cl2ordpf(t,x,flag,a_d2y,b_dy,c_y,tstart_t,tend_t)
%  CALL: xdot=cl2ordpf(t,x,flag,a_d2y,b_dy,c_y,tstart_t,tend_t) to define the second order differential
%   equation a_d2y*y''+b_dy*y'+c_y*y = f(t) with t,x scalar inputs from ode23, 
%    f(t) is a unit pulse defined from tstart_t to tend_t. flag is a dummy variable.
%
% Compute pulse_t; a scalar value of pulse at time t    
%       If t < tstart_t        pulse_t = 0
%  If tstart_t <= t <= tend_t  pulse_t = 1
%       If t > tend_t          pulse_t = 0
% OUTPUT: xdot is the column vector solution [y Dy] returned to ode23 for each t
if t < tstart_t
    pulse_t = 0.0;                   
 elseif  (tstart_t <= t) & (t <= tend_t)
    pulse_t = 1.0 ;                  
 elseif t > tend_t   
    pulse_t =0.0 ;                   
end    
%
% The equation ay''+by'+cy = f(t) as xdot(t)=Ax(t) using x1 = y x2= y'
xdot(1) = 0*x(1) + x(2);         
xdot(2) = - (c_y)*x(1)/(a_d2y) -(b_dy)*x(2)/(a_d2y)  ...
   +(pulse_t)/(a_d2y);
xdot=xdot';   % Return a column vector
%
% Version 5  Modified call and changed xdot to column vector and 



