function out = editz(In1)  % A primitive filter design program.
                           % A good example of plt data editing.

if ~nargin                      % editz from the command prompt (no arguments)
  close all;                    % remove previous figure windows
  z = roots([1 4.3 8 8 4.3 1]); % initial numerator polynomial
  p = roots([1 .38 .82]);       % initial denominator polynomial
  z = z(find(imag(z)>-1e-5));   % plot only upper half of unit circle
  p = p(find(imag(p)>-1e-5));
  uc = exp((0:.01:1)*pi*1j);    % uc = half unit circle (101 points)
  x = (0:500)/1000;             % frequency axis
  set(0,'units','pix');  ssz = get(0,'screensize');
  pos = [7 46 755 480];         % figure positions
  if ssz(4) > 1180  pos2 = pos + [0 pos(4)+45 0 0];
  else  pos2 = pos([3 4]);
        pos2 = [ssz([3 4]) - pos2 - pos([1 2]) pos2];
  end;
  fr = plt(x,x,'FigName','Frequency response','Ylim',[-100 1],...
       'LabelX','Fraction of sample rate','LabelY','dB','Title','QQ',...
       'ENApre',[0 0],'Position',pos2);   % frequency response plot
  x1 = -.18;  x2 = -.02;  dx = (x2-x1)/3; % position of spare box
  y1 = -.16;  y2 = -.08;
  zs = complex(x1+dx,(y1+y2)/2);          % append spare zeros and poles
  z = [zs; zs; z];  p = [z(1:2)+dx; p];
  pz = plt('Xlim',[-1.1 1.1],'Ylim',[-.19,1.3],...
       'Styles','nn-','Markers','oxn','ENAcur',[1 1 0],...
       'LabelX','real','LabelY','imag','FIGname','Pole/Zero plot',...
       'TRACEid',['Zeros '; 'Poles ';'circle'],'Position',pos,...
       'TRACEc',[0 1 1; 1 1 0; .5 .5 .5],...
       real(z),imag(z),real(p),imag(p),real(uc),imag(uc)); % pole/zero plot
  plt('cursor',get(gca,'UserData'),'set','moveCB','editz(1)'); % cursor callback
  line([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1]); % draw box for spare poles/zeros
  set(text(x1,y2+.04,' spares'),'color','blue','fontsize',8); % and label it
  t = [...
    text(-1.46,1.1,'editz help');
    text(-.6,1.1, 'Only the roots on or above the x axis are shown');
    text(-.6,.70, '- To move a root:');
    text(-.6,.63, '      Click on it');
    text(-.6,.56, '      Then right click on the x-cursor edit box');
    text(-.6,.49, '      Then drag the root to the desired location');
    text(-.6,.42, '      The root will snap to the x-axis if you get close');
    text(-.6,.35, '      A zero will snap to the unit circle if you get close');
    text(-.6,.25, '- To add a root, drag one from the spare box');
    text(-.6,.15, '- To remove a root, drag it below the x-axis')];
  set(t,'units','normal','color',[.7 .7 1]);
  set(t(2),'fontweight','bold');
  set(findobj('string','QQ'),'tag','editz','user',[pz(1:2); fr; t]); % save handles
  set(t(1),'ButtonDownFcn','editz(2)');
  editz(0); % update the frequency response plot
else  % cursor callback comes here
  title = findobj('tag','editz'); % find title where handles are stashed
  u = get(title,'user');
  if In1==2                               % toggle help on/off
    In1 = get(u(end),'visible');
    if In1(2)=='n' In1='off'; else In1='on'; end;
    set(u(5:end),'visible',In1);          % set help visibility
    return;
  end;
  if isempty(getappdata(gcf,'NewData')) & In1 return; end; % skip the rest if data not modified
  if In1 set(u(5:end),'visible','off'); end; % turn off help text after first time
  z = complex(get(u(1),'x'),get(u(1),'y'));  % get zeros and poles from plot
  p = complex(get(u(2),'x'),get(u(2),'y'));
  z3 = z(3:end);  p3 = p(3:end);          % don't use the spares in H(z)
  if z(1) ~= z(2)  z3 = [z(1) z3]; end;   % if a spare was used, create another one
  if p(1) ~= p(2)  p3 = [p(1) p3]; end;
  ytol = diff(get(gca,'ylim'))/80;        % snap to tolerance
  z3(find(imag(z3)<-ytol)) = [];          % delete any roots dragged below the x axis
  p3(find(imag(p3)<-ytol)) = [];
  az = find(abs(imag(z3))<ytol);          % any roots close to the x axis?
  ap = find(abs(imag(p3))<ytol);
  z3(az) = real(z3(az));                  % if so, snap to the x axis
  p3(ap) = real(p3(ap));
  az = find(abs(1-abs(z3))<ytol);         % any zeros close to the unit circle?
  z3(az) = exp(angle(z3(az))*1j);         % if so, snap to the unit circle
  z = [z(2) z(2) z3]; set(u(1),'x',real(z),'y',imag(z)); % in case anything changed
  p = [p(2) p(2) p3]; set(u(2),'x',real(p),'y',imag(p));
  z = [z3 conj(z3(find(imag(z3)>1e-5)))]; % append complex conjugates
  p = [p3 conj(p3(find(imag(p3)>1e-5)))]; % append complex conjugates
  [pn pd] = zp2tf(z.',p.',1);             % compute polynomials
  x = get(u(3),'x');
  H = 20*log10(abs(freqz(pn,pd,2*pi*x))); % compute frequency response (db)
  set(u(3),'y',H-max(H));                 % update frequency response plot
  s = 'H(z) = [';                         % put polynomials in graph title
  p = [pn pd];   l = length(p);  ln = length(pn);
  if l>14 fmt='%4w'; else fmt='%5w'; end;
  for k=1:l  switch k case ln,   t = '] / [';
                      case l,    t = ']';
                      otherwise, t = '  ';
             end;
             s = [s plt('ftoa',fmt,p(k)) t];
  end;
  set(title,'string',s);
  setappdata(gcf,'NewData',[]);           % reset data modified flag
end;