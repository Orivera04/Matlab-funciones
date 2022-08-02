% A part of guidm_18

%==================================================
%pr_ex=input('Back Pressure ? ');
if pr_ex<0  break
end
hold off
  if pr_ex>1 
    text(2,1.4,'Impossible: P(inlet)<P(exit)');
%===============================================
  elseif pr_ex<1 & pr_ex>pe1 
%   text(2,.2,'Subsonic flow only');
    M_ex = m_exit(pr_ex);
    A_star = ar(n)* M_ex*( 0.83333*(1 + 0.2*M_ex^2 ))^(-3);
    for i=1:n
       M_act(i)=mach_(ar(i)/A_star,0);
       p_act(i)=(1 + 0.2*M_act(i)^2)^(-3.5);
       T_act(i) = 1/(1+ 0.2*M_act(i)^2);
    end

    subplot(hax1)
    plot(x,p_act,'-',x,pr_su,':r',x,pr_sb,':g',...
      [x(n),x(n)+2],[pr_ex,pr_ex],'-')
    axis([0 12 0 2])
    ylabel('Pressure ')
    xlabel('x')
    text(1,1.5,['exit pressure = ',num2str(p_act(n))])
    subplot(hax4)
    plot(x,M_act,'-',x,M_su,':r',x,M_sb,':g');
    axis([0 12 0 3])
    ylabel('Mach number')
    xlabel('x')
    text(1,2.5,['exit Mach = ',num2str(M_act(n))]) 
 text(1,2,'Subsonic flow only');
%==
    subplot(hax2)
    plot(x,T_act,'-');
    axis([0 12 0 1.5])
    ylabel('Temperture')
    xlabel('x')
    text(1,1.2,['exit temperature = ',num2str(T_act(n))])

%===============================================
  elseif pr_ex<pe1 & pr_ex>pe2
%    text(2,1.4,'Sub-super-shock-sub');
    aft_shk
%================================================
  elseif pr_ex<pe2 & pr_ex>pe3 
    
    subplot(hax1)
    axis([0 12 0 2])
    plot(x,pr_su,'-',x,pr_sb,':g',...
     [x(n),x(n),x(n)+2],[pr_su(n), pr_ex,pr_ex],'-r')
    axis([0 12 0 2])
    ylabel('Pressure')
    xlabel('x')
    text(1,1.75,['Back pressure = ',num2str(pr_ex)])
    text(1,1.5,['Exit pressure = ',num2str(pr_su(n)),...
       ' (before shock)'])

    subplot(hax4)
    plot(x,M_su,'-',x,M_sb,':g');
    axis([0 12 0 3])
    text(2,2.5,'Over-expansion:');
    text(2,2.0,'Oblique shocks after exit')
    ylabel('Mach number')
    xlabel('x')
    text(1,1.5,['Exit Mach = ',num2str(M_su(n)),...
       ' (before shock)'])

    subplot(hax2)
    plot(x,T_su,'-',x,T_sb,':g');
    axis([0 12 0 1.5])
    ylabel('Temperture')
    xlabel('x')
    text(1,1.3,['Exit Temperature = ',num2str(T_su(n))])

%===============================================
  elseif pr_ex<pe3  
    
    subplot(hax1)
    plot(x,pr_su,'-',x,pr_sb,':g',...
           [x(n),x(n)+2],[pr_ex,pr_ex],'-r')
    axis([0 12 0 2])
    ylabel('Pressure')
    xlabel('x')
    text(1,1.75,['Back pressure = ',num2str(pr_ex)])
    text(1,1.5,['Exit pressure = ',num2str(pr_su(n))])

    subplot(hax4)
    plot(x,M_su,'-',x,M_sb,':g');
    axis([0 12 0 3])
    text(2,2.5,'Under-expansion:');
    text(2,2.0,'Further expansion after exit');
    ylabel('Mach number')
    xlabel('x')
    text(1,1.5,['Exit Mach = ',num2str(M_su(n))])

    subplot(hax2)
    plot(x,T_su,'-',x,T_sb,':g');
    axis([0 12 0 1.5])
    ylabel('Temperature')
    xlabel('x')
    text(1,1.3,['Exit Temperature = ',num2str(T_su(n))])

  end



