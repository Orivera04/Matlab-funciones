% PRODDFL   最初と最後の期間が端数で最初の期間に決済する有価証券の価格を
%           出力
%
% [P,AI] = PRODDFL(SD,MD,ID,FD,LCD,RV,CPN,YLD,PER,BASIS) は、最初と最後の
% 期間が端数で最初の期間に決済日がある有価証券の価格 P と経過利子 AI を
% 出力します。SD は決済日、MD は満期日、ID は発行日、FD は最初のクーポン
% 支払日、LCD は最後のクーポン支払日、RV は額面価格、CPN はクーポン
% レート、YLD は利回り、PER は年間の利払い期間数(デフォルトは2)、BASIS 
% は、0 =actual/actual (デフォルト),1= 30/360, 2 = actual/360, 
% 3 = actual/365 です。日付は、シリアル日付番号、または、日付文字列で入力
% してください。
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
%              CPN = 0.04
%              YLD = 0.0427
%              PER = 2
%              BASIS = 1
%       
%              [p,ai] = proddfl(sd,md,id,fd,lcd,rv,cpn,yld,per,basis)
%       
% この結果、p = 95.71 とai = 0.16を出力します。
% 
% 参考 : PRODDF, PRODDL, PRBOND, YLDBOND.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 16, 17, 18, 19. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
