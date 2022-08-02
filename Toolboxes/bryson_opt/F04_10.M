% Script f04_10.m (also edotplot.m); plot Edot(V,h) for F4H at
% final weight for Denham min time climb to 20 km; 4/94, 4/2/02
%
V1=[0:.1:2.4]; N1=length(V1); 
for i=1:13, for j=1:N1, h1(i,j)=i*10-V1(j)^2/(.0322*2); 
end; end
%
figure(1); clf; for i=1:13, plot(V1,h1(i,:),'--'); hold on 
end; clear V V1; load edotplot; contour(V,h,Edot,V1); hold off
axis([0 2.4 0 70]); xlabel('V (kft/sec)'); ylabel('h(kft)')
text(1.4,67,'Edot (mega ft-lb/sec)'); text(1.15,67,'-4')
text(1.3,60,'0'); text(1.33,48,'4'); text(1.38,37,'8')
text(1.33,26,'9'); text(1.5,28,'10'); text(1.65,34,'11')
text(.84,24,'12'); text(.84,16,'16'); text(.7,8,'20')
text(.78,6,'24'); text(.85,3,'28')
%print -deps2 \book_do\figures\f04_10