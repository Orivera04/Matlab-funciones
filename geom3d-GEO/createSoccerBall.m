function varargout = createSoccerBall()
%CREATESOCCERBALL return a soccerball as a polyhedra
%
%   It is basically a wrapper of the 'bucky' function in matlab.
%   [n e f] = createSoccerBall
%   return nodes, edges and faces that constitute a soccerball
%
%   Example
%   [n f] = createSoccerBall;
%   drawPolyhedra(n, f);
%
%   See also
%   createCube, createOctahedron
%
%
% ------
% Author: David Legland
% e-mail: david.legland@jouy.inra.fr
% Created: 2006-08-09
% Copyright 2006 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas).

%   HISTORY
%   04/01/2007: remove unused variables, enhance output processing

[b n] = bucky;
[i j] = find(b);
e = [i j];

f = minConvexHull(n);

if nargout==0 || nargout==3
    varargout{1} = n;
    varargout{2} = e;
    varargout{3} = f;
elseif nargout==2
    varargout{1} = n;
    varargout{2} = f;
elseif nargout==1
    % return a structure
    s.nodes = n;
    s.edges = e;
    s.faces = f;
    varargout{1} = s;
end
