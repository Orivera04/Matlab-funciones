function morse_gui(arg)
% MORSE_GUI  Interactive demonstration of Morse code and binary trees.

   if nargin == 0
      init_gui
   elseif isequal(arg,'_depth')
      depth
   elseif isequal(arg,'_breadth') 
      breadth
   else
      translate
   end

   % ------------------------------------
   
   function depth
      % Depth first traversal of Morse code binary tree
      % Stack, LIFO, last in first out.
      % Insert new items at the top of the stack.
      S = {morse_tree};
      X = 0;
      Y = 0;
      while ~isempty(S)
         N = S{1};
         S = S(2:end);
         x = X(1);
         X = X(2:end);
         y = Y(1);
         Y = Y(2:end);
         if ~isempty(N)
            node(N{1},x,y)
            S = {N{2} N{3} S{:}};
            X = [2*x-(x>=0); 2*x+(x<=0); X];
            Y = [y+1; y+1; Y];
         end
      end
   end % depth

   % ------------------------------------
   
   function breadth
      % Breadth first traversal of Morse code binary tree.
      % Queue, FIFO, first in first out.
      % Insert new items at the end of the queue.
      Q = {morse_tree};
      X = 0;
      Y = 0;
      while ~isempty(Q)
         N = Q{1};
         Q = Q(2:end);
         x = X(1);
         X = X(2:end);
         y = Y(1);
         Y = Y(2:end);
         if ~isempty(N)
            node(N{1},x,y);
            Q = {Q{:} N{2} N{3}};
            X = [X; 2*x-(x>=0); 2*x+(x<=0)];
            Y = [Y; y+1; y+1];
         end
      end
   end % breadth

   % ------------------------------------
   
   function translate
      % Translate to and from Morse code.
      e = findobj('style','edit');
      s = findobj('string','sound');
      t = get(e,'string');
      if all(t=='.' | t=='-' | t==' ' | t=='*')
         t = decode(t);
         set(e,'string',t);
      else
         code = encode(t);
         set(e,'string',code);
         if get(s,'value') == 1
            morse_sound(code)
         end
      end
      if length(t)>=3 && isequal(t(1:3),'SOS')
         scream
      end
   end

   % ------------------------------------

   function code = encode(text)
      % ENCODE  Translate text to dots and dashes.
      % encode('text')
   
      code = '';
      text = upper(text);
      for k = 1:length(text);
         ch = text(k);
         % A blank in the text is worth three in the code.
         if ch == ' '
            code = [code '   '];
         else
            code = [code encode_ch(ch) ' '];
         end
      end
   
   end % encode

   % ------------------------------------

   function dd = encode_ch(ch)
      % ENCODE_CH  Translate one character to dots and dashes.
   
      S = {morse_tree};
      D = {''};
      while ~isempty(S)
         N = S{1};
         dd = D{1};
         S = S(2:end);
         D = D(2:end);
         if ~isempty(N)
            if N{1} == ch;
               return
            else
               S = {N{2} N{3} S{:}};
               D = {[dd '.'] [dd '-'] D{:}};
            end
         end
      end
      dd = '*';
   
   end % encode_ch

   % ------------------------------------

   function text = decode(code)
      % DECODE  Translate strings of dots and dashes to text.
      % decode('string of dots, dashes and spaces')
   
      text = [];
      code = [code ' '];
      while ~isempty(code);
         k = find(code == ' ',1);
         ch = decode_dd(code(1:k));
         text = [text ch];
         code(1:k) = [];
         % Many blanks in the code is worth one in the text.
         if ~isempty(code) && code(1) == ' '
            text = [text ' '];
            while ~isempty(code) && code(1) == ' '
               code(1) = [];
            end
         end
      end
   
   end % decode

   % ------------------------------------

   function ch = decode_dd(dd)
      % DECODE_DD  Translate one character's worth of dots
      % and dashes to a single character of text.

      M = morse_tree;
      for k = 1:length(dd)
         if dd(k) == '.'
            M = M{2};
         elseif dd(k) == '-'
            M = M{3};
         end
         if isempty(M)
            ch = '*';
            return
         end
      end
      ch = M{1};
   
   end % decode_dd

   % ------------------------------------

   function init_gui
      % Initialize Morse code gui.
      global extend
      extend = 0;
      clf reset
      axes('pos',[0 0 1 1])
      axis(16*[-1 1 0 2])
      axis square off
      set(gcf,'color','white')
      set(gca,'ydir','rev')
      uicontrol('style','push','string','depth', ...
         'units','normal','pos',[0.16 0.20 0.12 0.06], ...
         'callback','cla, morse_gui(''_depth'')')
      uicontrol('style','push','string','breadth', ...
         'units','normal','pos',[0.35 0.20 0.12 0.06], ...
         'callback','cla, morse_gui(''_breadth'')')
      uicontrol('style','toggle','string','sound','value',1, ...
         'units','normal','pos',[0.54 0.20 0.12 0.06]);
      uicontrol('style','toggle','string','extend','value',0, ...
         'units','normal','pos',[0.72 0.20 0.12 0.06], ...
         'callback', ['global extend, extend=get(gcbo,''value'');' ...
         'if extend==0, cla, end, axis(2^(4+extend)*[-1 1 0 2])']);
      uicontrol('style','edit','string', ...
         'Enter text or code to translate', ...
         'units','normal','pos',[0.16 0.04 0.68 0.08], ...
         'callback','cla, morse_gui(''_translate'')')
   end

   % ------------------------------------

   function node(ch,x,y)
      % Plot, and possibly play, node of Morse code binary tree.
      global extend
      r = 0.90;
      z = r*exp(2*pi*i*(0:32)/32);
      delta = 1/3;
      dkgreen = [0 1/2 0];
      lw = get(0,'defaultlinelinewidth')+0.5;
      fs = get(0,'defaulttextfontsize');
      if ~extend
         lw = lw+1;
         fs = fs+2;
      end
      p = 2^(4+extend-y);
      u = (x~=0)*(2*x+2*(x<=0)-1)*p;
      v = 4*(y+1);
      % Circle
      line(u+real(z),v+imag(z),'color','black','linewidth',lw)
      % Character
      text(u-delta,v,ch,'fontweight','bold','color',dkgreen,'fontsize',fs);
      % Connect node to parent
      if (x~=0)
         if y==1
            w = 0;
         elseif rem(x,2)==(x>0)
            w = u+p;
         else
            w = u-p;
         end
         line([u w],[v-r v+r-4],'color','black','linewidth',lw)
      end
      if get(findobj('string','sound'),'value') == 1
         morse_sound(encode_ch(ch))
         pause(0.2)
      end
      pause(0.1)
   end

   % ------------------------------------

   function morse_sound(code,delta,note)
      % MORSE_SOUND  Play sound for dots and dashes.
      % morse_sound(code) plays code, a string of dots, dashes and spaces.
      % morse_sound(code,delta,note) time slice is delta and tone is note.
      % Default delta = 1/16 second.
      % Default note = 6, which is F above middle C.  See play_note.
      
      if nargin < 2
         delta = 1/16;
      end
      if nargin < 3
         note = 6;
      end
      s = findobj('string','sound');
      for k = 1:length(code)
         if get(s,'value') == 1
            switch code(k)
               case '.'
                  play_note(note,delta)
               case '-'
                  play_note(note,3*delta)
               case ' '
                  pause(3*delta)
               otherwise
                  % Skip the character
            end
            pause(delta)
         end
      end
   end  % morse_sound

   % ------------------------------------

   function play_note(note,T)
      % PLAY_NOTE  Play a musical note.
      % play_note(note,T)  Play a note for T seconds.
      % note is an integer specifying semitones above and below middle C.
      % There are 12 notes per octave.
      % play_note(0,1/2) plays middle C (~261.625 Hz) for 1/2 second.
   
      C4 = 440/2^(3/4);             % Middle C, hertz
      Fs = 44100;                   % Sample rate, hertz
      t = (0:1/Fs:T);               % Linear time ramp
      f = C4 * 2^(note/12);         % Frequency, hertz
      y = sin(2*pi*f*t);            % Sinusoidal signal
      k = 1:1000;                   % Attack and release
      r = (k/1000);
      y(k) = r.*y(k);
      y(end+1-k) = r.*y(end+1-k);
      sound(y,Fs)                   % Play
   end  % play_note

end % morse_gui
