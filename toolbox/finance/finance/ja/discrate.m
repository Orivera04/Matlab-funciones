% DISCRATE   有価証券の割引率を出力
%
% D = DISCRATE(SD,MD,RV,PRICE,BASIS)は、決済日 SD、満期日 MD、額面価格 
% RV、価格 PRICE が与えられたときに、有価証券の割引率を求めます。BASIS 
% は日数カウント基準で、0 = actual/actual (デフォルト)、1 = 30/360、
% 2 = actual/360、3 = actual/365のいずれかを設定します。日付は、シリアル
% 日付番号あるいは日付文字列で入力します。 
% 
% 例題： 
%    d = discrate('12-jan-1994', '25-jun-1994', 100, 97.74, 0)
% この結果、d = 0.0503 すなわち割引率5.03%を出力します。  
% 
% 参考 : ACRUDISC, FVDISC, PRDISC, YLDDISC.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 1*. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
