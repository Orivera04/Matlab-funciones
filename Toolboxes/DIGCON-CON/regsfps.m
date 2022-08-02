%REGSFPS  Plotting script for discrete-time regulator simulation.    
%	  This is a MATLAB script that creates graphs after the Simulink
%	  model REGSFS has been executed.  Selection of the material displayed 
%	  is menu driven.

%         R.J. Vaccaro 3/99
%__________________________________________________________________________

clf
t1=T*[0:ceil(ftime/T)-1];
kf_=length(t1);
[N_,m_]=size(gamma);

opt_=1;
iflg_=1;
while(opt_),
fprintf('\n\n     -- REGSFP -- Full-State-Feedback Regulator Plotting.\n\n');
for i_=1:N_,
  fprintf('     <%g>  State Variable x_%g v. Time\n',i_,i_);
end
for i_=N_+1:N_+m_,
  if m_==1,
    fprintf('     <%g>  Plant Input u(t) v. Time.\n',N_+1);
  else
    fprintf('     <%g>  Input #%g v. Time.\n',i_,i_-N_);
  end
end
fprintf('     <%g>  Two Separate Graphs.\n',N_+m_+1);
fprintf('     <%g>  Two Overlayed Graphs.\n',N_+m_+2);
fprintf('\n     <0>  Return to MATLAB.\n\n');

if iflg_
[tt1_,uu_]=zoh(t1,u(1:kf_,:)');
iflg_=0;
end

opt_=input('     Please enter a menu selection: ');

while isempty(opt_) | opt_ <0 | opt_>N_+m_+2
   opt_=input('     Please enter a menu selection: ');
end 

if (opt_>0)&(opt_<=N_),
  hold off;
  plot(t,x(:,opt_));
  title(sprintf('State Variable x_%g',opt_));
  xlabel('Time (seconds)')
  grid;
end

if (opt_>N_) & (opt_ <= N_+m_),
  hold off;
  if m_==1
    plot(tt1_,uu_);
    title('Plant Input u(t)');
    xlabel('Time (seconds)')
    grid;
  else 
    plot(tt1_,uu_(opt_-N_,:));
    title(sprintf('Input #%g',opt_-N_))
    xlabel('Time (seconds)')
    grid;
  end
end

if opt_==N_+m_+1,
  tg_=0;
  while(tg_<1)|(tg_>N_+m_),
    tg_=input('From the options above what signal will be top graph ? ');
  end
  bg_=0;
  while(bg_<1)|(bg_>N_+m_),
    bg_=input('From the options above what signal will be bottom graph ? ');
  end
  if (tg_>N_) & (tg_ <= N_+m_),
    tdat_=uu_(tg_-N_,:);
    if m_==1,
      tt_='Plant Input u(t)';
    end
    ttt_=tt1_;
  else,
    tdat_=x(:,tg_);
    tt_=sprintf('State Variable x_%g',tg_);
    ttt_=t;
  end
if (bg_>N_) & (bg_ <= N_+m_),
    bdat_=uu_(bg_-N_,:);
    tttt_=tt1_;
    if m_==1,
      bt_='Plant Input u(t)';
    end
  else,
    bdat_=x(:,bg_);
    bt_=sprintf('State Variable x_%g',bg_);
    tttt_=t;
  end
  clf;
  hold off;
  subplot(211);
  plot(ttt_,tdat_);
  if m_==1 | tg_ <= N_,	
    title(tt_);
  else
    title(sprintf('Input #%g',tg_-N_));
  end
  xlabel('Time (seconds)')
  grid
  subplot(212);
  plot(tttt_,bdat_);
  if m_==1 | bg_ <= N_,      
    title(bt_);
  else
    title(sprintf('Input #%g',bg_-N_));
  end
  xlabel('Time (seconds)')
  grid;
  subplot(111);
end

if opt_==N_+m_+2,
  tg_=0;
  while(tg_<1)|(tg_>N_+m_),
    tg_=input('From the options above what is the first signal ? ');
  end
  bg_=0;
  while(bg_<1)|(bg_>N_+m_),
    bg_=input('From the options above what is the second signal ? ');
  end
  if (tg_>N_) & (tg_ <= N_+m_),
    tdat_=uu_(tg_-N_,:);
    if m_==1,
      tt_='Plant Input u(t)';
    end
    ttt_=tt1_;
  else,
    tdat_=x(:,tg_);
    tt_=sprintf('State Variable x_%g',tg_);    
    ttt_=t;
  end
if (bg_>N_) & (bg_ <= N_+m_),
    bdat_=uu_(bg_-N_,:);
    tttt_=tt1_;
    if m_==1,
      bt_='Plant Input u(t)';
    end
  else,
    bdat_=x(:,bg_);
    bt_=sprintf('State Variable x_%g',bg_);
    tttt_=t;
  end
  clf;
  hold off;
  subplot(111);
  plot(ttt_,tdat_,'-')
  hold on
  plot(tttt_,bdat_,'--');
  hold off
  if m_==1 | ((tg_<=N_)&(bg_<=N_)),
    title([tt_ '(solid), ' bt_ '(dashed)']);
  else
    if (tg_P>N_) & (bg_ > N_)
      title(sprintf('Input #%g (solid),  Input #%g (dashed)',tg_-N_,bg_-N_))
    elseif (tg_>N_) & (bg_ <= N_)
      title(sprintf('Input #%g (solid),   %s (dashed)',tg_-N_,bt_))
    elseif  (tg_<= N_) & (bg_>N_)
      title(sprintf('%s (solid),   Input #%g (dashed)',tt_,bg_-N_))
    end
  end
  xlabel('Time (seconds)')
  grid;
end

end	% end while loop

clear iflg_ kf_ N_ m_ bdat_ bg_ bt_ i_ opt_ tdat_ tg_ tt_ ttt_ tttt_ uu_ tt1_


return;

% ___________________ END OF REGSFPS.M ___________________________________
