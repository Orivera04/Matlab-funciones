% PRODDF   最初の期間が端数の有価証券の価格を出力
%
% [P,AI] = PRODDF(SD,MD,ID,FD,RV,CPN,YLD,PER,BASIS) は、最初の期間が端数
% で最初の期間に決済日がある有価証券の価格 P と経過利子 AI を出力します。
% SD は決済日、MD は満期日、ID は発行日、FD は最初のクーポン支払日、RV 
% は額面価格、CPN はクーポンレート、YLD は利回り、PER は年間の利払い期間
% 数(デフォルトは2)、BASIS は、0 =actual/actual (デフォルト),1= 30/360, 
% 2 = actual/360, 3 = actual/365です。日付は、シリアル日付番号、または、
% 日付文字列で入力してください。
% 
% 例題：つぎのデータを使用すると、
% 
%              SD = '11/11/1992'
%              MD = '03/01/2005'
%              ID = '10/15/1992'
%              FD = '03/01/1993'
%              RV = 100
%              CPN = 0.0785
%              YLD = 0.0625
%              PER = 2
%              BASIS = 0
%       
%              [p,ai] = proddf(sd,md,id,fd,rv,cpn,yld,per,basis)
%       
% この結果、p = 113.60 と ai = 0.59が出力されます。
% 
% 参考 : PRODDFL, PRODDL, PRBOND, YLDODDF.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 8, 9. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
