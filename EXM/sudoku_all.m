function L = sudoku_all(X,L)
% SUDOKU_ALL  Enumerate all solutions to a Sudoku puzzle.
%   L = sudoku_all(X), for a 9-by-9 array X, is a list of all solutions.
%   L{k} is the k-th solution.
%   L{:} will print all the solutions.
%   length(L) is the number of solutions.  A valid puzzle must have only one.
%   See also sudoku, sudoku_basic, sudoku_puzzle, sudoku_assist.

   if nargin < 2
      % Initialize the list on first entry.
      L = {};
   end

   % Fill in all "singletons", the cells with only one candidate.
   % C is the array of candidates for each cell.
   % N is the vector of the number of candidates for each cell.
   % s is the index of the first cell with the fewest candidates.

   [C,N] = candidates(X);
   while all(N>0) & any(N==1)
      s = find(N==1,1);
      X(s) = C{s};
      [C,N] = candidates(X);
   end

   % Add a solution to the list.

   if all(X(:)>0)
      L{end+1} = X;
   end
   
   % Enumerate all possible solutions.

   if all(N>0)
      Y = X;
      s = find(N==min(N),1);
      for t = [C{s}]                    % Iterate over the candidates.
         X = Y;
         X(s) = t;                      % Insert a value.
         L = sudoku_all(X,L);           % Recursive call.
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
end % sudoku_all
