% FINDING SHOCK LOCATION BY INTERPOLATION
% Used in GuiDm_18
for j=ithro+1:n
  if (p_exs(j-1)-pr_ex)*(p_exs(j)-pr_ex) <0
    CC=(pr_ex-p_exs(j-1))/(p_exs(j)-p_exs(j-1));
    a_shk= ar(j-1) + (ar(j)-ar(j-1))*CC;
    x_shk= x(j-1) + (x(j)-x(j-1))*CC;
    T1_shk = T_su(j-1) + (T_su(j) - T_su(j-1))*CC;
    T2_shk = T_afs(j-1) + (T_afs(j) - T_afs(j-1))*CC;
    p_02int= p_02(j-1) + (p_02(j)-p_02(j-1))*CC;
%   [p_exs(j),p_exs(j-1),pr_ex];
%   [ar(j),ar(j-1),a_shk];
%   [x(j),x(j-1),x_shk];
%   [p_02(j),p_02(j-1),p_02int];
    break
  end
end
ar_shk=a_shk;







for i=1:n-1
  if x(i) <= x_shk & x_shk < x(i+1)
     i_shk=i+1; break 
  end    % shock in between i_shk-1 and i_shk
end
%
M1_shk = interp1(x(ithro:n), M_su(ithro:n),x_shk,'spline');
M2_shk = sqrt((M1_shk^2 + 5)/(7*M1_shk^2-1));
T_02   = T2_shk*(1+0.2*M2_shk^2);
p1_shk = interp1(x(ithro:n)',  pr_su(ithro:n)',x_shk,'spline');
p2_shk = p1_shk*(1.1666*M1_shk^2 - 0.16666);
p02_shk = p2_shk*( 1 + 0.2*M2_shk^2)^(1.4/0.4);
p_ratio = p2_shk/p1_shk;
p0rat=p2_shk/p02_shk;

    At1= (0.83333*(1+0.2*M1_shk^2)).^3/M1_shk ;
    At2= (0.83333*(1+0.2*M2_shk^2)).^3/M2_shk ;

    A_star2=ar_shk/At2;
Ma_shk=M_su;
pa_shk=pr_su;
Ta_shk=T_su;
for i=i_shk:n
   Ma_shk(i) = mach_(ar(i)/A_star2,  0);
   pa_shk(i)=p02_shk*( 1 + 0.2*Ma_shk(i).^2).^(-alph);
   Ta_shk(i)=T_02/(1 + 0.2*Ma_shk(i).^2);
end
%
xd=[x(1:i_shk-1),x_shk,x_shk, x(i_shk:n)];
Md=[Ma_shk(1:i_shk-1),M1_shk,M2_shk, Ma_shk(i_shk:n)];
pd=[pa_shk(1:i_shk-1),p1_shk,p2_shk, pa_shk(i_shk:n)];
Td=[Ta_shk(1:i_shk-1),T1_shk,T2_shk, Ta_shk(i_shk:n)];
subplot(hax1);
plot(xd,pd,'-',x,pr_sb,':g', x,pr_su,':r',...
      [x(n),x(n)+2],[pr_ex,pr_ex],'-r')
axis([0,12,0,2])
    ylabel('pressure ratio')
    xlabel('x')
    text(1,1.5,['exit pressure = ',num2str(pa_shk(n))])

subplot(hax4);


plot(xd,Md,'-',x,M_sb,':g',x,M_su,':r')
axis([0,12,0,3])
    ylabel('Mach number')
    xlabel('x')
    text(1,2.5,['exit Mach = ',num2str(Ma_shk(n))])

pa_exit=pa_shk(n);




subplot(hax2);


plot(xd,Td,'-',x,T_sb,':g',x,T_su,':r')
axis([0,12,0,1.5])
    ylabel('Temperature')
    xlabel('x')
    text(1,1.2,['exit temperature = ',num2str(Ta_shk(n))])





