function [r,p,k]=residue(g)
%RESIDUE Partial Fraction Expansion of Rational Polynomial Objects. (MM)
% [R,P,K]=RESIDUE(G) returns the residues R, poles P, and direct terms K
% of the rational polynomial G in the same manner that RESIDUE(B,A) does
% for standard polynomials.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[r,p,k]=residue(g.n,g.d);
