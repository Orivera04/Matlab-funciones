% PRDISC   割引有価証券の価格を出力
%
% P = PRDISC(SD,MD,RV,DISC,BASIS) は、決済日 SD、満期日 MD、償還額 RV、
% 日数カウント基準 BASIS が与えられたときに、割引有価証券の価格を出力し
% ます。BASIS は、0 =actual/actual (デフォルト),1= 30/360, 2 = actual/360,
% 3 = actual/365です。日付はシリアル日付番号、または、日付文字列で入力し
% てください。
% 
% 例題：以下のデータを使用すると、 
%   
%              SD = '10/14/1988'
%              MD = '03/17/1989'
%              RV = 100
%              disc = 0.087
%              basis = 2
%       
%              p = prdisc(sd,md,rv,disc,basis)
%       
% この結果、p = 96.28 が出力されます。
% 
% 参考 : PRBOND, PRMAT, YLDDISC.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 2. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
