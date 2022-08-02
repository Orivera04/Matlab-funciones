function [X,steps] = sudoku(X,steps)
% SUDOKU  Solve a Sudoku puzzle using recursive backtracking.
%   sudoku(X), for a 9-by-9 array X, solves the Sudoku puzzle for X.
%   [X,steps] = sudoku(X) also returns the number of steps.
%   See also sudoku_all, sudoku_assist, sudoku_basic, sudoku_puzzle. 

   if nargin < 1
      X = sudoku_puzzle(1);
   end
   if nargin < 2
      steps = 0;
      gui_init(X);
   end
   sudoku_gui(X,steps);

   % Fill in all "singletons", the cells with only one candidate.
   % C is the array of candidates for each cell.
   % N is the vector of the number of candidates for each cell.
   % s is the index of the first cell with the fewest candidates.

   [C,N] = candidates(X);
   while all(N>0) & any(N==1)
      sudoku_gui(X,steps,C);
      s = find(N==1,1);
      X(s) = C{s};
      steps = steps + 1;
      sudoku_gui(X,steps,C);
      [C,N] = candidates(X);
   end
   sudoku_gui(X,steps,C);
   
   % Recursive backtracking.

   if all(N>0)
      Y = X;
      s = find(N==min(N),1);
      for t = [C{s}]                        % Iterate over the candidates.
         X = Y;
         sudoku_gui(X,steps,C);
         X(s) = t;                          % Insert a tentative value.
         steps = steps + 1;
         sudoku_gui(X,steps,C,s);           % Color the tentative value.

         [X,steps] = sudoku(X,steps);       % Recursive call.

         if all(X(:) > 0)                   % Found a solution.
            break
         end
         sudoku_gui(X,steps,C,-s);          % Revert color of tentative value.
      end
   end
   if nargin < 2
      gui_finish(X,steps);
   end

% ------------------------------

   function [C,N] = candidates(X)
      % C = candidates(X) is a 9-by-9 cell array of vectors
      % C{i,j} is the vector of allowable values for X(i,j).
      % N is a row vector of the number of candidates for each cell.
      % N(k) = Inf for cells that already have values.
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
      N = cellfun(@length,C);
      N(X>0) = Inf;
      N = N(:)';
   end % candidates

% ------------------------------

   function gui_init(X)

      % Initialize gui
      % H is the structure of handles, saved in figure userdata.

      dkblue = [0 0 2/3];
      dkgreen = [0 1/2 0];
      dkmagenta = [1/3 0 1/3];
      grey = [1/2 1/2 1/2];
      fsize = get(0,'defaulttextfontsize');
      fname = 'Lucida Sans Typewriter';
      clf
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
      strings = {'step','slow','fast','finish'};
      H.b = zeros(1,4);
      for k = 1:4
         H.b(k) = uicontrol('style','toggle','string',strings{k}, ...
            'units','normal','position',[(k+3)*0.125,0.05,0.10,0.05], ...
            'background','white','value',0, ...
            'callback', ...
            'H=get(gcf,''user''); H.s=find(H.b==gco); set(gcf,''user'',H)');
      end
      set(H.b(1),'style','pushbutton')
      H.s = 1;
      H.t = title('0','fontweight','bold');
      set(gcf,'userdata',H)
      drawnow

   end % gui_init

% ------------------------------

   function sudoku_gui(X,steps,C,z)

      H = get(gcf,'userdata');
      if H.s == 4
         if mod(steps,50) == 0
            set(H.t,'string',int2str(steps))
            drawnow
         end
         return
      else
         set(H.t,'string',int2str(steps))
      end
      k = [1:H.s-1 H.s+1:4];
      set(H.b(k),'value',0);
      dkblue = [0 0 2/3];
      dkred = [2/3 0 0];
      dkgreen = [0 1/2 0];
      cyan = [0 2/3 2/3];
      fsize = get(0,'defaulttextfontsize');

      % Update entire array, except for initial entries.

      for j = 1:9
         for i = 1:9
            if ~isequal(get(H.a(i,j),'color'),dkblue) && ...
               ~isequal(get(H.a(i,j),'color'),cyan)
               if X(i,j) > 0
                  set(H.a(i,j),'string',int2str(X(i,j)),'fontsize',fsize+6, ...
                     'color',dkgreen)
               elseif nargin < 3
                  set(H.a(i,j),'string',' ')
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
      if nargin == 4
         if z > 0
            set(H.a(z),'color',cyan)
         else
            set(H.a(-z),'color',dkgreen)
            return
         end
      end

      % Gui action = single step, brief pause, or no pause

      switch H.s
         case 1
            H.s = 0;
            set(gcf,'userdata',H);
            while H.s == 0;
               drawnow
               H = get(gcf,'userdata');
            end
         case 2
            pause(0.5)
         case 3
            drawnow
      end
      if nargin == 4
         if z > 0
            set(H.a(z),'color',cyan)
         else
            set(H.a(-z),'color',dkgreen)
            return
         end
      end

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
      end

   end % gui

% ------------------------------

   function gui_finish(X,steps)
 
      H = get(gcf,'userdata');
      H.s = 2;
      set(H.b(1:3),'vis','off')
      set(gcf,'userdata',H)
      set(H.b(4),'string','close','value',0, ...
         'callback','close(gcf)')
      sudoku_gui(X,steps)
    
   end % gui_finish

end % sudoku
