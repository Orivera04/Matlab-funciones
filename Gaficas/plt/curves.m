function Out = curves(In)

global CRlines CRq CRp CRi CRa CRb;

qName = 1;  % define columns of CRq
qT    = 2;
qXlim = 3;
qYlim = 4;
qa    = 5;
qb    = 6;
qc    = 7;
qSty  = 8;
qXoff = 9;
qYoff = 10;
qEval = 11;

TXtrc = 1;  % define user edit strings
TXa   = 2;
TXb   = 3;
TXc   = 4;
TXxof = 5;
TXyof = 6;
TXstp = 7;
TXtmn = 8;
TXtmx = 9;
TXsty = 10;

if ~nargin
  % Curve Name             [n tmin tmax]  Xlim        Ylim        a                   b                 c             Style         Xoffset             Yoffset
  P2 = 2*pi;
  CRq = ...
  {'Arachnida            ' [196 0 P2]     [-5.6 1.2]  [-1.4 1.4]  [2 3 5]             [3 2 4]           0             [1 8 1]       [0 -2 -4]           0                   ...
                           'r=sin(a*t)./sin(b*t);; x=r.*cos(t); y=r.*sin(t);';
   'Archimedian Spiral   ' [800 0 8*pi]   [-26 47]    [-29 23]    [-1 -2 1 2]         [30 600 1 .05]    0             1             [30 30 0 0]         [10 10 0 0]         ...
                           'r=b.*t.^a;; x=r.*cos(t); y=r.*sin(t);';
   'Bell curve           ' [800 -4 4]     [-4 4]      [-.1 1.1]   [5 7 10 15 20 25]   0                 0             1             0                   0                   ...
                           'x=t; a=a/10; y=exp(-x.^2/(2*a.^2));';
   'Bicuspid curve       ' [9999 -1 1]    [-1.7 1.7]  [-1.2 1.2]  [1 1 -1 -1]         [1 -1 1 -1]       0             9             0                   0                   ...
                           'x=a*sqrt(1+b*sqrt((1-t).^2.*(1-t.^2))); y=-t;; y(find(imag(x)))=Inf;';
   'Bullet nose          ' [300 0 P2]     [-9 9]      [-1.1 1.1]  [3 4 5 6 8 10]      0                 0             3             0                   0                   ...
                           'x=a*cot(t); y=cos(t);; y(find(abs(t-pi)<1e-6))=Inf;';
   'Butteryfly curve     ' [2000 0 24*pi] [-3.9 3.9]  [-2.8 4.2]  24                  5                 4             1             0                   0                   ...
                           'r=exp(sin(t))-2*cos(c*t)+sin((2*t-pi)/a).^b;; x=r.*cos(t); y=r.*sin(t);';
   'Catenary             ' [200 -pi pi]   [-1.7 1.7]  [-.1 6]     [15 10 7 4 2 1]     0                 0             [1 1 1 1 1 6] 0                   0                   ...
                           'a=a/10; x=t; y=a*cosh(t/a);';
   'Cissoid of Diocles   ' [800 1.9 4.4]  [-.3 10.2]  [-13 13]    [5 6 7 8 9 10]      0                 0             1             [0 .5 1 1.5 2 2.5]  0                   ...
                           'r=a*tan(t).*sin(t);; x=r.*cos(t); y=r.*sin(t);';
   'Cochleoid            ' [800 0 8*pi]   [-.25 1.05] [-.1 .8]    0                   0                 0             1             0                   0                   ...
                           'r=sin(t)./t;; x=r.*cos(t); y=r.*sin(t);';
   'Cocked hat curve     ' [800 0 8*pi]   [-1.5 1.5]  [-3.5 14]   [-2 -1 0 1 2 5]     0                 0             1             0                   [0 1.5 3 4.5 6 7]   ...
                           'x=sin(t); y=cos(t).^2.*(a+cos(t))./(1+sin(t).^2);';
   'Conchoid of Nicomedes' [800 0 P2]     [-15 15]    [-3.3 5.4]  [4 3 2 1 2 1]       [1 1 1 1 3 2]     0             1             0                   0                   ...
                           'r=a+b*csc(t);; x=r.*cos(t); y=r.*sin(t);';
   'Cranioid             ' [800 0 P2]     [-17 17]    [-9 21]     6                   13                16            8             0                   0                   ...
                           'r=a*sin(t)+b*sqrt(1-c*cos(t).^2/20);; x=r.*cos(t); y=r.*sin(t);'
   'Cycloid              ' [800 0 18]     [1.7 16]    [-2.3 5.3]  [10 7 4 13 16 -10]  [10 7 4 13 16 10] 0             [8 3 3 1 1 8] 0                   [3 .5 1 2 -1 -2]    ...
                           'x=t-a*sin(t)/10; y=1-b*cos(t)/10;'
   'Devil''s curve       ' [800 0 P2]     [-3 3]      [-3 3]      [1 1 1 1 2 3]       [1.4 2 3 4 3 4]   0             1             0                   0                   ...
                           'v=sin(t).^2; w=cos(t).^2; r=sqrt((a*v-b*w)./(v-w));; x=r.*cos(t); y=r.*sin(t);'
   'Dumbbell curve       ' [801 -1 1]     [-2 2]      [-.6 2]     [0 23 7 30 37 53]   0                 0             1             [0 1 -1 0 -1 1]     [0 1 1 0 1 1]       ...
                           'r=sqrt(t.^2+t.^4-t.^6); w=acos(t./r)+(a*pi/30); x=r.*cos(w); y=r.*sin(w);'
   'Ellipse & evolute    ' [800 0 6*pi]   [-31 31]    [-1.1 1.1]  [30 27 24 21 18 15] 0                 0             1             0                   0                   ...
                           'v=bitor(floor(t/pi),1); x=a.*cos(t).^v; y=sin(t).^v;';
   'Epispiral            ' [800 0 P2]     [-25 25]    [-13 13]    [2 3 4]             11                0             [1 8 1]       [-16 -3 14]         0                   ...
                           'r=abs(sec(a*t));; x=r.*cos(t); y=r.*sin(t); y(find(abs(complex(x,y))>b))=Inf;';              
   'Epitrochoid          ' [800 0 10*pi]  [-38 36]    [-22 29]    [8 5 14 2 2 2]      [5 3 1 1 2 3]     [5 5 1 1 2 3] [1 1 6 1 8 1] [-18 18 18 1 -16 2] [0 0 0 -15 0 19]    ...
                           'w=(1+a/b)*t; x=(a+b)*cos(t)-c*cos(w); y=(a+b)*sin(t)-c*sin(w);'
   'Euler''s spiral      ' [200 -3.5 3.5] [-.8 .8]    [-.85 .85]  0                   0                 0             1             0                   0                   ...
                           'x=mfun(''FresnelS'',t); y=mfun(''FresnelC'',t);';
   'Fish Curve           ' [300 0 P2]     [-1.24 1.2] [-.7 .7]    1                   0                 0             11            0                   0                   ...
                           'p=sin(t); q=cos(t); x=a*q-a*p.^2/sqrt(2); y=a*p.*q;';
   'Folium of Descartes  ' [801 -6 6]     [-3.2 3.7]  [-2.9 2.5]  1                   0                 0             8             0                   0                   ...
                           't=t.^3; v=1+t.^3; x=3*a*t./v; y=3*a*t.^2./v;';
   'Fourier Series       ' [800 -2 12]    [-2 12]     [-2.5 11.5] [2 2 1 2 4 1]       [1 0 1 1 1 1]     [2 1 1 1 1 2] [1 1 8 1 1 8] 0                   [10 7.6 4.4 2.2 0 -1.2] ...
                           'x=t; v=0:25; w=1+a*v; v=b*v; y=((-1).^v./(w.^c))*sin(w''*t);';
   'Gear Curve           ' [800 0 P2]     [-3 3]      [-2.2 2.2]  [1 1.4 1.8]         8                 [4 9 15]      1             0                   0                   ...
                           'r=a+tanh(b*sin(c*t))/b;; x=r.*cos(t); y=r.*sin(t);';
   'Hypocycloid          ' [800 0 14*pi]  [-11 8]     [-6 6]      [3 5 4 5 pi]        [1 1 1 3 1]       0             [8 1 1 1 1]   [6 0 -7 0 -7]       0                   ...
                           'v=a-b; p=t*v/b; x=v*cos(t)-b*cos(p); y=v*sin(t)+b*sin(p);';
   'Limacon              ' [200 0 P2]     [-40 150]   [-80 80]    [48 42 20 3]        [48 32 40 48]     0             [1 8 1 1]     [-15 0 0 85]        0                   ...
                           'r=a+b*cos(t);; x=r.*cos(t); y=r.*sin(t);';
   'Lissajous curves     ' [400 0 P2]     [-9 11]     [-1.2 1.2]  [1 5 1 1]           [2 4 2 3]         [99 99 2 1]   [1 1 8 8]     [6 0 -7 9]          0                   ...
                           'x=a.*sin(b*t+pi/c); y=sin(t);';
   'Maclaurin Trisectrix ' [800 1.8 4.5]  [-.9 1.6]   [-1.5 1.5]  [-5 -3 -1 1 3 5]    0                 0             1             0                   0                   ...
                           'r=sin(3*t)./sin(2*t); w=t+a*pi/60; x=r.*cos(w); y=r.*sin(w);';
   'Rose                 ' [800 0 14*pi]  [-3 3.1]    [-2.1 2]    [2 3 4 1 2 exp(1)]  [1 1 1 3 3 1]     0             1             [-2 0 2 -2 0 2]     [1 1.2 1 -.8 -1 -1] ...
                           'r=sin(a*t/b);; x=r.*cos(t); y=r.*sin(t);';
   'Scarabaeus           ' [800 0 P2]     [-6 12]     [-4 4]      [2 3 1 1]           [3 2 1 3]         [2 2 2 7]     1             [0 6 4 11]          0                   ...
                           'r=a*cos(c*t)-b*cos(t);; x=r.*cos(t); y=r.*sin(t);';
   'Serpentine curve     ' [800 -9 9]     [-9 9]      [-.6 .6]    [1 2 3 4 5 6]       0                 0             1             0                   0                   ...
                           'x=t; y=a*x./(a^2+x.^2);';
   'Spirograph           ' [800 0 P2]     [-3 17]     [-5 9]      [3 10 10 7 14 5]    [1 1 1 2 2 3]     [2 3 4 4 6 6] [6 1 1 1 1 8] [0 6 13 0 6 13]     [6 6 6 0 0 0]       ...
                           'x=b*cos(t)+a*cos(c*t)/10; y=b*sin(t)-a*sin(c*t)/10;';
   'Square wave          ' [400 -2 8]     [-2 8]      [-1.3 6.5]  [6 5 4 3 2 1]       0                 0             1             0                   [0 1 2 3 4 5]       ...
                           'x=t; v=1 : 2 : 2*a-1; y=4./(pi*v)*sin(v''*t);';
   'Strophoid            ' [800 0 P2]     [-7.4 13.4] [-15 15]    [8 9 10 11 12 13]   0                 0             1             0                   0                   ...
                           'r=a*cos(2*t).*sec(t);; x=r.*cos(t); y=r.*sin(t);';
   'Talbot''s curve      ' [800 0 P2]     [-16 110]   [-15 15]    [4 5 6 7 8 9]       13                0             1             [0 23 40 60 80 99]  0                   ...
                           's=sin(t); c=a^2-b^2; x=(a^2+c*s.^2).*cos(t)/a; y=(a^2-2*c+c*s.^2).*s/b;';
   'Teardrop             ' [400 0 P2]     [-1.1 1.1]  [-.9 .9]    [16 11 7 4 2 1]     0                 0             [1 1 1 1 1 8] 0                   0                   ...
                           'x=cos(t); y=sin(t).*sin(t/2).^a;';
   'Witch of Agnesi      ' [800 -4 4]     [-4 4]      [0 5.6]     [3 3.5 4 4.5 5 5.5] 0                 0             1             0                   0                   ...
                           'x=t; y=a./(1+x.^2);'
  };
  close all;
  names = CRq(:,1);
  for k=1:length(names)
    sz = length(CRq{k,qa});
    for m=qb:qYoff % expand shorter vectors to the size of a
      if length(CRq{k,m})<sz CRq{k,m} = zeros(1,sz)+CRq{k,m}; end;
    end;
  end;
  % up to 6 traces
  CRlines = plt(0,0,0,0,0,0,0,0,0,0,0,0,'LabelX','','Position',[10 45 930 680],...
                'FigName','Curves','Options','Ticks','AxisPos',[1,1.45,1,.9]);
  CRb = flipud(get(get(findobj('string','Line 2'),'parent'),'child'));
  ax = get(CRlines(1),'parent'); set(ax,'TickLen',[0 0]);
  xl = get(ax,'Xlabel');
  fontsz = get(xl,'fontsize');  set(xl,'fontsize',1.4*fontsz,'color','white');
  tx = {'Trace' 'a' 'b' 'c' 'Xoffset' 'Yoffset' 't Steps' 't Min' 't Max' 'Style' };
  x = 0;
  for k=1:length(tx)
    set(text(0,0,tx{k}),'units','norm','pos',[x 1.07],'color',[.8 .8 .8],'horiz','center');
    cb = ['curves(' int2str(k) ')'];
    if k==TXsty
         CRi(k) = plt('pop','color',[1 1 .5],'colorBK',[0 .3 .4],'offset',[-.015 -.47],...
         'choices',{' line';' --';' :';' -.';' +';' o';' *';' .';' x';' s';' d';' ^';' v';' >';' <';' p';' h'},...
         'callbk',cb,'horiz','center','location',[x-.012 .943 .042 .5]);
    else CRi(k) = plt('edit','value',1,'color',[1 1 .5],'units','norm','position',[x 1.035],...
                 'callbk',cb,'horiz','center');
    end;
    x = x + .1;
  end;
  plt('edit',CRi(TXtrc),'min',1);
  axes(ax);
  CRa = text(0,0,'\leftarrow right click on curve name');
  set(CRa,'fontsize',1.4*fontsz,'color',[0 1 1],'units','norm','pos',[.35 -.135])
  CRp = plt('pop','choices',CRq(:,1),'callbk','curves(0)','location',[.27 .01 .24 1],...
            'fontsize',2*fontsz,'color',[1 1 .5],'colorBK',[0 .3 .4]);
  bx = get(findobj('string','Line 2'),'parent');
  p = get(bx,'pos'); p(2)=.7;  set(bx,'pos',p);  % move trace labels down
  curves(0);
