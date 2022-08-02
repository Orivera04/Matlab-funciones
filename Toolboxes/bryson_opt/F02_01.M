% Script f02_01.m; nomenclature sketch for VDP for max range with 
% gravity (brachistochrone);                         10/96, 3/23/02
%
N=50; d=2*N*sin(pi/(4*N)); n=cos(pi/(4*N))/(2*N*d); 
for i=1:N+1,   
  x(i)=n*(i-1-sin(pi*(i-1)/N)/(2*sin(pi/(2*N))));
  y(i)=(n/(2*sin(pi/(2*N))))*(1-cos(pi*(i-1)/N)); end
th=[0:.1:1]*33*pi/180; un=ones(1,11);
m=32; xc=x(m)*un+.08*cos(th); yc=y(m)+.08*sin(th);
%
figure(1); clf; plot(x,-y,[0 0],[0 -.22],'b',[0 .35],[0 0],'b',...
    [x(m) x(m)+.1],[-y(m) -y(m)],'b',x(m),-y(m),'bo',...
    [x(m) x(m)+.1],[-y(m) -y(m)-.065],'b',x(51),-y(51),'bo',...
    xc,-yc,'b.'); axis([0 .4 -.25 0]); text(.21,-.21,'V');
text(.19,-.16,'\gamma'); text(.34,-.02,'x'); text(.02,-.22,'y');
text(.08,-.15,'(x,y)'); text(x(51)-.015,-y(51)-.02,'t = t_f');  
axis off
%print -deps2 \book_do\figures\f02_01
	
