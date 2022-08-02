function sudoku_assist(X)
% SUDOKU_ASSIST  Assist a humam Sudoku puzzle solver
% SUDOKU_ASSIST(X), for a 9-by-9 array, lets you manipulate the Sudoku puzzle.
% SUDOKU_ASSIST, with no arguments, uses X = sudoku_puzzle(1).
% See also sudoku, sudoku_all, sudoku_basic, sudoku_puzzle.

   if nargin == 0
      X = sudoku_puzzle(1);
   end
   H = gui_init(X);
   C = candidates(X);
   sudoku_gui(X,H,C);
   set(gcf,'windowbuttonup',@do)
   uicontrol('style','push','units','normal','position',[.85 .55 .12 .05], ...
      'string','undo','background','white','callback',@undo)
   silent = uicontrol('style','toggle','units','normal', ...
      'position',[.85 .45 .12 .05],'background','white','string','silent');
   stack = [];

% ------------------------------

   function C = candidates(X)
      % C is the array of candidates for each cell.
      % C{i,j} is the vector of allowable values for X(i,j).
      tri = @(k) 3*ceil(k/3-1) + (1:3);
      C = cell(9,9);
      for j = 1:9
         for i = 1:9
            if X(i,j)==0
               z = 1:9;
               z(nonzeros(X(i,:))) = 0;
               z(nonzeros(X(:,j))) = 0;
               z(nonzeros(X(tri(i),tri(j)))) = 0;
               C{i,j} = nonzeros(z)';
            end
         end
      end
   end % candidates

% ------------------------------

   function H = gui_init(X)

      % Initialize gui

      dkblue = [0 0 2/3];
      dkgreen = [0 1/2 0];
      dkmagenta = [1/3 0 1/3];
      grey = [1/2 1/2 1/2];
      fsize = get(0,'defaulttextfontsize');
      fname = 'Lucida Sans Typewriter';
      close
      bigscreen
      shg
      set(gcf,'color','white')
      axis square
      axis off
      
      for m = [2 3 5 6 8 9]
         line([m m]/11,[1 10]/11,'color',grey)
         line([1 10]/11,[m m]/11,'color',grey)
      end
      for m = [1 4 7 10]
         line([m m]/11,[1 10]/11,'color',dkmagenta,'linewidth',4)
         line([1 10]/11,[m m]/11,'color',dkmagenta,'linewidth',4)
      end
   
      H.a = zeros(9,9);
      for j = 1:9
         for i = 1:9
            if X(i,j) > 0
               string = int2str(X(i,j));
               color = dkblue;
            else
               string = ' ';
               color = dkgreen;
            end
            H.a(i,j) = text((j+1/2)/11,(10.5-i)/11,string, ...
              'units','normal','fontsize',fsize+6,'fontweight','bold', ...
              'fontname',fname,'color',color,'horizont','center');
         end
      end
      drawnow

   end % gui_init

% ------------------------------

   function sudoku_gui(X,H,C)

      dkblue = [0 0 2/3];
      dkred = [2/3 0 0];
      dkgreen = [0 1/2 0];
      cyan = [0 2/3 2/3];
      fsize = get(0,'defaulttextfontsize');

      % Update entire array, except for initial entries.

      for j = 1:9
         for i = 1:9
            if ~isequal(get(H.a(i,j),'color'),dkblue)
               if X(i,j) > 0
                  set(H.a(i,j),'string',int2str(X(i,j)),'fontsize',fsize+6)
                  if get(H.a(i,j),'color') ~= cyan 
                     set(H.a(i,j),'color',dkgreen)
                  end
               elseif length(C{i,j}) == 1
                  set(H.a(i,j),'string',char3x3(C{i,j}),'fontsize',fsize-4, ...
                     'color',dkred)
               else
                  set(H.a(i,j),'string',char3x3(C{i,j}),'fontsize',fsize-4, ...
                     'color',dkgreen)
               end
            end
         end
      end

      nz = nnz(X);
      if nz < 81
         title(['nnz = ' int2str(nz)])
      else
         title(['nnz = 81. Congratulations!'])
      end

   end % sudoku_gui
   
% ------------------------------
   
   function s = char3x3(c)
      % 3-by-3 character array of candidates.
      b = blanks(5);
      s = {b; b; b};
      for k = 1:length(c)
         d = c(k);
         p = ceil(d/3);
         q = 2*mod(d-1,3)+1;
         s{p}(q) = int2str(d);
      end
   end % char3x3

% ------------------------------

   function do(varargin)
      xy = get(gca,'currentpoint');
      xy = xy(1,1:2);
      if doer(xy)
         stack = [xy; stack];
      end
   end % do

% ------------------------------

   function undo(varargin)
      if ~isempty(stack)
        xy = stack(1,:);
        doer(xy);
        stack(1,:) = [];
      end 
   end % undo

% ------------------------------

   function did = doer(xy)

      dkblue = [0 0 2/3];
      dkred = [2/3 0 0];
      dkgreen = [0 1/2 0];
      cyan = [0 2/3 2/3];

      x = xy(1);
      y = 1-xy(2);
      i = floor(11*y);
      j = floor(11*x);
      if i >= 1 & i <= 9 & j >= 1 & j <= 9
         if get(H.a(i,j),'color') == dkblue
            % Original clue, do nothing
            did = false;
         elseif X(i,j) ~= 0
            % Undo a previous click
            X(i,j) = 0;
            did = true;
         elseif length(C{i,j}) == 1
            % Singleton
            X(i,j) = C{i,j};
            did = true;
         else
            % Click candidate?
            p = 3*mod(floor(33*y),3) + mod(floor(33*x),3) + 1;
            did = any(p == C{i,j});
            if did
               % Insert a guess
               set(H.a(i,j),'color',cyan)
               X(i,j) = p;
            end
         end
         if did
            C = candidates(X);
            sudoku_gui(X,H,C);
            N = cellfun(@length,C);
            if any(any(X==0 & N==0))
               % At least one cell has no candidates.
               % Impossible configuration.
               k = find(X==0 & N==0);
               set(H.a(k),'color','k','string','X','fontsize',24)
               if get(silent,'value')==0
                  scream
               end
            end
         end
      end

   end % doer

end % sudoku_assist
