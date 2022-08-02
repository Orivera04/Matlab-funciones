% OPPROFIT   オプションの収益
%
% P = OPPROFIT(SO,X,COST,FLAG,TYPE) は、資産価格 SO、権利行使価格 X、
% オプションの原価 COST からオプションの収益を計算します。FLAG は、
% ロングポジション (FLAG = 0) かショートポジション(FLAG = 1)かを指定
% します。TYPE は、コールオプション (TYPE = 0)かプットオプション 
% (TYPE = 1) かを指定します。
% 
% 例題：
% 現行価格が$100の原資産に対する権利行使価格$90のコールオプションを
% $4 で購入(ロング)します。この条件でオプションを行使した場合、収益
% $6 となります。
%
% 参考 : BINPRICE, BLSPRICE.


%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
