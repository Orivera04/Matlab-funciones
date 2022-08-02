% This function computes "SQUARE of distance"
function SquareDistance=TwoNormSqDist(p1,p2)
%INPUT
% p1=[x1,x2....xn) (or column vector)
% p2=[y1,y2....yn) (or column vector)
%OUTPUT
% 2-norm square distance between p1 and p2

% The algorithms is based on euclidean distance 


SquareDistance=0;
for i=1:length(p1)
    SquareDistance=SquareDistance + ( ( p1(i)-p2(i) ).^2 ) ;
end


% Notes:
% For many applications we can make dicision based on square distance only
% rather than distance. So by computing square distace we avoid to compute
% square root.
% If you want distance than just compute the squre root of square distance
% i.e. sqrt(SquareDistance).

% Reference: http://en.wikipedia.org/wiki/Distance 

% % -------------------------------------------------------------------------
% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied. This program is free to use/share for
% % non-commercial purpose only, for any other usage contact with author.
% % Kindly reference author.
% % Thanking you.
% % @ Copyright M Khan
% % Email: mak2000sw@yahoo.com
% %        mak2000@GameBox.net 
% % http://www.geocities.com/mak2000sw

