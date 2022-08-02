function [out1,out2] = winplt(id,points,power,opt)  % Paul Mennen  26-Mar-05
%
% winplt                Opens a GUI to display a user selected fft window.
%                              Purple trace: Time shape
%                              Green trace:  Frequency shape
%
% winplt(-1)            Displays a list of all windows and their id code.
%
% winplt(id)            Returns the name of the window associated with that id number (0 to 20)
%                       The second output argument (if given) will contain the convolution
%                       kernel for all windows defined by one (id codes >= 10)
%
% winplot(id,points)    Returns the amplitude corrected window time shape (of length points)
%
% winplot(id,points,1)  Returns the power corrected window time shape (of length points)
%
% Calling sequence:     [out1,out2] = winplt(id,points,power,opt)
%                       id:     An index specifying one of the FFT windows
%                       points: The number of points in the time window to be generated
%                       power:  0/1 = amplitude/power correction (default = 0)
%                       opt:    optional window parameter


% Define indices of WPh -----------------
LINEF  = 1;  % line: Frequency trace
LINET  = 2;  % line: Time trace
POPUPW = 3;  % popup: window selection
SLIDEB = 4;  % slider: number of bins
SLIDEH = 5;  % slider: number of Hann's
SLIDEP = 6;  % slider: window parameter
TEXTK  = 7;  % text: kernel
TEXTS  = 8;  % text: scallop loss
TEXTR  = 9;  % text: frequency resolution
TEXTE  = 10; % text: equivalent noise bandwidth
TEXTP  = 11; % text: process loss
% ----------------------------------------

global WPh;

fg = findobj('name','FFT window shapes'); % figure window if it is open
gui = length(fg);                         % true if the GUI is running
switch nargin
case 0,  % no arguments: Create the winplt window
  if gui close(fg); end; % can't have more than one winplt running
  ylim = [-145,3];
  WPh = plt([0 0],[0 1.3333;0 0],'FigName','FFT window shapes','AxisPos',[1 1 1 .9],...
    'Ylim',ylim,'YlimR',3.5+ylim/40,'TRACEid',['Freq';'Time'],'LabelX','Bin number',...
    'LabelY','Frequency shape (dB)','Options','-X-Y',...
    'LabelYr','Time shape                                            ');
  uicontrol('Style','Text','Units','Norm','Position',[.2 .905 .1 .04],...
            'String','Window:','BackGround',[.75 .75 .75]);
  s = [];  t = '';  k = 0;
  while ischar(t) s = [s '|' t];  t = winplt(k,0); k=k+1;  end;
  s = s(3:end);
  WPh = [WPh;
         uicontrol('Style','Popup','Units','Norm','Position',[.31 .91 .28 .04],...
                   'Value',2,'Callback','winplt(0)','BackGround',[0 1 1],'String',s);
         plt('slider',0,'init',[.803 505 130],[1 60 10 1 500],'# of bins','winplt(0)','on',...
                2,[.75 .75 .75; 0 1 1],['%1d';'%4w';'%2d']);
         plt('slider',0,'init',[.603 505 130],[1 10 1 1 10],'Hanning ^#','winplt(0)','on',...
                2,[.75 .75 .75; 0 1 1],['%1d';'%4w';'%2d']);
         plt('slider',0,'init',[.603 505 130],[1 2 1 1 2],' ','winplt(0)','on',...
                1,[.75 .75 .75; 0 1 1],['%3w';'%4w';'%3d']);
         text(0,0,''); text(0,0,''); text(0,0,''); text(0,0,''); text(0,0,'')];
  ax = get(findobj('string','Time'),'parent');
  p = get(ax,'pos'); p(2)=.87;  set(ax,'pos',p);  % make room for kernel string
  set(WPh(TEXTK:TEXTP),'fontsize',8,'units','norm','color',[.8 .8 .8],...;
       {'pos'},{[-.17 1.11]; [.01 .98]; [.01 .945]; [.01 .91]; [.01 .875]});
  ax = findobj('type','axes','ycolor',[1 0 1]);   % find right hand axis
  yt = get(ax,'ytick');  set(ax,'ytick',yt(1:4)); % remove some of the y tick labels
  winplt(0); % plot the default window (Hanning)

