function [X,steps] = sudoku_basic(X,steps)
% SUDOKU_BASIC  Solve a Sudoku puzzle using recursive backtracking.
%   sudoku_basic(X), for a 9-by-9 array X, solves the Sudoku puzzle for X
%   without providing the graphics user interface from sudoku.m
%   [X,steps] = sudoku_basic(X) also returns the number of steps.
%   See also sudoku, sudoku_all, sudoku_assist, sudoku_puzzle.

   if nargin < 2
      steps = 0;        % Recursive calls will have a second argument.
   end

   % Fill in all "singletons", the cells with only one candidate.
   % C is the array of candidates for each cell.
   % N is the vector of the number of candidates for each cell.
   % s is the index of the first cell with the fewest candidates.

   [C,N] = candidates(X);
   while all(N>0) & any(N==1)
      s = find(N==1,1);
      X(s) = C{s};
      steps = steps + 1;
      [C,N] = candidates(X);
   end
   
   % Recursive backtracking.

   if all(N>0)
      Y = X;
      s = find(N==min(N),1);
      for t = [C{s}]                          % Iterate over the candidates.
         X = Y;
         X(s) = t;                            % Insert a tentative value.
         steps = steps + 1;

         [X,steps] = sudoku_basic(X,steps);   % Recursive call.

         if all(X(:) > 0)                     % Found a solution.
            break
         end
      end
   end

% ------------------------------

   function [C,N] = candidates(X)
      % C = candidates(X) is a 9-by-9 cell array of vectors.
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

end % sudoku_basic
