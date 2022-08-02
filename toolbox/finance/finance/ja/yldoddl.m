% YLDODDL   最後の期間が端数の有価証券の利回りを出力
%
% YLD = YLDODDL(SD,MD,LCD,RV,PRICE,CPN,PER,BASIS,MAXITER) は、最後の期間
% が端数の有価証券の利回りを出力します。SD は決済日、MD は満期日、LCD は
% 最後のクーポン支払日、RV は額面価格、PRICE は有価証券の価格、CPN はク
% ーポンレート、PER は年間のクーポン期間数(デフォルト=2)、BASIS は、
% 0 = actual/actual (デフォルト)、1 = 30/360、2 = actual/360、
% 3 = actual/365 のいずれかを設定します。MAXITER は、YLD を求めるために、
% Newton 法で使用する反復回数を指定します。デフォルトは、MAXITER = 50
% です。日付は、シリアル日付番号、または、日付文字列で入力します。
% 
% 例題：
% 以下のデータを使用すると、
%  
%              SD = '02/07/1993'
%              MD = '06/15/1993'
%              LCD = '10/15/1992'
%              RV = 100
%              PRICE = 99.878
%              CPN = 0.0375
%              PER = 2
%              BASIS = 1
%       
% yld = yldoddl(sd,md,lcd,rv,price,cpn,per,basis) は、yld = 0.0405、
% すなわち、4.05%を出力します。
% 
% 参考 : YLDODDF, YLDBOND, YLDODDFL, PRODDL.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 10, 12, 14, 15. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
