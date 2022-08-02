function lifex(varargin)
%LIFEX   "Experiments with MATLAB" version of Conway's Game of Life.
%   "Life" is a cellular automaton invented by John Conway that involves
%   life and death in a rectangular, two-dimensional, cellular universe.
%
%   For an introduction see
%       http://en.wikipedia.org/wiki/Conway's_Game_of_Life       
%   This version uses starting populations from the Lexicon maintained
%   by Stephen Silver.  See
%       http://www.argentum.freeserve.co.uk/lex_home.htm 
%   A text copy of the lexicon is in exm/lexicon.txt.
%
%   LIFEX starts with a random population from the lexicon.
%   LIFEX('xyz') starts with the population whose name begins with 'xyz'.
%   LIFEX('all') runs a slide show of all the populations from the lexicon.
%   LIFEX(index) starts with the index-th population from the lexicon.
%   LIFEX(S) ignores the lexicon and starts with the (sparse) matrix S.
%   LIFEX(...,b) includes b border cells around the initial population
%   in the viewing window.  The default is b = 20.
%   Examples:
%      lifex glider
%      lifex(163)
%      S = sparse([1 1 1; 1 0 0; 0 1 0]);
%      lifex(S)
%   all start with a single glider in a 43-by-43 viewing window.

%   "Experiments with MATLAB", Cleve Moler, March 8, 2007.

lex = open_lex('lexicon.txt');
pop = population(lex,varargin{:});

repeat = true;
while repeat

   % Place the initial population in the universe, X.

   [lex,pop] = read_lexicon(lex,pop);
   X = populate(pop);
   
   [plothandle,buttons] = initial_plot(size(X),pop);
   title(pop.name)

   t = 0;
   loop = true;
   while loop

      % Expand the universe if necessary to avoid the boundary.
   
      X = expand(X,pop);

      % Update the plot.

      [i,j] = find(X);
      set(plothandle,'xdata',j,'ydata',i);
      caption(t,nnz(X))
      drawnow
   
      % Whether cells stay alive, die, or generate new cells depends
      % upon how many of their eight possible neighbors are alive.
      % Index vectors increase or decrease the centered index by one.
   
      n = size(X,1);
      p = [1 1:n-1];
      q = [2:n n];
   
      % Count how many of the eight neighbors are alive.
  
      Y = X(:,p) + X(:,q) + X(p,:) + X(q,:) + ...
          X(p,p) + X(q,q) + X(p,q) + X(q,p);
      
      % A live cell with two live neighbors, or any cell with
      % three live neigbhors, is alive at the next step.
   
      X = (X & (Y == 2)) | (Y == 3);

      [loop,buttons] = query_buttons(buttons,pop);
      t = t + 1;

   end

   [repeat,pop] = what_next(buttons,lex,pop);

end
fclose(lex.fid);
set(buttons(1:6),'vis','off')
set(buttons(7),'value',0,'string','close','call','close(gcf)')

% ------------------------

function lex = open_lex(filename)
% lex = file_open(filename)
%    lex.fid = file identifier
%    lex.len = number of entries
%    lex.index = index of current entry

lex.fid = fopen(filename);
if lex.fid < 3
   error(['Cannot open "' filename '"'])
end
% Count number of usable entries,
lex.index = 0;
lex.len = 0;
while ~feof(lex.fid)
   % Look for a line with two colons, ':name:'.
   line = fgetl(lex.fid);
   if sum(line == ':') >= 2
      % name = line(2:find(line(2:end) == ':',1));
      % Look for an empty line or a line starting with a tab.
      tab = char(9);
      task = [tab '*'];
      tdot = [tab '.'];
      while ~feof(lex.fid)
         line = fgetl(lex.fid);
         if isempty(line)
            break
         elseif strncmp(line(1:2),task,2) || strncmp(line(1:2),tdot,2)
            lex.len = lex.len + 1;
            % fprintf('%d: %s\n',lex.len,name)
            break
         end
      end
   end
end
frewind(lex.fid);

% ------------------------

function pop = population(varargin)
% pop = population(varargin)
%    pop.index = index within lexicon of population 
%    pop.name = name of population
%    pop.all = logical flag for slide show of populations
%    pop.b = border width, default = 20
%    pop.S = sparse matrix representation of population

lex = varargin{1};
pop.index = 0;
pop.name = ' ';
pop.all = false;
pop.b = 20;
pop.S = [];
if nargin < 2
   pop.index = ceil(rand*lex.len);
elseif ischar(varargin{2}) && isequal(varargin{2},'all')
   pop.all = true;
   pop.b = 10;
elseif ischar(varargin{2})
   pop.name = varargin{2};
   pop.index = -1;
elseif min(size(varargin{2})) > 1
   pop.S = sparse(varargin{2});
   pop.name = sprintf('my %d-by-%d matrix',size(pop.S));
else
   pop.index = varargin{2};
end
if nargin == 3
   pop.b = varargin{3};
end

% ------------------------

function [lex,pop] = read_lexicon(lex,pop)
% [lex,pop] = read_lexicon(lex,pop)
%    Update lex and pop to new population

if pop.all || pop.index > lex.len
   pop.index = mod(pop.index,lex.len)+1;
end
if pop.index < lex.index
   frewind(lex.fid)
   lex.index = 0;
