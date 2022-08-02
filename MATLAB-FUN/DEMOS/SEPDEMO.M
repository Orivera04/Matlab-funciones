%SEPDEMO Orderings and separators for a finite element mesh.

%	John Gilbert, 3-10-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

load('crack.mat')
A = crack;
xy = xy;

clf reset

gplot(A,xy);
title('Finite Element Mesh')

clc;
disp(' ');
disp('This script shows several different orderings of a matrix');
disp('corresponding to the finite element mesh you see. ');
disp(' ');
disp('Each ordering generates an "elimination tree" which describes  ');
disp('the dependencies among the columns of the reordered matrix. ');
disp('The elimination tree in turn induces a divide-and-conquer ');
disp('block decomposition of the matrix. ');
disp(' ');
disp('You might want to expand the plot window for the rest of the demo. ')
disp(' ');
disp('Press any key to continue. ');
pause;
clc;

disp(' ');
disp('The highlighted separator in the mesh is the last diagonal block ');
disp('of the matrix, and also the path of only children from the root ');
disp('of the elimination tree.  Each connected component of the rest ');
disp('of the mesh is another diagonal block, and is a subtree of the ');
disp('elimination tree. ');
disp(' ');
disp('Minimum degree is a heuristic that builds the elimination tree ');
disp('from the bottom up by a greedy algorithm.  We will see two');
disp('versions, corresponding to different parameter settings. ');
disp(' ');

spparms('default');
p = symmmd(A);
sepplot(A(p,p),xy(p,:),'Loose Minimum Degree Order','Loose Min Deg');

disp(' ');
disp('Press any key to continue. ');
pause;
clc;

disp(' ');
disp('Now we use a slightly different version of minimum degree. ');
disp(' ');
spparms('tight')
p = symmmd(A);
spparms('default')
sepplot(A(p,p),xy(p,:),'Tight Minimum Degree Order','Tight Min Deg');

disp(' ');
disp('Press any key to continue. ');
pause;
clc;
 
% disp(' ');
% disp('The next order is Sparspak''s nested dissection order, which builds the ');
% disp('elimination tree from the top down by trying to find good separators. ');
% disp(' ');
% disp('(This will only work if you have Sparspak running on your machine.) ');
% disp(' ');
% p = spknd(A);
% sepplot(A(p,p),xy(p,:),'Nested Dissection Order','Nested Dissection');
% 
% disp(' ');
% disp('Press any key to continue. ');
% pause;
% clc;

disp(' ');
disp('Finally, for comparison, we show a heuristic called ');
disp('reverse Cuthill-McKee that tries to reduce the profile');
disp('of the matrix, or cluster the nonzeros near the diagonal.');
disp('RCM sometimes gives sparse factors, but it also tends to  ');
disp('give an unbalanced or even trivial separator partition. ');
disp(' ');
p = symrcm(A);
sepplot(A(p,p),xy(p,:),'Reverse Cuthill-McKee Order','RCM');

disp('End')
