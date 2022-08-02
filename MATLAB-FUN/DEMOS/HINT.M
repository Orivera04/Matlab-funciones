function hint
%HINT	Puzzle hints.
%	The command "hint" with no arguments gives a 
%	little help with the answer to the current puzzle.
%	You can also "type puzzle".
%
%	See also PUZZLE, MEMBRANE, GLOBAL.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

global HINTNUM

H = ['  .      U     e     zq     s  '
     'p    ehn    la    p     re     '
     'sg     b     la    ao     ln   '
     'et    qs    .s     U      r    '
     '   bg    )oi    ''c    a(    nl'''
     'n    bl     o    sg     la    a'
     '    shs    pr    c     ol     e'
     '  m     ie     hp    pa    nl  '
     '1  zz(l  e1zu  3)p/)  pu2(  zel'
     '    e.    oc     s     U      s'
     'x)sna   co1  /t =. n(Ux( ) eat '
     '  eduaenisev hteloah teYrn. y'' '
     'soe o l ,prtaroeiAn .htnhitephe'];

if (~exist('HINTNUM'))
	error('You better use puzzle first.')
end
n = HINTNUM;
k = size(H,2);
[ignore,j] = sort(sin(n*n+(1:k)));
disp(' ')
disp(H(n,j));
disp(' ')