end
while lex.index ~= pop.index
   % Look for a line with two colons, ':name:'.
   line = fgetl(lex.fid);
   if sum(line == ':') >= 2
      name = line(2:find(line(2:end) == ':',1));
      % Look for an empty line or a line starting with a tab.
      tab = char(9);
      task = [tab '*'];
      tdot = [tab '.'];
      while ~feof(lex.fid) && lex.index <= lex.len
         line = fgetl(lex.fid);
         if isempty(line)
            break
         elseif strncmp(line(1:2),task,2) || strncmp(line(1:2),tdot,2)
            lex.index = lex.index + 1;
            if lex.index == pop.index || ...
                  strncmpi(name,pop.name,length(pop.name))
               pop.index = lex.index;
               if pop.all
                  pop.name = [name ',  index = ' int2str(pop.index)];
               else
                  pop.name = name;
               end
               % Form sparse matrix by rows from '.' and '*'.
               S = sparse(0,0);
               m = 0;
               while ~isempty(line) && (line(1)==tab)
                  row = sparse(line(2:end) == '*');
                  m = m+1;
                  n = length(row);
                  S(m,n) = 0;
                  S(m,1:n) = row;
                  line = fgetl(lex.fid);
               end
               pop.S = S;
            elseif lex.index == lex.len
               error('Population name is not in lexicon.')
            end
            break
         end
      end
   end
end

% ------------------------

function [plothandle,buttons] = initial_plot(sizex,pop)
% [plothandle,buttons] = initial_plot(size(X),pop)
%    plothandle = handle to customized "spy" plot
%    buttons = array of handles to toggle buttons

clf
shg
m = max(sizex);
ms = max(10-ceil(m/10),2);
plothandle = plot(0,0,'o','markersize',ms,'markerfacecolor','blue');
set(gca,'xlim',[0.5 m+0.5],'ylim',[0.5 m+0.5],'ydir','rev', ...
   'xtick',[],'ytick',[],'plotboxaspectratio',[m+2 m+2 1])
buttons = zeros(7,1);
bstrings = {'step','slow','fast','redo','next','random','quit'};
for k = 1:7
   buttons(k) = uicontrol('style','toggle','units','normal', ...
   'position',[.10+.12*(k-1) .005 .10 .045],'string',bstrings{k});
end
set(buttons(1),'userdata',0);
if pop.all, set(buttons(1:6),'vis','off'), end

% ------------------------

function X = populate(pop)
% X = populate(pop);
%    X = sparse matrix universe with centered initial population

[p,q] = size(pop.S);
n = max(p,q) + 2*pop.b;
X = sparse(n,n);
i = floor((n-p)/2)+(1:p);
j = floor((n-q)/2)+(1:q);
X(i,j) = pop.S;

% ------------------------

function X = expand(X,pop)
% X = expand(X);
% Expand size if necessary to keep zeros around the boundary. 
% Border width b avoids doing this every time step.
n = size(X,1);
b = max(pop.b,1);
if any(X(:,n-1) ~= 0) || any(X(n-1,:) ~= 0)
   X = [X sparse(n,b); sparse(b,n+b)];
   n = n + b;
end
if any(X(2,:) ~= 0) || any(X(:,2) ~= 0)
   X = [sparse(b,n+b); sparse(n,b) X];
   xlim = get(gca,'xlim')+b;
   ylim = get(gca,'ylim')+b;
   set(gca,'xlim',xlim,'ylim',ylim)
end

% ------------------------

function [loop,buttons] = query_buttons(buttons,pop)
% [loop,buttons] = query_buttons(buttons);
%    loop = true: continue time stepping
%    loop = false: restart

if pop.all
   pause(1)
   loop = false;
else
   bv = cell2mat(get(buttons,'value'));
   bk = get(buttons(1),'userdata');
   if bk == 0 || sum(bv==1) ~= 1
      while all(bv == 0)
         drawnow
         bv = cell2mat(get(buttons,'value'));
      end
      if sum(bv==1) > 1
         bv(bk) = 0;
      end
      bk = find(bv == 1);
   end
   set(buttons([1:bk-1 bk+1:7]),'value',0)
   switch bk
      case 1  % step
         set(buttons(1),'value',0);
         bk = 0;
         loop = true;
      case 2  % slow
         pause(.5)
         loop = true;
      case 3  % fast
         pause(.05)
         loop = true;
      otherwise, loop = false;
   end
   % Remember button number
   set(buttons(1),'userdata',bk);
end

% ------------------------

function [repeat,pop] = what_next(buttons,lex,pop)
% [next,pop] = what_next(buttons,lex,pop);
%    repeat = true: start with a new population
%    repeat = false: exit

bv = cell2mat(get(buttons,'value'));
bk = find(bv == 1);
set(buttons,'value',0)
repeat = true;
if ~isempty(bk)
   switch bk
      case 4  % redo
         pop.index = lex.index;
      case 5  % next
         pop.index = mod(lex.index,lex.len)+1;
      case 6  % random
         pop.index = ceil(rand*lex.len);
      case 7  % quit
         repeat = false;
   end
end

% ------------------------

function caption(t,nnz)
% caption(t,nnz(X))
% Print time step count and population size on the x-label.
s = sprintf('t=%3d, pop=%3d',t,nnz);
fs = get(0,'defaulttextfontsize')+2;
xlabel(s,'fontname','courier','fontsize',fs);
