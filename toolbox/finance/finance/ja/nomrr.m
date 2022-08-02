% NOMRR   名目収益率を出力
%
% APR = NOMRR(ER,PER) は、実効年利パーセンテージ ER と年間複利回数 PER に
% 基づいて名目収益率を計算します。
%
% 例題：
% 毎月複利で実効年利パーセンテージ9.38%を基に、名目収益率を求めます。
% 
%       apr = nomrr(.0938,12)　　
% 
% この結果、apr = 0.09、すなわち、9%を出力します。
%
% 参考 : EFFRR, IRR, MIRR,TAXEDRR, XIRR.


%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
