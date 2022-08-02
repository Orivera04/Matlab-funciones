%% Life Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Life Chapter of "Experiments in MATLAB".
% You can access it with
%
%    life_recap
% It does not work so well with edit and publish.
%
% Related EXM programs
%
%    lifex

% Generate a random initial population
   X = sparse(50,50);
   X(21:30,21:30) = (rand(10,10) > .75);
   p0 = nnz(X);
   
% Loop over 100 generations.
   for t = 1:100
      
      spy(X)
      title(num2str(t))
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
   
   end
   
   p100 = nnz(X);
   fprintf('%5d %5d %8.3f\n',p0,p100,p100/p0)
