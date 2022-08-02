%% Morse Code Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Morse Code Chapter of "Experiments in MATLAB".
% You can access it with
%
%    morse_recap
%    edit morse_recap
%    publish morse_recap
%
% Related EXM programs
%
%    morse_gui
%    morse_tree
%    morse_tree_extended
%    morse_code

%% Cell Arrays

   C = {'A','rolling','stone','gathers','momemtum','.'}
   C{3}
   C(3)
   C(1:3)
   C{1:3}
   {C{1:3}}

%% Create a Morse Tree
% An absurd statement.  For a better way, see morse_tree.

   M = {'' ...
       {'E' ...
          {'I' {'S' {'H' {} {}} {'V' {} {}}} ...
               {'U' {'F' {} {}} {}}} ...
          {'A' {'R' {'L' {} {}} {}} ...
               {'W' {'P' {} {}} {'J' {} {}}}}} ...
       {'T' ...
          {'N' {'D' {'B' {} {}} {'X' {} {}}} ...
               {'K' {'C' {} {}} {'Y' {} {}}}} ...
          {'M' {'G' {'Z' {} {}} {'Q' {} {}}} ...
               {'O' {} {}}}}}

%% Follow '-..-'
   M = morse_tree
   M = M{3}
   M = M{2}
   M = M{2}
   M = M{3}

%% Depth first, with a stack.
   S = {morse_tree};
   while ~isempty(S)
      N = S{1};
      S = S(2:end);
      if ~isempty(N)
         fprintf(' %s',N{1})
         S = {N{2} N{3} S{:}};
      end
   end
   fprintf('\n')

%% Breadth first, with a queue.
   Q = {morse_tree};
   while ~isempty(Q)
      N = Q{1};
      Q = Q(2:end);
      if ~isempty(N)
         fprintf(' %s',N{1})
         Q = {Q{:} N{2} N{3}};
      end
   end
   fprintf('\n')

%% Recursive traversal.
%   function traverse(M)
%      if nargin == 0
%         M = morse_tree;    % Initial entry.
%      end
%      if ~isempty(M)
%         disp(M{1})
%         traverse(M{2})     % Recursive calls.
%         traverse(M{3})
%      end
%   end % traverse

%% ASCII character set
   k = reshape([32:127 160:255],32,[])';
   C = char(k)
   txt = text(.25,.50,C,'interp','none');
   set(txt,'fontname','Lucida Sans Typewriter')
