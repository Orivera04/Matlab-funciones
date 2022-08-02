function Large_Amplitude_Verticle_Finder_Pos
% Define a function m-file 
%       Allows the use of subfunctions within the m-file

% Begin initializing the variables for the function "vertical"
%       Damping is the damping constant
%       Lambda is the amplitude of the forcing term
%       Mu is the frequency of the forcing term
%       A is (k_1 + k_2) the combined spring constants
%       B is the spring constant of the cable k_2 
Damping=0.01;
Lambda=0.1;
Mu=4;
A=17;
B=1;
% Set Initial Conditions 
%       Some initial conditions will not converge
c=3; 
d=4;
%Begin initializing the variables for the while loop
%       init are the initial conditions c and d
%       T is one period of time
%       h is the step size for computing the central differences
%       epsilon is the step size for the gradient vector
%       Evect is an empty vector
%       n will be used as a counter
%       Error is the output of the error function
init=[c;d];
T=2*pi/Mu;
h=.001;
epsilon=.1;
Evect=[]
n=1;
Error=1;
% Finds the initial conditions with the gradient method
while Error >= 1e-7
    
     
   
    if n<6
        Evect(n)=1000;
        n=n+1;
    else
% Compute Error
%    Set variables for the initial value solver
%       tspan is the time span
%       opts sets the options for the initial value solver
        tspan=[0,T];
        opts=odeset('RelTol',1e-3);
        [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1p=y_1(1);
        y_2p=y_2(1);
        Error=(init(1)-y_1p)^2+(init(2)-y_2p)^2
        Evect(n)=Error;
        if Evect(n-5)<=Evect(n)
            epsilon=epsilon*.8;
        end   
% Compute Central Differences
        tspan=[0,T];
        opts=odeset('RelTol',1e-4);
        init=[c+h,d];
            [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cphd=y_1(1);
            y_2cphd=y_2(1);
        init=[c-h,d];
            [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cmhd=y_1(1);
            y_2cmhd=y_2(1);
        init=[c,d+h];
            [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cdph=y_1(1);
            y_2cdph=y_2(1);
        init=[c,d-h];
            [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cdmh=y_1(1);
            y_2cdmh=y_2(1); 
% PartY_PartC is the partial of y with respect to c
% PartY_PartD is the partial of y with respect to d
% PartYP_PartC is the partial of y' with respect to c
% PartYP_PartD is the partial of y' with respect to d
        PartY_PartC=(y_1cphd-y_1cmhd)/(2*h);
        PartY_PartD=(y_1cdph-y_1cdmh)/(2*h);
        PartYP_PartC=(y_2cphd-y_2cmhd)/(2*h);
        PartYP_PartD=(y_2cdph-y_2cdmh)/(2*h);

% Compute Gradient
        Grad=[2*(c-y_1p)*(1-PartY_PartC)+2*(d-y_2p)*(-PartYP_PartC),...
            2*(c-y_1p)*(-PartY_PartD)+2*(d-y_2p)*(1-PartYP_PartD)];
% Compute Norm of Gradient
        Grad_Norm=(sqrt(Grad(1)^2+Grad(2)^2));
%Iterate
        init=[c,d]-(epsilon.*(Grad./Grad_Norm));
        c=init(1);
        d=init(2); 
        n=n+1;
        init=[c;d];
   end
end
init=[c,d]
% Find the initial conditions with Newton's method
% NewtErr is the error calculated during this while loop
NewtErr=1;
while NewtErr >= 1e-12
    tspan=[0,T];
    epsilon=.01;
    init=[c;d];
%Compute F
    opts=odeset('RelTol',1e-13);
    [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
    y_1=y(size(y),1);
    y_2=y(size(y),2);
    G=[y_1(1);y_2(1)];
    F=init-G; 
%Compute Central Differences
    tspan=[0,pi/2];
    opts=odeset('RelTol',1e-13);
    init=[c+h,d];
        [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cphd=y_1(1);
        y_2cphd=y_2(1);
    init=[c-h,d];
        [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cmhd=y_1(1);
        y_2cmhd=y_2(1);
    init=[c,d+h];
        [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cdph=y_1(1);
        y_2cdph=y_2(1);
    init=[c,d-h];
        [t,y]=ode15s(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cdmh=y_1(1);
        y_2cdmh=y_2(1);   
    PartY_PartC=(y_1cphd-y_1cmhd)/(2*h);
    PartY_PartD=(y_1cdph-y_1cdmh)/(2*h);
    PartYP_PartC=(y_2cphd-y_2cmhd)/(2*h);
    PartYP_PartD=(y_2cdph-y_2cdmh)/(2*h);
% Compute new initial conditions with Newtons Method
    z=inv([1-PartY_PartC,-PartY_PartD;-PartYP_PartC,1-PartYP_PartD]); 
    init=[c;d]-(z*F);
% Compute Absolute Change
     NewtErr=abs((c-init(1))+(d-init(2)))
     c=init(1);
     d=init(2); 
end
% Display the initial conditions
init=[c,d]
% Plot the function "vertical" over one time period
[t,y]=ode45(@vertical,tspan,init,opts,Damping,Lambda,Mu,A,B);
plot(t,y(:,1))
xlabel('One Period (T)')
ylabel('Vertical Displacement')
axis([0,T,-0.4,1.4])

% The function "vertical" is equivalent to the second order differential
%       equation y''+delta*y'+a*y^{+}-b*y^{-}=10+lamba*sin(mu*t)
function yprime=vertical(t,y,Damping,Lambda,Mu,A,B)
yprime=zeros(2,1);
yprime(1)=y(2);
yprime(2)=-Damping*y(2)-A*y(1)*(y(1)>0)+B*y(1)*(y(1)<0)+10+Lambda*sin(Mu*t); 
