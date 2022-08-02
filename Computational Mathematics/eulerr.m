% This code compares the discretization errors.
% The Euler and improved Euler methods are used.
clear;
maxk = 5;     % number of time steps
T  = 50.0;      % final time
dt = T/maxk;
time(1) = 0;
u0 = 200.;  % initial temperature     
c  = 2./13.; % insulation factor
usur  = 70.; % surrounding temperature
uexact(1) = u0;
ueul(1)  = u0;
uieul(1)  = u0;
for k = 1:maxk
    time(k+1) = k*dt;
    % exact solution
    uexact(k+1) = usur + (u0 - usur)*exp(-c*k*dt);  
    % Euler numerical approximation
    ueul(k+1) = ueul(k) +dt*c*(usur - ueul(k)); 
    % improved Euler numerical approximation
    utemp = uieul(k) +dt*c*(usur - uieul(k));
	uieul(k+1)= uieul(k) +dt/2*(c*(usur - uieul(k))+c*(usur - utemp));
	err_eul(k+1) = abs(ueul(k+1) - uexact(k+1));
	err_im_eul(k+1) = abs(uieul(k+1) - uexact(k+1));
end
plot(time, ueul)
maxk
err_eul_at_T = err_eul(maxk+1)
err_im_eul_at_T = err_im_eul(maxk+1)
