% APE_rk: used in GuiDm_17
% Copyright S. Nakamura, 1995
function APE_rk(La, Lb, Ra, Rb ,C) 
cla
   e=1;
   M=[ -Ra/La,  Ra/La,      -1/(La*C) ; ...
        Ra/Lb, -(Ra+Rb)/Lb,  1/(Lb*C) ;   ...
               1/C,    -1/C,           0        ];
   S=[0;0;0]; x=[0; 0; 0];
   h=0.00005;
   for n=1:101
     t=(n-1)*h;
     %S=[ sin(t*600)*exp(-t*600)/La; 0; 0];
     %S=[ cos(t*600)/La; 0; 0];
     S=[ 1/La; 0; 0];
     if t>0.001, S=[0;0;0];end
     k1=h*(M*x+S);
     k2=h*(M*(x+k1)+S);
     x=x+(k1+k2)/2;
     x_r(:,n)=x;
     t_r(n)=t;
  end
  plot(t_r, x_r(1:2,:), t_r, x_r(3,:))
  xlabel('t'),ylabel('i1,i2,q')
  L= length(t_r);
  text(t_r(L/10),x_r(1,L/10),'i1')
  text(t_r(L/2),x_r(2,L/2),'i2')
  text(t_r(L*0.8),x_r(3,L*0.8),'q')
return
