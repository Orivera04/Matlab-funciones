function [L0,Phi] = GetRotAxeAngle(T)
% Function [L0,Phi] = GetRotAxeAngle(T) 
% for orthogonal matrix T(3,3) with det(T)=+1
% return the orth of rotation L0(3,1) and 
% the angle of rotation Phi in [0,pi].
% Author: Sergiy Iglin
% e-mail: iglin@kpi.kharkov.ua
% or: siglin@yandex.ru
% personal page: http://iglin.exponenta.ru

%========== Checking of datas ==================
strerr='Is needed 1 input parameter: the orthogonal matrix T(3,3) with det(T)=+1!';
tol=1e5*eps; % tolerance
if nargin<1,
  error(strerr);
end
if ~isnumeric(T),
  error(strerr);
end
d=size(T);
if ~(length(d)==2),
  error(strerr);
end
if ~all(d==3),
  error(strerr);
end
if max(max(abs(T'*T-eye(3))))>tol,
  error(strerr);
end
if abs(det(T)-1)>tol,
  error(strerr);
end

%============= Solution ================
T1=T-eye(3);
Lm=[cross(T1(:,1),T1(:,2)),cross(T1(:,2),T1(:,3)),...
    cross(T1(:,3),T1(:,1))];
mLm=max(abs(Lm));
[nmLm,inmLm]=max(mLm);
L=Lm(:,inmLm);
normL=norm(L);
if normL<eps, % without rotation
  Phi=0;
  L0=zeros(3,1);
else
  L0=L/normL; % orth
  if norm(L0-[1;0;0])<tol, % L0==i
    a=[0;1;0];
    b=T(:,2);
  else
    a=[1;0;0];
    b=T(:,1);
  end
  a1=a-(a'*L0)*L0;
  b1=cross(L0,a);
  c1=b-(a'*L0)*L0;
  r1=(a1.^2+b1.^2).^0.5;
  [r0,ir0]=max(r1);
  beta=atan2(b1(ir0),a1(ir0));
  ac=acos(c1(ir0)/r0);
  Phi=ac+beta;
  if norm(RotVecArAxe(a,L0,Phi)-b)>tol,
    Phi=-ac+beta;
  end
  if Phi>pi,
    L0=-L0;
    Phi=2*pi-Phi;
  end
end
return