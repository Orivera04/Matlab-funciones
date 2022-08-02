function B = RotVecArAxe(A,L,Phi)
% Function B = RotVecArAxe(L,Phi,A) rotate 
% the vector A(3,1) around the axe L(3,1) 
% into angle Phi radian counterclockwise.
% Author: Sergiy Iglin
% e-mail: iglin@kpi.kharkov.ua
% or: siglin@yandex.ru
% personal page: http://iglin.exponenta.ru

%========== Checking of datas ==================
strerr='Is needed 3 input parameters: vector A(3,1), axe L(3,1) and angle Phi!';
if nargin<3,
  error(strerr);
end
if ~isnumeric(A)
  error(strerr);
else
  A=A(:);
  if length(A)<3,
    error(strerr);
  end
  A=A(1:3);
end
if ~isnumeric(L)
  error(strerr);
else
  L=L(:);
  if length(L)<3,
    error(strerr);
  end
  L=L(1:3);
  L0=L/norm(L); % orth
end
if ~isnumeric(Phi)
  error(strerr);
else
  Phi=Phi(1);
end

%============= Solution ================
cphi=cos(Phi);
B=A*cphi+(A'*L0)*(1-cphi)*L0+cross(L0,A)*sin(Phi);
return