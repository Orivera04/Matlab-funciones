% col_bar plots Figure A.2    
% On some pomputers, this program does not work 
% as intended.
set(gcf, 'NumberTitle','off','Name', 'Figure A.2; col_bar')
close;clear,clf
C=[hsv(64);cool(64);hot(64);prism(64);jet(64)];
colormap(C); caxis([1,320]);%caxis([1,477])
hold on
for M=1:5  for i=1:64;
    for j=1:2
      x(i,j)=(i-1)/63;
      y(i,j)=(j+8)*1.1 - (M-1)*2.2;
      z(i,j)=i+64*(M-1);
      if i==1 z(i,j)=z(i,j)+0.0001;end
      if i==64 z(i,j)=z(i,j)-0.0001;end
    end
  end
surface(x,y,z, z)
%pcolor(x,y,z)
end
text(0, 2.4+.1,'JET')
text(0, 4.6+0.1,'PRISM')
text(0, 6.8+0.1,'HOT')
text(0, 9.0+0.1,'COOL')
text(0, 11.2+0.1,'HSV')
axis([0,1,0,12])
%axis('off')
text(0.3,0,' <-----  Color Index  -----> ')
text(1,0,'64')
text(0,0,'1')
%print colorDISP.ps

