function Small_Amplitude_Torsional_Finder
close all

% Damping is the damping constant
% Lambda is the amplitude of the forcing term
% Mu is the frequency of the forcing term

Damping=0.01;
Lambda=0.05;
Mu=1.4;
%%% Set Initial Conditions %%%
c=-0.5;
d=-0.5;
 



h=.001;
init=[c;d];
Error=1;
NewtErr=1;
T=2*pi/Mu;
Evect=[]
n=1;
epsilon=.1;

while Error >= 1e-6
    tspan=[0,T];
    init=[c;d];
   
    if n<6
        Evect(n)=1000;
        n=n+1;
    else
        
%         Compute Error
      
        opts=odeset('RelTol',1e-5);
        [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1p=y_1(1);
        y_2p=y_2(1);
        Error=(init(1)-y_1p)^2+(init(2)-y_2p)^2
        Evect(n)=Error;
        if Evect(n-5)<=Evect(n)
            epsilon=epsilon*.8;
        end

       

%         Compute Central Differences
        tspan=[0,T];
        opts=odeset('RelTol',1e-4);
        init=[c+h,d];
            [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cphd=y_1(1);
            y_2cphd=y_2(1);
        init=[c-h,d];
            [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cmhd=y_1(1);
            y_2cmhd=y_2(1);
        init=[c,d+h];
            [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cdph=y_1(1);
            y_2cdph=y_2(1);
        init=[c,d-h];
            [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
            y_1=y(size(y),1);
            y_2=y(size(y),2);
            y_1cdmh=y_1(1);
            y_2cdmh=y_2(1);   
        PartY_PartC=(y_1cphd-y_1cmhd)/(2*h);
        PartY_PartD=(y_1cdph-y_1cdmh)/(2*h);
        PartYP_PartC=(y_2cphd-y_2cmhd)/(2*h);
        PartYP_PartD=(y_2cdph-y_2cdmh)/(2*h);

%         Compute Gradient
        Grad=[2*(c-y_1p)*(1-PartY_PartC)+2*(d-y_2p)*(-PartYP_PartC),...
            2*(c-y_1p)*(-PartY_PartD)+2*(d-y_2p)*(1-PartYP_PartD)];

%         Compute Norm of Gradient
        Grad_Norm=(sqrt(Grad(1)^2+Grad(2)^2));

%         Iterate
        init=[c,d]-(epsilon.*(Grad./Grad_Norm));
        c=init(1);
        d=init(2); 
        n=n+1;
        
    end
end

while NewtErr >= 1e-14
    tspan=[0,T];
    epsilon=.001;
    init=[c;d];
    
    %Compute F
    opts=odeset('RelTol',1e-13);
    [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
    y_1=y(size(y),1);
    y_2=y(size(y),2);
    G=[y_1(1);y_2(1)];
    F=init-G;
    
    %Compute Central Differences
    opts=odeset('RelTol',1e-13);
    init=[c+h,d];
        [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cphd=y_1(1);
        y_2cphd=y_2(1);
    init=[c-h,d];
        [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cmhd=y_1(1);
        y_2cmhd=y_2(1);
    init=[c,d+h];
        [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cdph=y_1(1);
        y_2cdph=y_2(1);
    init=[c,d-h];
        [t,y]=ode15s(@torsional,tspan,init,opts,Damping,Lambda,Mu);
        y_1=y(size(y),1);
        y_2=y(size(y),2);
        y_1cdmh=y_1(1);
        y_2cdmh=y_2(1);   
    PartY_PartC=(y_1cphd-y_1cmhd)/(2*h);
    PartY_PartD=(y_1cdph-y_1cdmh)/(2*h);
    PartYP_PartC=(y_2cphd-y_2cmhd)/(2*h);
    PartYP_PartD=(y_2cdph-y_2cdmh)/(2*h);
   
   
    %Compute new initial conditions
    z=inv([1-PartY_PartC,-PartY_PartD;-PartYP_PartC,1-PartYP_PartD]); 
    init=[c;d]-(z*F);
    %Compute Absolute Change
     NewtErr=abs((c-init(1))+(d-init(2)))
     c=init(1);
     d=init(2); 
end


init=[c,d]
[t,y]=ode45(@torsional,tspan,init,opts,Damping,Lambda,Mu);
plot(t,y(:,1))
xlabel('One Period (T)')
ylabel('Torsional Rotation (Rad)')
axis([0,T,-2,2])
   
function yprime=torsional(t,y,Damping,Lambda,Mu)
yprime=zeros(2,1);
yprime(1)=y(2);
yprime(2)=-Damping*y(2)-2.4*sin(y(1))+Lambda*sin(Mu*t); 
