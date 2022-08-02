%REGOBPS  Plotting script for discrete-time observer-based regulator simulation.
%	  This script creates graphs after the Simulink model REGOBS has been
%	  executed.  Selection of the material displayed is menu driven.

%         R.J. Vaccaro 3/99

clf
t1=T*[0:ceil(ftime/T)-1];
kf_=length(t1);
[N_,m_]=size(gamma);
p_=length(u(1,:));
opt_=1;
iflg_=1;
x=xout(:,1:length(A));
while(opt_),
fprintf('\n\n -- REGOBP -- Discrete Observer-Based Regulator Plotting.\n\n');
  fprintf('     <1>  Plant State Variable (1--%g) \n',N_);
  fprintf('     <2>  Estimated State Variable (1--%g)\n',N_);
if p_==1
  fprintf('     <3>  Plant Input \n');
else
  fprintf('     <3>  Plant Input (1--%g) \n',p_);
end
if m_==1
  fprintf('     <4>  Plant Output \n');
else
  fprintf('     <4>  Plant Output (1--%g) \n',m_);
end
  fprintf('     <5>  Two Separate Graphs.\n');
  fprintf('     <6>  Two Overlayed Graphs.\n');
  fprintf('\n     <0>  Return to MATLAB.\n\n');

if iflg_
[tt1_,uu_]=zoh(t1,u(1:kf_,:)');
[tt1_,xhat1_]=zoh(t1,xhat(1:kf_,:)');
iflg_=0;
end

opt_=input('     Please enter a menu selection: ');fprintf('\n');

while isempty(opt_) | opt_ <0 | opt_>6 
   opt_=input('     Please enter a menu selection: ');
end 

if opt_==1 | opt_==2 | (opt_==3&p_>1) | (opt_==4&m_>1)
  wo_=input('    Which one?  ');
end

if (opt_==1),
  hold off;
  plot(t,x(:,wo_));
  title(sprintf('State Variable x_%g',wo_));
  xlabel('Time (seconds)')
  grid;
end

if (opt_==2),
  hold off;
  plot(tt1_,xhat1_(wo_,:));
  title(sprintf('Estimated State Variable xhat_%g',wo_));
  xlabel('Time (seconds)')
  grid;
end

if (opt_==3),
  hold off;
  if p_==1
    plot(tt1_,uu_);
    title('Plant Input u(t)');
    xlabel('Time (seconds)')
    grid;
  else 
    plot(tt1_,uu_(:,wo_));
    title(sprintf('Plant Input #%g',wo_))
    xlabel('Time (seconds)')
    grid;
  end
end

if (opt_==4),
  hold off;
  if m_==1
    plot(t,y);
    title('Plant Output y(t)');
    xlabel('Time (seconds)')
    grid;
  else
    plot(t,y(:,wo_));
    title(sprintf('Plant Output #%g',wo_))
    xlabel('Time (seconds)')
    grid;
  end
end

if opt_==5,
  tg_=0;
  wo1_=1;wo2_=1;
  while(tg_<1)|(tg_>4),
    tg_=input('From the options above what signal will be top graph ? ');
    if tg_==1 | tg_==2 | (tg_==3&p_>1) | (tg_==4&m_>1)
       wo1_=input('    Which one?  ');
    end
  end
  bg_=0;
  while(bg_<1)|(bg_>4),
    bg_=input('From the options above what signal will be bottom graph ? ');
    if bg_==1 | bg_==2 | (bg_==3&p_>1) | (bg_==4&m_>1)
       wo2_=input('    Which one?  ');
    end
  end
  clf;
  hold off;
  subplot(211);
  flp_=0;
  opt_=tg_;wo_=wo1_;
  while flp_<1.5
    flp_=flp_+1;
    if opt_==1
      plot(t,x(:,wo_))
      title(sprintf('State Variable x_%g',wo_))
      xlabel('Time (seconds)')
      grid
     end
     if opt_==2
      plot(tt1_,xhat1_(wo_,:))
      title(sprintf('Estimated State Variable x_%g',wo_))
      xlabel('Time (seconds)')
      grid
     end
     if opt_==3
      plot(tt1_,uu_(:,wo_))
      if p_==1
        title('Plant Input u(t)')
      else
        title(sprintf('Plant Input #%g',wo_))
       end
      xlabel('Time (seconds)')
      grid
     end
     if opt_==4
      plot(t,y(:,wo_))
      if m_==1
        title('Plant Output y(t)')
      else
        title(sprintf('Plant Output #%g',wo_))
       end      
      xlabel('Time (seconds)')
      grid
     end
     subplot(212)
     opt_=bg_;
     wo_=wo2_;
  end
end

if opt_==6,
  tg_=0;
  wo1_=1;wo2_=1;
  while(tg_<1)|(tg_>4),
    tg_=input('From the options above what is the first signal ? ');
    if tg_==1 | tg_==2 | (tg_==3&p_>1) | (tg_==4&m_>1)
       wo1_=input('    Which one?  ');
    end
  end
  bg_=0;
  while(bg_<1)|(bg_>4),
    bg_=input('From the options above what is the second signal ? ');
    if bg_==1 | bg_==2 | (bg_==3&p_>1) | (bg_==4&m_>1)
       wo2_=input('    Which one?  ');
    end
  end
  clf;
  hold off;
  if tg_==1
   plot(t,x(:,wo1_));hold on
   tt_=sprintf('State Variable x_%g',wo1_);
  end
  if tg_==2
   plot(tt1_,xhat1_(wo1_,:));hold on
   tt_=sprintf('Estimated State Variable xhat_%g',wo1_);
  end
  if tg_==3
   plot(tt1_,uu_(:,wo1_));hold on
   if p_==1
    tt_='Plant Input u(t)';
   else
     tt_=sprintf('Plant Input #%g',wo1_);
   end
  end
  if tg_==4
   plot(t,y(:,wo1_));hold on
   if m_==1
    tt_='Plant Output y(t)';
   else
     tt_=sprintf('Plant Output #%g',wo1_);
   end
  end
  if bg_==1
   plot(t,x(:,wo2_),'--');
   bt_=sprintf('State Variable x_%g',wo2_);
  end
  if bg_==2
   plot(tt1_,xhat1_(wo2_,:),'--');
   bt_=sprintf('Estimated State Variable xhat_%g',wo2_);
  end
  if bg_==3
   plot(tt1_,uu_(:,wo2_),'--');hold on
   if p_==1
    bt_='Plant Input u(t)';
   else
     bt_=sprintf('Plant Input #%g',wo2_);
   end
  end
  if bg_==4
   plot(t,y(:,wo2_),'--');
   if m_==1
    bt_='Plant Output y(t)';
   else
     bt_=sprintf('Plant Output #%g',wo2_);
   end
  end
  title([tt_ '(solid), ' bt_ '(dashed)']);
  xlabel('Time (seconds)')
  grid;
end
end

clear xhat1_ flp_ iflg_ kf_ N_ m_ bdat_ bg_ bt_ i_ opt_ tdat_ tg_ tt_
clear ttt_ tttt_  uu_ tt1_ wo_ wo1_ wo2_ k_ p_

% ___________________ END OF REGOBPS.M ___________________________________
