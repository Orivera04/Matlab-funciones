% この関数は、fzero によってコールされる関数です。PORTALLOC 関数を通じて
% のみコール可能なプライベート関数です。
% 
%  無差別曲線-> 収益 = U + 0.5A*危険^2
%  f1(x)= U + 0.5Ax^2 ->無差別曲線
%  f2(x)= 有効フロンティア曲線
%  err = d(f1(x))/dx - d(f2(x))/dx


%  Author(s): M. Reyes-Kattar, 02/05/98
%  Copyright 1995-2002 The MathWorks, Inc.  
