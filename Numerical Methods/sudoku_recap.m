%% Sudoku Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Sudoku Chapter of "Experiments in MATLAB".
% You can access it with
%
%    sudoku_recap
%    edit sudoku_recap
%    publish sudoku_recap
%
%  Related EXM programs
%
%    sudoku
%    sudoku_all
%    sudoku_assist
%    sudoku_basic
%    sudoku_puzzle

%% Disclaimer
% Our Sudoku chapter and Sudoku program depend heavily
% upon recursion, which cannot be done by this script.

%% Sudoku puzzle incorporating the Lo-Shu magic square.
   X = kron(eye(3),magic(3))
   C = full(sparse([9 8 4 3 7 6 2 1], [1:4 6:9], [1 2 3 1 3 1 8 3]))
   X = X + C

% Also available as
   X = sudoku_puzzle(1);

%% Transforms of a Sudoku puzzle
   T = X;
   p = randperm(9);
   z = find(X > 0);
   T(z) = p(X(z))
   X'
   rot90(X,-1)
   flipud(X)
   fliplr(X)
   X([4:9 1:3],:)
   X(:,[randperm(3) 4:9])

%% Candidates

% C = candidates(X) is a cell array of vectors.
% C{i,j} is the set of allowable values for X(i,j).

   C = cell(9,9);
   tri = @(k) 3*ceil(k/3-1) + (1:3);
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
   C

%% First singleton and first empty.

% N = number of candidates in each cell.
% s = first cell with only one candidate.
% e = first cell with no candidates.

   N = cellfun(@length,C)
   s = find(X==0 & N==1,1)
   e = find(X==0 & N==0,1)

%% Sudoku puzzles

   help sudoku_puzzle

   for p = 1:16
      sudoku_puzzle(p)
   end
