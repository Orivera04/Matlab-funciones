function pianoex(a)
% PIANOEX  A simple music synthesizer.
%   pianoex, with no arguments, presents a gui with 25 piano keys,
%   13 toggles to form chords, 3 toggles to choose intonation, and
%   an oscilloscope and staff to display the generated notes and chords.
%
%   pianoex(n) plays the n-th note above middle C.
%   pianoex(-n) plays the n-th note below middle C.
%   pianoex([n1 n2 ... ]) plays the chord specified by a vector.
%
%   pianoex(score) plays the cell array score constructed like
%   the one in vivaldi.m. 
%
%   for n = [0 2 4 5 7 9 11 12]
%      pianoex(n)
%   end
%   plays the C-major scale.
%
%   Requires sound card and, optionally, the Signal Processing Toolbox.

   if isempty(get(gca,'userdata'))
      make_keyboard
   end
   if nargin > 0
      T = 5/8;
      H = get(gca,'userdata');
      tv = get(H.voice,'value');
      voice = find([tv{:}]==1);
      set(H.togs(1),'value',1,'background','blue')
      for k = 1:size(a,1)
         if iscell(a)
            if size(a(k,:),2)==2
               [y,fs] = synthesize(a{k,1},a{k,2}*T,voice);
            else
               [y,fs] = synthesize(a{k,1},T,voice);
            end
            v = a{k,1};
         else
            if isscalar(a)
               H.root = a;
               ch = get(H.togs,'value');
               a = a + find([ch{:}]) - 1;
            end
            [y,fs] = synthesize(a,T,voice);
            v = a;
         end
         sound(y,fs);
         for j = 1:25
            set(H.keys(j),'background',get(H.keys(j),'userdata'))
         end
         set(H.keys(v(v<13)+13),'background','blue')
         j = round(get(H.scope,'xdata')*fs);
         set(H.scope,'ydata',y(j))
         set(H.notes,'vis','off')
         set(H.sharps,'vis','off')
         delta = [0 0 1 1 2 3 3 4 4 5 5 6]/2;
         for n = 1:length(v)
            y = 3.5*floor(v(n)/12)+delta(mod(v(n),12)+1);
            set(H.notes(n),'ydata',y,'vis','on')
            if any(mod(v(n),12) == [1 3 6 8 10])
               set(H.sharps(n),'pos',[.25 y],'vis','on');
            end
         end
         drawnow
      end
      set(gca,'userdata',H);
   end
end

% ------------------------------------

function [y,fs] = synthesize(chord,T,voice)
% SYNTHESIZE  Generate musical notes and cords.
% synthesize(note,T,voice)  Generates a note for T seconds with given tuning.
% synthesize([note1, ..., noten],T,voice)  Generates a chord of several notes.
% Notes are integers specifying half tones above and below middle C.
% voice = 1 for piano, 2 for just intonation, 3 for equal temperament.

% Examples:
%   synthesize(0) generatees middle C (261.625 Hz) for 1/2 second.
%   synthesize(1) is C#.
%   synthesize(-1) is C-flat.
%   synthesize(12) is high C, one octave above middle C.
%   synthesize([0 4 7]) is the perfect fifth major triad C-E-G. 
%   A scale with one second per note:
%      for k = [0 2 4 5 7 9 11 12]
%         synthesize(k,1)
%      end

   switch voice

      case 1  % equal temperament

         sigma = 2^(1/12);
         C4 = 440*sigma^(-9);
         fs = 44100;
         t = 0:1/fs:T;
         y = zeros(size(t));
         for n = chord
            hz = C4 * sigma^n;
            y = y + sin(2*pi*hz*t);
         end
         y = y/length(chord);

      case 2  % just intonation

         sigma = 2^(1/12);
         C4 = 440*sigma^(-9);
         fs = 44100;
         t = 0:1/fs:T;
         r = [1 16/15 9/8 6/5 5/4 4/3 7/5 3/2 8/5 5/3 7/4 15/8];
         r = [r/2 r 2*r 4];
         y = zeros(size(t));
         for n = chord
            hz = C4 * r(n+13);
            y = y + sin(2*pi*hz*t);
         end
         y = y/length(chord);

      case 3  % piano

         middle_c = get(gcf,'userdata');
         fs = 44100;
         t = 0:1/fs:T;
         y = zeros(size(t));
         for n = chord
            y = y + resamplex(middle_c,2^(n/12),length(y));
         end
   end
end

% ------------------------------------

