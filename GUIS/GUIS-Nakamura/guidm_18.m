% GuiDm_18 plots Figure E.17
% Copyright S. Nakamura, 1995
close;clear,clf,hold off
hfig=figure(1);
set(hfig,'Position',[50 50 700 500],'Color',[0.8 0.8 .8], 'NumberTitle','off',...
'Name','GuiDm_18  Quasi-1D Flow through a Converging-Diverging Nozzle');

clf
hax0=axes('position',[.1 .10 .35 .2]);
hax1=axes('position',[.1 .40 .35 .2]);
hax2=axes('position',[.62 .40 .35 .2]);
hax3=axes('position',[.1 .70 .35 .2]);
hax4=axes('position',[.62 .70 .35 .2]);

%n=input('Number of points (40 is recommended)? ')
n=40;
dx=10/(n);
n=n+1;
x=0:dx:10;
y=0.3*(x-2).*(x-10)+10;
a=pi*y.^2;
ymin=min(y);
y=y/ymin;
subplot(hax0)
plot(x,y,'-r',x,-y,'-r')

axis([0 12 -max(y) max(y)])
xlabel('x')
ylabel('Radius')
title('Nozzle profile')

subplot(hax3)
%axis([0 10 0 10])
%plot(x,y)
%pause
%subplot(211)
amin=min(a);
ymin=10000;
m_afs=zeros(1,n);
for i=1:n
   if ymin>y(i), ymin=y(i); ithro=i;end
end
ar=a./amin;
for i=1:n
  M_sb(i)=mach_(ar(i),0);
  T_sb(i)=1/( 1+0.2*M_sb(i)^2);
  if i<ithro   M_su(i)=M_sb(i); T_su(i)=T_sb(i);
  else 

     M_su(i)=mach_(ar(i),ar(i));
     T_su(i)=1/( 1+0.2*M_su(i)^2);
     M_afs(i)=sqrt((M_su(i)^2 + 5)/(7*M_su(i)^2-1));
     T_afs(i)=1/( 1+0.2*M_sb(i)^2);
  end
end
k=1.4;
alph=k/(k-1);       % alph = 3.5
pr_su=( 1 + 0.2*M_su.^2).^(-alph);
pr_sb=( 1 + 0.2*M_sb.^2).^(-alph);

for i=1:n
  if i>=ithro
     p_afs(i)=pr_su(i)*(1.16666*M_su(i)^2 - 0.16666);
     T_afs(i)=T_su(i)*(1 + 0.2*M_su(i)^2)/(1 + 0.2*M_afs(i)^2);
     AAs(i)= (0.83333*(1+0.2*M_afs(i)^2)).^3/M_afs(i);
     a_star2(i)=ar(i)/AAs(i);
     M_exs(i)=  mach_(ar(n)/a_star2(i),0);  %ar(n)/a_star2(i));
     p_02(i)=p_afs(i)* (1 + 0.2*M_afs(i)^2)^alph;
     p_exs(i)=p_02(i)/(1 + 0.2*M_exs(i)^2)^alph;
  end
end
%clg
%plot(x,p_afs,x,a_star2,x,M_exs)
%pause
%disp('x, M_su,M_afs,M_exs')
%[x', M_su',M_afs',M_exs']
%disp('x, p_su,p_afs,p_02, p_exs')
%[x', pr_su',p_afs',p_02',p_exs']
%      [ p_afs'./pr_su',AAs',a_star2',p_02',p_exs']


plot(x,pr_su,':r',x,pr_sb,':g')
axis([0 12 0 1.5])
ylabel('Pressure Ratio')
xlabel('x')
title('Reference Relation ')
hold on
Msex=M_su(n);
pe1 = pr_sb(n);
%p_afs(n),Msex
%  p_afs(n)=pr_su(n)*( 1.16666*M_su(n)^2 - 0.16666);
  pe2     =pr_su(n)*( 1.1666*Msex^2-0.16666);
pe3=pr_su(n);
plot([x(n),x(n),x(n)+2],[pr_su(n),pe2,pe2],':c')
%pr_sb(n)
ht1=text(x(n)+2.05,pe3, ['pe3=',num2str(pe3)]);
ht2=text(x(n)+2.05,pe1, ['pe1=',num2str(pe1)]);
ht3=text(x(n)+2.05,pe2, ['pe2=',num2str(pe2)]);
set(ht1,'FontSize',7);
set(ht2,'FontSize',7);
set(ht3,'FontSize',7);


hexpt=uicontrol(hfig,'Style','text','String','Specify Back Pressure',...
                 'Position',[500 85 140 40]);
hexpt1=uicontrol(hfig,'Style','text','String','',...
                 'Position',[500 65 140 20]);
hexpt2=uicontrol(hfig,'Style','edit','String','0.82',...
                 'Position',[520 65  40 20],...
                 'Callback',...
                 'pr_ex=str2num(get(hexpt2,''String''));nozz_p2');
hexpt3=uicontrol(hfig,'Style','text','String',' ',...
                 'Position',[560 65 40 20],...
                 'HorizontalAlignment','Left');
%hexpr=uicontrol(hfig,'Style','text','String',...
%                 '.01 atm . . . . . . . . . . . . . . . . . . . . . . . . 10 atm',...
%                'Position',[500 45 300 20]);
%hexps=uicontrol(hfig,'Style','slider','Min',.01,'Max',10,...
%                 'Position',[500 25 300 20],'Value',.82,...
%                 'Callback','resetpe');
hrun=uicontrol(hfig,'Style','pushbutton','String','Push to quit.',...
                 'Position',[700 670 80 30],...
                 'Callback','close');
hrunb=uicontrol(hfig,'Style','text',...
                 'String','Variables are all normalised by stagnation values.',...
                 'Position',[10 670 400 30]);

%nozz_p2






