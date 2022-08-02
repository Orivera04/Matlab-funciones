% L_c1 same as movie_1 
% Copyright S. Nakamura, 1995
close
clear, clf
h=figure(1);
set(h,'Position',[200,200,350,350],...
'NumberTitle','off',...
'Name','movie_1: Being recorded')
M=moviein(10,gcf);  
dth=pi/10; th=0:dth:pi; fi=0:dth:2*pi;
nk=length(th); nj = length(fi);
for j=1:nj 
  for k=1:nk
    x(k,j) = sin(th(k)) *cos(fi(j));
    y(k,j) = sin(th(k))* sin(fi(j));
    z(k,j) =cos(th(k));
  end
end
[xd,yd,zd] = rotx_(x,y,z, 30);
axis([-1.5 1.5 -1.5 1.5 -1 1])
c=zd;
for k=1:11
  kk=36*k;
  [xd,yd,zd] = rotx_(x,y,z, kk);
  surf(xd,yd,zd,c)
  M(:,k) = getframe(gcf);
end
n=10; fps=10; save m_ball M n fps 
gcf,cla,clf
set(gcf,'Name', 'movie_1: Being played back')

load m_ball
movie(gcf,M,n,fps)

