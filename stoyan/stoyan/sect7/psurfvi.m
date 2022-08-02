% © Gergo Lajos 1998; program a Grafika c. reszhez
 x=-2:0.3:2;
 [X,Y]=meshgrid(x,x);
 ZS=cos(X).*sin(Y);
 a(1)=axes('Position',[0.1 0.1 0.2 0.2]);
 a(2)=axes('Position',[0.8 0.1 0.2 0.2]);
 a(3)=axes('Position',[0.8 0.8 0.2 0.2]);
 a(4)=axes('Position',[0.1 0.8 0.2 0.2]);
 a(5)=axes('Position',[0.3 0.3 0.5 0.5]);
 for i=1:5
     axes(a(i));
     surf(ZS);
     if i==1
             view(40,30);
     elseif i==2
             view(-40,70);
     elseif i==3
             view(10,30);
     elseif i==4
             view(0,-20);
     end;
  end;