function y = resamplex(y,factor,L)
% RESAMPLE 
% Requires Signal Processing Toolbox

   [p,q] = rat(factor,1.e-4);
   y = resample(y,q,p)';
   L = floor(L);
   if L < length(y)
      y = y(1:L);
   else
      y(L) = 0;
   end
   r = 150:-1:0;
   y(L-r:L) = y(L-r:L).*r/150;
end

% ------------------------------------

function make_keyboard
% MAKE_KEYBOARD Create a piano keyboard.

   clf
   white = [-12:2:-8 -7:2:-1 0:2:4 5:2:11 12];
   black = setdiff(-11:11,white);
   dx = 1/16;
   H.keys = zeros(1,25);
   for k = [white black]
      if k == -12
         % White
         bw = [1 1 1];
         x = dx/2;
         y = .08;
         dy = .40;
      elseif k == -11
         % Black
         bw = [0 0 0];
         x = dx;
         y = .23;
         dy = .25;
      end
      callback = ['pianoex(' int2str(k) '), set(gcbo,''value'',0)'];
      H.keys(k+13) = uicontrol('units','normal','position',[x y dx dy], ...
         'style','toggle','background',bw,'userdata',bw,'callback',callback);
      x = x + dx;
      if k == -9 || k == -2 || k == 3
         x = x + dx;
      end
   end

   % Key Labels

   y = .02;
   dy = .05;
   s = 'C';
   grayc = get(gcf,'color');
   for x = dx/2:dx:1-dx
      uicontrol('units','normal','position',[x y dx dy],'background',grayc, ...
         'style','text','string',s,'fontsize',14,'fontweight','bold')
      s = char(s+1);
      if s > 'G', s = 'A'; end
   end

   % Clefs

   axes('position',[.03 .65 .07 .3])
   C = load('clefs.mat');
   image(C.clefs_pic)
   colormap(gray)
   axis off

   % Staff

   axes('position',[.1 .65 .1 .3],'xticklabel','','yticklabel','', ...
        'xlim',[0 1],'ylim',[-7 7]);
   box on
   for y = [-5:-1 1:5]
      line([0 1],[y y],'color','black')
   end
   line([.33 .67],[0 0],'color','black')

   % Notes

   H.notes = zeros(13,1);
   H.sharps = zeros(13,1);
   for n = 1:13
      H.notes(n) = line(.5,0,'marker','.','markersize',24,'vis','off');
      H.sharps(n) = text(.375,0,'#','fontsize',12,'color','blue','vis','off');
   end

   % Chord toggles

   H.togs = zeros(1,13);
   callback = ['if get(gcbo,''value'')==0,' ...
               'set(gcbo,''background'',[.94 .94 .94]),' ...
               'else, set(gcbo,''background'',''blue''), end,' ...
               'H=get(gca,''userdata''); pianoex(H.root)'];
   for k = 0:12
      H.togs(k+1) = uicontrol('style','toggle','units','normal', ...
         'pos',[.05+k*.05 .54 .04 .04],'value',k==0,'background',grayc, ...
         'callback',callback);
      uicontrol('style','text','units','normal','string',num2str(k), ...
         'fontsize',12,'fontweight','bold','pos',[.04+k*.05 .49 .05 .05], ...
         'background',grayc)
   end
   set(H.togs(1),'value',1,'background','blue')

   % Tuning

   H.voice = zeros(1,3);
   voicestring = {'equal','just','piano'};
   callback = ['H=get(gca,''userdata'');' ...
         'set(H.voice,''background'',[.94 .94 .94],''value'',0),' ...
         'set(gcbo,''background'',''blue'',''value'',1),' ...
         'pianoex(H.root)'];
   % Do not show piano if Signal Processing Toolbox is not available.
   kmax = 2 + (exist('resample','file')==2);
   for k = 1:kmax
      H.voice(k) = uicontrol('style','toggle','units','normal', ...
         'pos',[1.00-k*.08 .54 .04 .04],'value',0,'background',grayc, ...
         'callback',callback);
      uicontrol('style','text','units','normal','string',voicestring{k}, ...
         'fontsize',12,'fontweight','bold', ...
         'pos',[.98-k*.08 .49 .08 .05],'background',grayc)
   end
   set(H.voice(1),'value',1,'background','blue');

   % Scope

   tmin = .06;
   tmax = .12;
   s = tmin:4/44100:tmax;
   axes('position',[.30 .65 .65 .30],'xlim',[tmin tmax],'ylim',[-1 1])
   H.scope = line(s,0*s);
   box on
   set(zoom,'motion','horizontal','direction','in','enable','on')

   % Piano sample

   S = load('piano_c.mat');
   middle_c = double(S.piano_c)/2^15;

   H.root = 0;
   set(gca,'userdata',H)
   set(gcf,'userdata',middle_c)
   shg
end
