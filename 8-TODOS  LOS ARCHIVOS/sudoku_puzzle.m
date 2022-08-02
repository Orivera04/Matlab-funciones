function X = sudoku_puzzle(p)
% SUDOKU_PUZZLE  A few Sudoku puzzles.
%   X = sudoku_puzzle(p), for scalar p, returns the p-th puzzle.
%
%   p = 1   MATLAB Special.  Incorporates magic square.
%   p = 2   Easy, no backtracking required.
%   p = 3   Slightly difficult, only a few backtracking steps, not unique.
%   p = 4   Four-fold rotational symmetry.  Not too difficult.
%   p = 5   Moderately difficult, a few hundred backtracing steps.
%   p = 6   An airline magazine says this is difficult.  Is it? 
%   p = 7   Solution is not unique.
%   p = 8   Difficult. 
%   p = 9   Good example of backtracking.
%   p = 10  Will Shortz says "Beware. Very Challenging."
%   p = 11  Will Shortz says "Beware. Very Challenging."
%   p = 12  Structural symmetry and not too difficult.
%   p = 13  Nice spiral pattern, but there are 346 solutions.
%   p = 14  Structural symmetry.
%   p = 15  Very close to matrix symmetry, and very difficult.
%   p = 16  Structural symmetry and only 17 nonzero initial entries.
%
%   See also sudoku, sudoku_all, sudoku_assist, sudoku_basic.

   if nargin < 1, p = 1; end   % Default

   switch p
      case 1  % MATLAB Special.  Incorporates magic square.
         M = kron(eye(3),magic(3));
         S = sparse([9 8 4 3 7 6 2 1], [1:4 6:9], [1 2 3 1 3 1 8 3]);
         X = M + S;

      case 2  % Easy, no backtracking required.
         X = [2 0 7 0 9 1 0 0 4; 0 0 0 0 0 0 0 1 2; 6 0 0 0 0 2 5 9 0
              8 0 5 0 2 3 4 0 0; 9 7 0 0 0 0 0 2 6; 0 0 1 7 6 0 9 0 8
              0 8 6 2 0 0 0 0 3; 7 3 0 0 0 0 0 0 0; 5 0 0 6 3 0 1 0 9];

      case 3  % Slightly difficult, only a few backtracking steps, not unique.
         X = [0 0 0 9 0 0 3 0 5; 0 2 0 0 4 0 0 0 1; 3 0 0 0 8 0 9 0 0
              0 0 0 0 0 3 0 5 0; 0 6 0 4 5 0 8 0 0; 0 0 7 8 0 9 0 0 0
              0 9 2 6 0 4 0 7 0; 6 0 0 0 0 0 0 0 2; 5 7 0 0 0 2 0 3 0];

      case 4  % Four-fold rotational symmetry.  Not too difficult.
              % Ruud's Daily Sudoku Nightmare # 797.
              % http://www.sudocue.net/daily.php 
         X = [0 0 0 0 8 0 0 0 0; 0 0 1 7 0 6 8 0 0; 0 6 0 5 0 2 0 3 0
              0 4 7 0 0 0 3 1 0; 1 0 0 0 0 0 0 0 6; 0 8 5 0 0 0 7 2 0
              0 3 0 9 0 1 0 4 0; 0 0 9 8 0 3 2 0 0; 0 0 0 0 5 0 0 0 0];

      case 5  % Moderately difficult, a few hundred backtracing steps.
         X = [7 0 1 0 0 0 4 0 0; 5 0 0 0 0 0 0 0 0; 3 0 0 9 6 0 0 0 0
              0 0 0 3 8 0 0 0 5; 4 7 0 0 0 0 0 0 6; 0 0 0 0 0 9 8 0 2
              0 5 0 0 1 8 0 0 0; 0 2 4 0 0 0 5 0 0; 0 0 0 0 0 3 0 9 0];

      case 6  % An airline magazine says this is difficult.  Is it? 
         X = [0 0 0 1 0 0 0 3 0; 0 9 4 3 0 0 7 0 0; 1 0 6 0 0 0 8 2 0
              0 0 0 5 0 0 0 0 0; 6 2 8 0 0 0 5 1 9; 0 0 0 0 0 6 0 0 0
              0 4 1 0 0 0 2 0 5; 0 0 9 0 0 2 4 8 0; 0 8 0 0 0 5 0 0 0];

      case 7  % Solution is not unique.
              % Herzberg & Murty, Notices AMS, v.54, n.6, June 2007.
         X = [9 0 6 0 7 0 4 0 3; 0 0 0 4 0 0 2 0 0; 0 7 0 0 2 3 0 1 0
              5 0 0 0 0 0 1 0 0; 0 4 0 2 0 8 0 6 0; 0 0 3 0 0 0 0 0 5
              0 3 0 7 0 0 0 5 0; 0 0 7 0 0 5 0 0 0; 4 0 5 0 1 0 7 0 8];

      case 8  % Difficult. 
              % Only 17 nonzero initial entries.
              % Herzberg & Murty, Notices AMS, v.54, n.6, June 2007.
         X = [0 0 0 0 0 0 0 1 0; 4 0 0 0 0 0 0 0 0; 0 2 0 0 0 0 0 0 0
              0 0 0 0 5 0 4 0 7; 0 0 8 0 0 0 3 0 0; 0 0 1 0 9 0 0 0 0
              3 0 0 4 0 0 2 0 0; 0 5 0 1 0 0 0 0 0; 0 0 0 8 0 6 0 0 0];

      case 9 % Good example of backtracking.
             % Michael Mephapm, "Diabolical"
             % http://www.sudoku.org.uk/PDF/Solving_Sudoku.pdf 
         X = [0 9 0 7 0 0 8 6 0; 0 3 1 0 0 5 0 2 0; 8 0 6 0 0 0 0 0 0
              0 0 7 0 5 0 0 0 6; 0 0 0 3 0 7 0 0 0; 5 0 0 0 1 0 7 0 0
              0 0 0 0 0 0 1 0 9; 0 2 0 6 0 0 3 5 0; 0 5 4 0 0 8 0 7 0];

      case 10 % "Beware. Very Challenging."
              % Will Shortz, puzzle 301.
              % The Little Black Book of Sudoku.
         X = [0 3 9 5 0 0 0 0 0; 0 0 0 8 0 0 0 7 0; 0 0 0 0 1 0 9 0 4
              1 0 0 4 0 0 0 0 3; 0 0 0 0 0 0 0 0 0; 0 0 7 0 0 0 8 6 0
              0 0 6 7 0 8 2 0 0; 0 1 0 0 9 0 0 0 5; 0 0 0 0 0 1 0 0 8];

      case 11 % "Beware. Very Challenging."
              % Will Shortz, puzzle 400.
              % The Little Black Book of Sudoku.
         X = [0 0 0 0 0 0 8 7 0; 7 8 0 9 4 0 0 0 0; 0 0 0 0 5 0 0 2 0
              0 0 0 3 0 0 0 0 0; 0 5 6 0 0 0 0 0 0; 8 0 9 0 0 2 0 1 0;
              0 0 0 0 9 0 0 8 0; 0 0 0 0 0 0 4 0 7; 0 0 1 7 0 6 0 0 0];

      case 12 % Structural symmetry and not too difficult.
              % American Math Monthly.
              % http://www.maa.org/editorial/mathgames/mathgames_09_05_05.html 
         X = [0 5 0 0 0 0 0 7 0; 9 0 0 6 0 1 0 0 8; 0 0 6 0 2 0 1 0 0;
              0 6 0 0 0 2 0 1 0; 0 0 3 0 0 0 2 0 0; 0 4 0 3 0 0 0 5 0;
              0 0 4 0 3 0 5 0 0; 2 0 0 4 0 5 0 0 9; 0 3 0 0 0 0 0 6 0];

      case 13 % Nice spiral pattern, but there are 346 solutions.
              % Salim Jaliwala, "Scratch n' Play Sudoku", volume 1, page 80.
              % http://scratchnplaysudoku.com
         X = [0 0 0 0 6 3 0 0 0; 0 0 0 0 0 0 3 0 0; 0 4 7 1 0 0 2 0 0
              6 0 0 0 5 0 1 0 0; 4 0 0 6 0 0 0 0 7; 0 0 0 0 7 0 0 0 5
              0 0 8 0 0 2 6 7 0; 0 0 5 0 0 0 0 0 0; 0 0 0 7 3 0 0 0 0];

      case 14 % Structural symmetry.
              % Gordon Royle, University of Western Australia.
              % http://mapleta.maths.uwa.edu.au/~gordon/sudokumin.php 
         X = [0 2 0 0 3 0 0 4 0; 6 0 0 0 0 0 0 0 3; 0 0 4 0 0 0 5 0 0
              0 0 0 8 0 6 0 0 0; 8 0 0 0 1 0 0 0 6; 0 0 0 7 0 5 0 0 0
              0 0 7 0 0 0 6 0 0; 4 0 0 0 0 0 0 0 8; 0 3 0 0 4 0 0 2 0];

      case 15 % Very close to matrix symmetry, and very difficult.
              % Gordon Royle, University of Western Australia.
              % http://mapleta.maths.uwa.edu.au/~gordon/sudokumin.php 
         X = [6 0 0 0 0 0 0 0 3; 0 7 0 0 8 0 0 9 0; 0 0 2 0 0 0 5 0 0
              0 0 0 3 0 0 0 0 0; 0 8 0 0 1 0 0 7 0; 0 0 0 0 0 2 0 0 0
              0 0 5 0 0 0 1 0 0; 0 9 0 0 4 0 0 8 0; 3 0 0 0 0 0 0 0 2];

      case 16 % Structural symmetry and only 17 nonzero initial entries.
              % Gordon Royle, University of Western Australia.
              % http://mapleta.maths.uwa.edu.au/~gordon/sudokumin.php 
         X = [0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 1 2; 0 0 3 0 4 5 0 0 0
              0 0 0 6 0 1 0 7 0; 0 0 4 0 0 0 6 0 0; 0 0 5 8 0 0 0 0 0
              0 0 0 0 3 0 4 0 0; 0 1 0 2 0 0 0 0 0; 0 7 0 0 0 0 0 0 0];
  otherwise
     error('sudoku_puzzle(p) expects p in range 1 <= p <= 16')
  end

end % sudoku_puzzles