else
  cs = plt('pop',CRp,'get','index');
  if cs>1 set(CRa,'visible','off'); end;
  tr = plt('edit',CRi(1),'get','value');
  if In<=TXtrc  % here for curve name and trace number callbacks
    if ~In      % if curve callback, reset to trace number 1
      tr = 1;  plt('edit',CRi(1),'value',1,'max',length(CRq{cs,qa}));
      plt('edit',CRi(TXstp),'value',CRq{cs,qT}(1));
      plt('edit',CRi(TXtmn),'value',CRq{cs,qT}(2));
      plt('edit',CRi(TXtmx),'value',CRq{cs,qT}(3));
    end;
    plt('edit',CRi(TXa),  'value',CRq{cs,qa}(tr));
    plt('edit',CRi(TXb),  'value',CRq{cs,qb}(tr));
    plt('edit',CRi(TXc),  'value',CRq{cs,qc}(tr));
    plt('edit',CRi(TXxof),'value',CRq{cs,qXoff}(tr));
    plt('edit',CRi(TXyof),'value',CRq{cs,qYoff}(tr));
    plt('pop',CRi(TXsty),'index',CRq{cs,qSty}(tr));
  else
    if In==TXsty CRq{cs,qSty}(tr) = plt('pop',CRi(In),'get','index');
    else  v = plt('edit',CRi(In),'get','value');
          switch In
            case TXa,   CRq{cs,qa}(tr)    = v;
            case TXb,   CRq{cs,qb}(tr)    = v;
            case TXc,   CRq{cs,qc}(tr)    = v;
            case TXxof, CRq{cs,qXoff}(tr) = v;
            case TXyof, CRq{cs,qYoff}(tr) = v;
            case TXstp, CRq{cs,qT}(1)     = v;
            case TXtmn, CRq{cs,qT}(2)     = v;
            case TXtmx, CRq{cs,qT}(3)     = v;
          end % end switch In
    end;      % if In==TXsty
  end;        % end if In<=TXtrc
  ax = get(CRlines(1),'parent');
  tiny = 1e-32;
  t = CRq{cs,qT};
  step = (t(3)-t(2))/t(1);  t = tiny + t(2):step:t(3);
  set(ax,'xlim',CRq{cs,qXlim},'ylim',CRq{cs,qYlim});
  aa = CRq{cs,qa}; bb = CRq{cs,qb}; cc = CRq{cs,qc};
  Xoff = CRq{cs,qXoff}; Yoff = CRq{cs,qYoff};  Style = CRq{cs,qSty};
  StyCH = plt('pop',CRi(TXsty),'get','choices');
  n = length(aa);
  set(CRlines,'x',0,'y',0);
  func = CRq{cs,qEval};
  f = ['\bf' func];  p = findstr(f,';;');
  if length(p) f = f(1:p(1));  end;
  f1 = {'.'   ';'            '='        '*'         '+'     '-'     '/'  };
  f2 = {''    '       \bf'   ' = \rm'   ' \cdot '   ' + '   ' - '   ' / '};
  for k=1:length(f1) f=strrep(f,f1{k},f2{k}); end;
  set(get(ax,'Xlabel'),'str',f);
  for m = 1:n
    a = aa(m);  b = bb(m);  c = cc(m);  STYix = Style(m);
    if STYix==1  sty = '-'; else  sty = StyCH{STYix}; end;
    if STYix<5 mrk = 'none'; else mrk = sty;  sty = 'none'; end;
    eval(func);
    set(CRlines(m),'x',x+Xoff(m),'y',y+Yoff(m),'Marker',mrk,'LineStyle',sty);
    s = ['trace ' int2str(m)];
    if m==tr & n>1 s = [s '<<']; end;
    set(CRb(m),'string',s);
  end;
  for m = (n+1):6 set(CRb(m),'string',''); end;

  plt('grid',ax);
end; % end if ~nargin
%end function curves
