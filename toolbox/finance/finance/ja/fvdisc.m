% FVDISC   割引有価証券の将来価値
%
% RV = FVDISC(SD,MD,PRICE,DISC,BASIS) は、決済日 SD、満期日 MD、現在価値 
% PRICE 、割引率 DISC、日数カウント基準 BASIS が与えられた時、全額払込有価
% 証券の満期時受け取り額を求めます。BASISは0 =actual/actual (デフォルト)、
% 1 = 30/360、2 = actual/360、3 = actual/365のいずれかを設定します。
% 日付は、シリアル日付番号、あるいは、日付文字列で入力します。
% 
% 例題：以下のデータを使用すると、
% 
%       SD = '02/15/1991' 
%       MD = '05/15/1991' 
%       PRICE = 100 
%       DISC = .0575 
%       BASIS = 2 
% 
% 有価証券の満期時受取額として$101.44が出力されます。
% 
% 参考 : ACRUDISC, PRDISC, YLDDISC.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