case 1, % One argument: Update the plot based on current popup/slider values
  if ~gui [out1 out2] = winplt(id,0); return; end;
  sz = 2048;   % number of points to plot for each window
  b = plt('slider',WPh(SLIDEB),'get');  v = get(WPh(POPUPW),'Value')-1;
  plt('slider',WPh(SLIDEH),'set','minmax',[1 b 1 b]);
  plt('cursor',get(get(WPh(1),'parent'),'UserData'),'set','xlim',[-b b]);
  t = winplt(v,sz,1);  % t = power corrected time window
  bins = 2*b;  sz2 = sz/2;  binres = bins/sz;
  h = 20*log10(eps+abs(fft([winplt(v,bins) zeros(1,sz-bins)]))); % freq shape
  h = h-h(1); % normalize to bin 0
  set(WPh(LINEF:LINET),'x',binres*(-sz2:sz2-1),{'y'},{[h(sz2+1:sz) h(1:sz2)];t}); % rotate h
  for r6=1:sz2 if h(r6)<-6 break; end; end; % look for 6dB bandwidth
  h = h(1:1+round(.5/binres));  sloss = max(h)-min(h);
  enbw = sz*sum(t.^2)/(sum(t)^2);  ploss = sloss + 10*log10(enbw);
  if sloss < .1 sloss = sloss*1000; su = ' mdB'; else su = ' dB'; end;
  set(WPh(TEXTS),'string',['Scallop loss = ' plt('ftoa','%6w',sloss) su]);
  set(WPh(TEXTR),'string',['Frequency res = ' plt('ftoa','%4w',2*(r6-1)*binres) ' bins']);
  set(WPh(TEXTE),'string',['Equiv Noise BW = ' plt('ftoa','%4w',enbw) ' bins']);
  set(WPh(TEXTP),'string',['Process loss = ' plt('ftoa','%4w',ploss) ' dB']);

