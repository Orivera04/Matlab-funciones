% Main: Set up data to demonstrate usage of 'visfem'.
% visfem: Visualises linear finite element functions on unstructered
% triangular grids or bilinears on rectangular grids by different
% methods.
% Usage: Some redefined grids and functions given. Own grids may be
%    referenced below ('gridbsp'), own functions declared in 'func_u'
%    ('bsp').

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

clear; format compact; format short e;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Global definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global coord nodes;% Discretisation
global bsp gridbsp;% Controls examples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bsp    = 1;% Implemented example (data, see func_u.m)
gridbsp= 1;% Macro discretisation (see switch below)
graph0 = 1;% Type of graphical output:
           % 1(2)=(s)graph, 3(4)=(c)mesh, 5=level, 6=grad
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load geometry data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch gridbsp
case {1,2}% 1=1-Ball, 2=1/2-1-Annulus triangulated
   macrogrid(gridbsp);
case 3% A simple rectangular example
   coord= [ 0 0; 1 0; 1 1; 0 1; 1 0.5; 0.5 1; 0 0.5; 0.5 0; 0.5 0.5];
   nodes= [ 1 8 9 7; 8 2 5 9; 9 5 3 6; 7 9 6 4];
%case 4% Your data might be inserted here
%   coord= ?
%   nodes= ?
otherwise
   disp('*** Error *** No such method');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Show the macro-discretisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (graph0>0) show_macro(nodes,coord); end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fill in the values for 'u'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u= func_u(coord);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Visualise 'u'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
visfem(graph0,u,nodes,coord);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('THE END\n');
