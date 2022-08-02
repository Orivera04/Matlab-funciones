% F10_18 same as L10_11
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.8; List 10.11')
clear;clg
subplot(221)
for k=1:4
  e=1;
  if k==1; subplot(221);
     La=0.01; Lb=0.5;   Ra=200; Rb=20;C=0.002; end
  if k==2, subplot(222);
     La=0.1;  Lb= 0.5;  Ra=200 ; Rb=20; C=0.002; end
  if k==3; subplot(223);
     La=0.01; Lb= 0.25; Ra=200 ; Rb=20  ;C=0.002; end
  if k==4; subplot(224);
     La=  0.01; Lb= 0.5; Ra=20 ; Rb=20  ;C=0.002; end
     M=[ -Ra/La,  Ra/La,      -1/(La*C) ; ...
        Ra/Lb, -(Ra+Rb)/Lb,  1/(Lb*C) ;   ...
	       1/C,    -1/C,           0        ] ; 
   S=[0;0;0]; x=[0; 0; 0];
   h=0.00005;
   for n=1:101
     t=(n-1)*h; 
     %S=[ sin(t*600)*exp(-t*600)/La; 0; 0];
     %S=[ cos(t*600)/La; 0; 0];
     S=[ 1/La; 0; 0];
     if t>0.001, S=[0;0;0];end
     k1=h*(M*x+S);
     k2=h*(M*(x+k1/2)+S);
     k3=h*(M*(x+k2/2)+S);
     k4=h*(M*(x+k3)+S);
     x=x+(k1+k2*2+k3*2+k4)/6;
     x_r(:,n)=x;
     t_r(n)=t;
  end
  plot(t_r, x_r(1:2,:), t_r, x_r(3,:))
  xlabel('t'),ylabel('i1,i2,q')
  L= length(t_r); 
  text(t_r(L/10),x_r(1,L/10),'i1')
  text(t_r(L/2),x_r(2,L/2),'i2')
  text(t_r(L*0.8),x_r(3,L*0.8),'q')
  if k==1;title('(A)');end
  if k==2;title('(B)');end
  if k==3;title('(C)');end
  if k==4;title('(D)');end
end
 
