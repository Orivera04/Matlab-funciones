% YLDODDFL   最初と最後の期間が端数で最初の期間に決済する有価証券の利回り
%            を出力
%
% YLD = YLDODDFL(SD,MD,ID,FD,LCD,RV,PRICE,CPN,PER,BASIS,MAXITER) は、最初
% と最後の期間が端数で最初の期間に決済する有価証券の利回りを出力します。
% SD は決済日、MD は満期日、ID は発行日、FD は最初のクーポン支払日、LCD 
% は最後のクーポン支払日、RV は額面価格、PRICE は有価証券の価格、CPN は
% クーポンレート、PER は年間のクーポン期間数(デフォルト=2)、 BASIS は、
% 0 = actual/actual (デフォルト)、1 = 30/360、2 = actual/360、
% 3 = actual/365 のいずれかを設定します。MAXITER は、YLD を求めるために、
% Newton 法で使用する反復回数を指定します。デフォルトは、MAXITER = 50
% です。日付はシリアル日付番号、または、日付文字列で入力します。
% 
% 例題：
% つぎのデータを使用すると、
%   
%              SD = '03/15/1993'
%              MD = '03/01/2020'
%              ID = '03/01/1993'
%              FD = '07/01/1993'
%              LCD = '01/01/2020'
%              RV = 100
%              PRICE = 95.71
%              CPN = 0.04
%              PER = 2
%              BASIS = 1
%       
%              yld = yldoddfl(sd,md,id,fd,lcd,rv,price,cpn,per,basis)
%       
% は、yld = 0.0427 すなわち 4.27%を出力します。
% 
% 参考 : YLDODDF, YLDODDL, YLDBOND, PRODDFL.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 16, 17, 18, 19. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
