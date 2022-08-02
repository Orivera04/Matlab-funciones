% line_dot(p1,p2)  plots a dotted line from point p1 to p2
% where p1 and p2 are vectors of 2D coordinates for 
% starting and ending points, respectively.
%  Example>> p1=[0,-0.6]; p2=[0, 0.6];  line_dot(p1,p2);
%  Copyright S. Nakamura, 1995
function dummy = line_dot(p1,p2)
plot([p1(1),p2(1)],[p1(2),p2(2)], ':')
