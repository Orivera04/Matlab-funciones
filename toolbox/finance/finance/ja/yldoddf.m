% YLDODDF   最初の期間が端数の有価証券の利回りを出力
%
% YLD = YLDODDF(SD,MD,ID,FD,RV,PRICE,CPN,PER,BASIS,MAXITER) は、最初の
% 期間が端数で最初の期間に決済する有価証券の利回りを出力します。SD は
% 決済日、MD は満期日、ID は発行日、FD は最初のクーポン支払日、RV は額面
% 価格、PRICE は有価証券の価格 CPN はクーポンレート、PER は年間のクーポン
% 期間数(デフォルト=2)、BASIS は、0 = actual/actual (デフォルト)、
% 1 = 30/360、2 = actual/360、3 = actual/365 のいずれかを設定します。
% MAXITER は、YLD を求めるために、Newton 法で使用する反復回数を指定し
% ます。デフォルトはMAXITER = 50です。 日付は、シリアル日付番号、または、
% 日付文字列で入力します。
% 
% 例題：
% つぎのデータを使用すると、
% 
%              SD = '11/11/1992'
%              MD = '03/01/2005'
%              ID = '10/15/1992'
%              FD = '03/01/1993'
%              RV = 100
%              PRICE = 113.60
%              CPN = 0.0785
%              PER = 2
%              BASIS = 0
%       
% yld = yldoddf(sd,md,id,fd,rv,price,cpn,per,basis) は、yld = 0.0625、
% すなわち、6.25%を出力します。
% 
% 参考 : YLDODDL, YLDBOND, YLDODDFL.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 8, 9. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
