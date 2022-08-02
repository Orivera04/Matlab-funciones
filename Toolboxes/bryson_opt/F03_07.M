% Script f03_07.m; max range paths with V=1+y & yf specified 
% (Fermat Pb.); dual pb. is min time to (xf,yf); optimal paths
% (rays) & contours of constant final time (wavefronts); 
%                                                 2/94, 4/2/02
%
% Optimal paths (rays):
c=pi/180; tho=c*[-80:10:80]; th=c*[-89:89]; N=length(th); 
x1=zeros(17,N); y1=x1; un=ones(1,N);
for j=1:17;
 x1(j,:)=(un*sin(tho(j))-sin(th))/cos(tho(j));
 y1(j,:)=(-un*cos(tho(j))+cos(th))/cos(tho(j)); 
end 
%
% Contours of constant tf (wavefronts)
t=.25:.25:2; tho=c*[-89:89]; x=zeros(17,N); y=x;  
for j=1:8,  
 d=exp(-t(j))*(un+sin(tho))./cos(tho);
 th=asin((d.^2-un)./(d.^2+un));
 x(j,:)=(sin(tho)-sin(th))./cos(tho); 
 y(j,:)=(-cos(tho)+cos(th))./cos(tho);
end 
%
figure(1); clf; for j=1:17, plot(x1(j,:),y1(j,:),'b',...
     -x1(j,:),y1(j,:),'b'); hold on
end; grid; axis([-2.6 2.6 -1 3]);  
for j=1:8; plot(x(j,:),y(j,:),'r--',-x(j,:),y(j,:),'r--');
end; plot([0 0],[-1 3]); hold off; xlabel('x/h');
ylabel('y/h'); text(2,2.3,'tf=1.50'); text(1.3,2.0,'1.25');
text(.75,1.6,'1.00')
%print -deps2 \book_do\figures\f03_07
