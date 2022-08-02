%AREGP  Plotting script for analog regulator simulation.
%       This script that creates graphs for the analog regulator 
%	simulation AREG.  Selection of the material displayed is menu driven.

%       R.J. Vaccaro 10/93,11/98
%__________________________________________________________________________


kf_=length(t1);

[N_,m_]=size(b);

opt_=1;
while(opt_),
fprintf('\n\n     -- AREGP -- Analog Regulator Plotting.\n\n');
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

opt_=input('     Please enter a menu selection: ');

while isempty(opt_) | opt_ <0 | opt_>N_+m_+2 
   opt_=input('     Please enter a menu selection: ');
end   

if (opt_>0)&(opt_<=N_),
  hold off;subplot(111)
  plot(t1,x(opt_,:));
  title(sprintf('State Variable x_%g',opt_));
  xlabel('Time (seconds)')
  grid;
end

if (opt_>N_) & (opt_ <= N_+m_),
  hold off;subplot(111)
  if m_==1
    plot(t1,u);
    title('Plant Input u(t)');
    xlabel('Time (seconds)')
    grid;
  else 
    plot(t1,u(opt_-N_,:));
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
    tdat_=u(tg_-N_,:);
    if m_==1,
      tt_='Plant Input u(t)';
    end
    ttt_=t1;
  else,
    tdat_=x(tg_,:);
    tt_=sprintf('State Variable x_%g',tg_);
    ttt_=t1;
  end
if (bg_>N_) & (bg_ <= N_+m_),
    bdat_=u(bg_-N_,:);
    tttt_=t1;
    if m_==1,
      bt_='Plant Input u(t)';
    end
  else,
    bdat_=x(bg_,:);
    bt_=sprintf('State Variable x_%g',bg_);
    tttt_=t1;
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
    tdat_=u(tg_-N_,:);
    if m_==1,
      tt_='Plant Input u(t)';
    end
    ttt_=t1;
  else,
    tdat_=x(tg_,:);
    tt_=sprintf('State Variable x_%g',tg_);
    ttt_=t1;
  end
if (bg_>N_) & (bg_ <= N_+m_),
    bdat_=u(bg_-N_,:);
    tttt_=t1;
    if m_==1,
      bt_='Plant Input u(t)';
    end
  else,
    bdat_=x(bg_,:);
    bt_=sprintf('State Variable x_%g',bg_);
    tttt_=t1;
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
    if (tg_>N_) & (bg_ > N_)
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

clear kf_ N_ m_ bdat_ bg_ bt_ i_ opt_ tdat_ tg_ tt_ ttt_ tttt_ 

% ___________________ END OF AREGP.M ___________________________________
