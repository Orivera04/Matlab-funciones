function [frq,time,x,y]=runmode(a,b,npnts,ntrms,nbdry,type)
% [frq,time,x,y]=runmode(a,b,npnts,ntrms,nbdry,type)
if nargin==0
  a=1; b=.999; npnts=[50,50]; ntrms=[10,10];
  nbdry=50; type=1;
end
tic;

h=sqrt(a^2-b^2); rho=atanh(b/a);
th=linspace(0,pi/2,npnts(1));
r=linspace(0,rho,npnts(2));
[Tn,Rn]=meshgrid(th,r); z=h*cosh(Rn+i*Tn);
x=real(z); y=imag(z);

thb=linspace(0,pi/2,nbdry);
xb=a*cos(thb); yb=b*sin(thb);

fb1=rectmodes(a,b,xb,yb,ntrms,1); q1=null(fb1); disp(['size q1 ',num2str(size(q1))])
[f,f2]=rectmodes(a,b,x,y,ntrms,1);
A=-pinv(f*q1)*(f2*q1); fr1=eig(A);
k=find(real(fr1)>0 & imag(fr1)==0);
fr1=sqrt(sort(fr1(k)));

fb2=rectmodes(a,b,xb,yb,ntrms,2); q2=null(fb2); disp(['size q2 ',num2str(size(q2))])
[f,f2]=rectmodes(a,b,x,y,ntrms,2);
A=-pinv(f*q2)*(f2*q2); fr2=eig(A);
k=find(real(fr2)>0 & imag(fr2)==0);
fr2=sqrt(sort(fr2(k))); 
frq=sort([fr1;fr2]); time=toc;
[fr1(1:20),fr2(1:20)]

%=========================================

function [f,f2]=rectmodes(a,b,x,y,ntrms,type)
% [f,f2]=rectmodes(a,b,x,y,ntrms,type)
if nargin==0
  a=2; b=1; th=linspace(0,pi/2,41);
  r=linspace(0,1,31)';
  z=a*r*cos(th)+i*b*r*sin(th); 
  x=real(z); y=imag(z); ntrms=[20,30];
  plot(x,y,x',y'), axis equal, shg, pause
  type=1;
end
nsx=ntrms(1); nsy=ntrms(2);
s=size(x); x=x(:); y=y(:); nxy=length(x);
Isx=repmat((1:nsx)',1,nsy); Isx=Isx(:)';
Jsy=repmat(1:nsy,nsx,1); Jsy=Jsy(:)';
ca=pi/2/a; cb=pi/2/b;
xisx=ca*x*Isx; yjsy=cb*y*Jsy;
switch type
  case 1, f=cos(xisx).*cos(yjsy);
  case 2, f=sin(xisx).*cos(yjsy);
  case 3, f=cos(xisx).*sin(yjsy);
  case 4, f=sin(xisx).*sin(yjsy);
end
if nargout==1, f2=[]; return, end
kij=-(ca*Isx).^2-(cb*Jsy).^2;
f2=repmat(kij,nxy,1).*f;