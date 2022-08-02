%% TicTacToe Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the TicTacToe Chapter of "Experiments in MATLAB".
% You can access it with
%
%    tictactoe_recap
%    edit tictactoe_recap
%    publish tictactoe_recap
%
% Related EXM programs
%
%    tictactoe

%% tictactoe/winner

%  function p = winner(X)
%  % p = winner(X) returns
%  %    p = 0, no winner yet,
%  %    p = -1, blue has won,
%  %    p = 1, green has won,
%  %    p = 2, game is a draw.
%  
%  for p = [-1 1]
%     s = 3*p;
%     win = any(sum(X) == s) || any(sum(X') == s) || ...
%           sum(diag(X)) == s  || sum(diag(fliplr(X))) == s;
%     if win
%        return
%     end
%  end
%  p = 2*all(X(:) ~= 0);

%% tictactoe/strategy

%  function [i,j] = strategy(X,p);
%  % [i,j] = strategy(X,p) is a move for player p.
%  
%  % Appear to think.
%  pause(0.5)
%  
%  % If possible, make a winning move.
%  [i,j] = winningmove(X,p);
%  
%  % Block any winning move by opponent.
%  if isempty(i)
%     [i,j] = winningmove(X,-p);
%  end
%  
%  % Otherwise, make a random move.
%  if isempty(i)
%     [i,j] = find(X == 0);
%     m = ceil(rand*length(i));
%     i = i(m);
%     j = j(m);
%  end

%% tictactoe/winningmove

%  function [i,j] = winningmove(X,p);
%  % [i,j] = winningmove(X,p) finds any winning move for player p.
%  
%  s = 2*p;
%  if any(sum(X) == s)
%     j = find(sum(X) == s);
%     i = find(X(:,j) == 0);
%  elseif any(sum(X') == s)
%     i = find(sum(X') == s);
%     j = find(X(i,:) == 0);
%  elseif sum(diag(X)) == s
%     i = find(diag(X) == 0);
%     j = i;
%  elseif sum(diag(fliplr(X))) == s
%     i = find(diag(fliplr(X)) == 0);
%     j = 4 - i;
%  else
%     i = [];
%     j = [];
%  end
