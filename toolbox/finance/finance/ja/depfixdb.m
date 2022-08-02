% DEPFIXDB   固定逓減残高減価償却
%
% D = DEPFIXDB(COST,SALVAGE,LIFE,PERIOD,MONTH) は、各期間の固定逓減残高
% 減価償却費 D を計算します。COST は資産の当初価値、SALVAGE は資産の処分
% 価格、LIFE は資産の残余年数、PERIOD は計算する年数、MONTH は資産期間の
% 最初の年の月を表す数字です。MONTH のデフォルトは12です。
% 
% 例題：
% 1台の乗用車を$11,000で購入し、その処分価格は$1500、耐用年数は8年とし
% ます。最初の5年間の減価償却費は、つぎのように計算します。
%       
%       d = depfixdb(11000,1500,8,5)
%       
% この結果、d = [2425.08 1890.44 1473.67 1148.78 895.52] が出力されます。
% 
% 償却率を決定してください。
% 最終期間を過ぎた後に残る減価償却可能価値を決定してください。
%
% 参考 : DEPGENDB, DEPRDV, DEPSOYD, DEPSTLN.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
