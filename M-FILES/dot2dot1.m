function dot2dot1(X)
% DOT2DOT  Connect the points from a 2-by-n matrix.
X(:,end+1) = X(:,1);
plot(X(1,:),X(2,:),'r')
axis(10*[-1 1 -1 1])
