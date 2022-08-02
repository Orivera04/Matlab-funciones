% DEPSTLN   定額減価償却
%
% SL = DEPSTLN(COST,SALVAGE,LIFE)は、資産の原価 COST、処分価格 SALVAGE、
% 資産の減価償却可能残余年数 LIFE を与えて、定額減価償却費を計算します。
% 
% 例題：
% ある資産の原価が$13,000で残余年数は10年間です。なお、その資産の処分
% 価格は $1000 です。   
% 
%    SL = depstln(13000,1000,10)
% 
% この結果、 SL = $1200が出力されます。
% 
% 参考 : DEPFIXDB, DEPGENDB, DEPRDV, DEPSOYD.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
