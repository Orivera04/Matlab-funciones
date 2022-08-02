function C = GAproduct(m,n)
%GAproduct(m,n): Take the geometric product of two GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
	  M = GAExpand(m);
          C = GA(M*n.m);
