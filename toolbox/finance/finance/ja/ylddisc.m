% YLDDISC   割引有価証券の利回りを出力
%
% Y = YLDDISC(SD,MD,RV,PRICE,BASIS) は、決済日 SD、満期日 MD、償還額 RV、
% 割引価格 PRICE、日数カウント基準 BASIS が与えられたときに、割引有価証
% 券の利回りを求めます。BASIS は、0 = actual/actual (デフォルト)、1 = 
% 30/360、2 = actual/360、3 = actual/365のいずれかを設定します。日付は、
% シリアル日付番号、または、日付文字列で入力します。
% 
% 例題：
% つぎのデータを使用すると、
%   
%              SD    = '10/14/1988'
%              MD    = '03/17/1989'
%              RV    = 100
%              PRICE = 96.28
%              BASIS = 2
%       
%              y = ylddisc(sd,md,rv,price,basis)
%       
% は、y = 0.0903 すなわち 9.03%を出力します。
% 
% 参考 : PRBOND, YLDBOND, YLDMAT, PRDISC.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 1. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