otherwise, % 2,3,or 4 arguments ------------------------------------------------------------
  if ~points  % if # of points is zero, just return the window name in Out1 and the amplitude
              % corrected convolution kernel in Out2
    switch id
      case  0, out1='Boxcar';                     out2=1;
      case  1, out1='Hanning/Rife Vincent';       out2=0;
      case  2, out1='Chebyshev';                  out2={'chebwin',90,'Sidelobe level',[50 150]};
      case  3, out1='Kaiser';                     out2={'kaiser',12.26526,'Beta',[1 30]};
      case  4, out1='Gaussian';                   out2={'gausswin',4.3,'Alpha',[.1 8]};
      case  5, out1='Tukey';                      out2={'tukeywin',.5,'Taper size',[.01 1]};
      case  6, out1='Bartlett';                   out2={'bartlett'};
      case  7, out1='Modified Bartlett-Hanning';  out2={'barthannwin'};
      case  8, out1='Bohman';                     out2={'bohmanwin'};
      case  9, out1='Nuttall';                    out2={'nuttallwin'};
      case 10, out1='Hamming';                    out2=[1, -.428752];
      case 11, out1='Blackman';                   out2=[1, -.595238095, .095238095];
      case 12, out1='Exact Blackman';             out2=[1, -.58201156, .090007307];
      case 13, out1='Blackman Harris 61dB';       out2=[1, -.54898908, .063135301];
      case 14, out1='Blackman Harris 67dB';       out2=[1, -.58780096, .093589774];
      case 15, out1='Blackman Harris 74dB';       out2=[1, -.61793520, .116766542, -.002275157];
      case 16, out1='B-Harris 92dB (min 4term)';  out2=[1, -.68054355, .196905923, -.016278746];
      case 17, out1='Potter 210';                 out2=[1, -.61129, .11129];
      case 18, out1='Potter 310';                 out2=[1, -.684988, .2027007, -.0177127];
      case 19, out1='FlatTop (5 term)';           out2=[1,-.965, .645, -.194, .014];
      case 20, out1='FlatTop 41dB (Potter 201)';  out2=[.9990280, -.925752, .35196]; 
      case 21, out1='FlatTop 60dB (Potter 301)';  out2=[.9994484, -.955728, .539289, -.091581]; 
      case 22, out1='FlatTop 85dB (Potter 401)';  out2=[1, -.970179, .653919, -.201947, .017552];
      case 23, out1='FlatTop 98dB (Mennen 501)';  out2=[1, -.98069, .79548, -.41115, .104466 -.0080777];
      % case 24, out1='FlatTop 101dB (Mennen 601)'; out2=[1 -.98919 .858 -.56256 .249 -.05994 4.659e-3];
      case 24, out1=0; % indicates no more IDs
      otherwise k = 0;  t = winplt(k,0);
                while ischar(t) disp(sprintf('ID %2d: %s',k,t)); k=k+1; t=winplt(k,0); end;
    end;
    return;
  end;
  % here if number of points is non-zero: return the time domain window shape in Out1
  if nargin<3 power=0; end; % use amplitude correction if not specified
  if nargin<4 opt=0; end;   % optional window parameter

  [out1 c] = winplt(id,0);  % get convolution kernel
  if gui plt('slider',WPh(SLIDEH),'set','visOFF');
         plt('slider',WPh(SLIDEP),'set','visOFF');
         set(WPh(TEXTK),'string','');
  end;
  if iscell(c) % Here for Matlab computed windows ----------------------------------
    if length(c)>3                              % Here if there is a window parameter
      if gui                                    % Here if gui is active
         plt('slider',WPh(SLIDEP),'set','visON');
         if length(findobj('string',c{3}))                   % if the correct slider is already there
               c{2} = plt('slider',WPh(SLIDEP),'get');       % then just get the current slider value
         else  plt('slider',WPh(SLIDEP),'set','label',c{3}); % Otherwise set the slider parameters
               cc = [c{4} c{4}.*[.1 10]];
               plt('slider',WPh(SLIDEP),'set','minmax',cc);
               plt('slider',WPh(SLIDEP),'set',c{2});         % and set the slider value to the default
         end;
      elseif opt c{2}=opt; % If no gui use opt from arg list or c{2} if opt not specified
      end;
    end;
    if length(c)>1
          out1 = feval(c{1},points,c{2})';      % compute power corrected window (with option)
    else  out1 = feval(c{1},points)';           % compute power corrected window (without option)
    end;
    if ~power out1=out1*points/sum(out1); end;  % apply amplitude correction if needed
  else % here for kernel defined windows ------------------------------------------
    if ~c                                       % RifeVincent windows
      if gui                                    % if gui active, enable slider
          plt('slider',WPh(SLIDEH),'set','visON');
          p = plt('slider',WPh(SLIDEH),'get');  % get number of HANNs
          b = plt('slider',WPh(SLIDEB),'get');  % get number of bins
          if (p>b) p=b; plt('slider',WPh(SLIDEH),'set',p); end;
      else if ~opt opt=1; end;                  % no gui. Get # of HANNs from arg list
           p=opt;                               % and default to 1 if not specified
      end;
      c = zeros(1,p+1);                         % now compute RifeVincent kernel
      warning off;                              % ingore inexact nchoosek
      for k=0:p
        c(k+1) = (-1)^k * nchoosek(2*p,p-k);    % convolution kernel is row 2p
      end;                                      % of Pascal's triangle
      c = c/c(1);                               % normalized kernel for Rife Vincent windows
    end;                                        % end Rife Vincent
    % out1 =  points * real(ifft([c zeros(1,points-2*length(c)+1) fliplr(c(2:end))]));
    x = (0:points-1)/points;
    out1 = 0*x + c(1);
    for k = 2:length(c) % this calculation is equivalent to above ifft
      out1 = out1 + 2*c(k)*cos(2*pi*(k-1)*x);
    end;
    if power out1 = out1 / (sum(2*c.^2)-c(1)^2); end;
    if gui set(WPh(TEXTK),'string',[num2str(c) '   <-- kernel']); end;
  end; % end if iscell(c)
end;   % end switch nargin

%end function
