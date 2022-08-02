% YLDMAT   満期時利払いの有価証券の利回りを出力
%
% YLDMAT(SD,MD,ID,RV,PRICE,CPN,BASIS) は、満期時利払いの有価証券の利回り
% を出力します。SD は決済日、MD は満期日、ID は発行日、RV は額面価格、
% PRICE は価格、CPN はクーポン利率、BASIS は、0 = actual/actual (デフォ
% ルト)、1 = 30/360、2 = actual/360、3 = actual/365のいずれかを設定しま
% す。日付は、シリアル日付番号、または、日付文字列で入力します。
% 
% 例題：
% つぎのデータを使用すると、
% 
%              SD = '02/07/1992'
%              MD = '04/13/1992'
%              ID = '10/11/1991'
%              RV = 100
%              PRICE = 99.98
%              CPN = 0.0608
%              BASIS = 1
%       
%              y = yldmat(sd,md,id,rv,price,cpn,basis)
%       
% は、y = 0.0607 すなわち 6.07%を出力します。
% 
% 参考 : PRBOND, YLDBOND, YLDDISC, PRMAT.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%          I-II, 3rd edition.  Formula 3. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
