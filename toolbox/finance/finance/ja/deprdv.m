% DEPRDV   残存減価償却可能価値
%
% R = DEPRDV(COST,SALVAGE,ACCUM) は、資産の原価 COST、処分価格 SALVAGE、
% 過去の期間に対して資産の累積減価償却費 ACCUM を与えて、残存減価償却
% 可能価値を出力します。
% 
% 例題：
% ある資産の原価が$13,000で、その残余年数は10年間とします。その処分価格
% は$1000です。まず、定額減価償却関数 depstln により、累積減価償却費を
% 求めます。つぎに、6年後の残存減価償却可能価値を求めます。
% 
%       accum = depstln(13000,1000,10)*6 = 7200 
%       r = deprdv(13000,1000,7200)= 4800 
% 
% 参考 : DEPFIXDB, DEPGENDB, DEPSOYD, DEPSTLN.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
