function biarrow(iA,iB,c)
% biarrow(A,B,c): draw an arrow from the head of B to the head of A in color c

%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

if nargin == 2
    c = 'b';
end
A = GAZ(iA);
B = GAZ(iB);

if GAisa(A,'vector')==0 | GAisa(B,'vector')==0
   error('Can only draw arrow for vector');
end

plot3([B.m(2) A.m(2)+B.m(2)], [B.m(3) A.m(3)+B.m(3)], [B.m(4) A.m(4)+B.m(4)], c);

% Construct a vector perpendicular to A-B
lA = sqrt(inner(A,A));
% Numerical problems require us to extract the vector portion
if abs(A.m(4)) < lA*.9
   p1 = grade((e3^A)*inverse(A),1);
else
   p1 = grade((e2^A)*inverse(A),1);
end
hold on
p2 = dual(p1^A);
lS = lA*.9;
p1 = (0.04*lS/sqrt(double(inner(p1,p1))))*p1;
p2 = (0.04*lS/sqrt(double(inner(p2,p2))))*p2;
pA = A/lA*lS;
% Cell array version
t = (0:pi/4:2*pi);
head = cell(2,length(t));
% Pre add to reduce the cost below
pAB = pA+B;
AB = A+B;
for i=1:length(t)
    % Work with matrices to reduce calls to GAExpand
    head{1,i} = GA(sin(t(i))*p1.m + cos(t(i))*p2.m + pAB.m);
    head{2,i} = AB;
end

GALineMesh(head,c);
