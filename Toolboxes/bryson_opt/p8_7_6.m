% Script p8_7_6 - min time paths w. velocity proportional to radius;
%                                                            7/25/02
%
be1=(pi/2)*[.6:.1:2]; N=50; t1=2*pi*[0:1/N:1];
figure(1); clf;
for i=1:length(be1), t=t1; be=be1(i); th=t*sin(be); r=exp(t*cos(be));
   x=r.*cos(th); y=r.*sin(th); plot(x,y); hold on;
end
be=(pi/2)*[.6:.02:2];
for i=4:3:49, t=t1(i); th=t*sin(be); r=exp(t*cos(be));
   x=r.*cos(th); y=r.*sin(th); plot(x,y,'r--'); hold on
end
plot(0,0,'ro',1,0,'ro'); grid; axis([-1.2 1.2 0 1.8]); hold off
xlabel('x/x_f'); ylabel('y/x_f'); text(.82,.46,'6\pi/50')
text(.7,.84,'12\pi/50'); text(.4,1.24,'18\pi/50')
text(-.3,1.44,'\omega T=24\pi/50'); text(-.9,1.38,'30\pi/50')
text(-1.1,.68,'36\pi/50'); text(-1.1,.24,'42\pi/50')