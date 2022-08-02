% © Gergo Lajos 1998; program az Interpolacio c. reszhez

 x=[-1,0,1,2,3];
 y=sin(x);
 p1=polyfit(x,y,1)
 p2=polyfit(x,y,2)
 p3=polyfit(x,y,3)
 xx=-1:0.1:3;
 p1gr=polyval(p1,xx);
 p2gr=polyval(p2,xx); 
 p3gr=polyval(p3,xx); 

 plot(xx,p1gr,'.',xx,p2gr,'-.',xx,p3gr,'--',...
 xx,sin(xx),'-',x,y,'*');
 tx=[0.5,0.8]:ty=[-0.2,-0.2];
 plot(tx,ty,'.',tx,ty-0.2,'-.',tx,ty-0.4,'--',...
 tx,ty-0.6,'-');
 text(1,-0.2,'1-ofoku');
 text(1,-0.4,'2-odfoku'); 
 text(1,-0.6,'3-adfoku'); 
 text(1,-0.8,'a pontos'); 