function T = GAbilinear(m,n)
%GAbilinear(m,n): Computes the bilinear form of two GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
S=GAsignature;
N=[n.m(1);S(1)*n.m(2);S(2)*n.m(3);S(3)*n.m(4);S(1)*S(2)*n.m(5);S(2)*S(3)*n.m(6);S(3)*S(1)*n.m(7);S(1)*S(2)*S(3)*n.m(8)];
T = (m.m')*N;
     
