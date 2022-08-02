% PRODDL   最後の期間が端数の有価証券の価格を出力
%
% [P,AI] = PRODDL(SD,MD,LCD,RV,CPN,YLD,PER,BASIS) は、最後の期間が端数の
% 有価証券の価格 P と経過利子 AI を出力します。SD は決済日、MD は満期日、
% LCD は最後のクーポン支払日、RV は額面価格、CPN はクーポンレート、YLD 
% は利回り、PER は年間の利払い期間数(デフォルトは2)、BASIS は、
% 0 =actual/actual (デフォルト),1= 30/360, 2 = actual/360, 3 = actual/365
% です。
% 
% 例題：
% つぎのデータを使用すると、
% 
%              SD = '02/07/1993'
%              MD = '08/01/1993'
%              LCD = '02/04/1993'
%              RV = 100
%              CPN = 0.0650
%              YLD = 0.0535
%              PER = 2
%              BASIS = 1
%       
%              [p,ai] = proddl(sd,md,lcd,rv,cpn,yld,per,basis)
%       
% この結果、p = 100.54 と ai = 0.05を出力します。
% 
% 参考 : PRODDF, PRODDFL, PRBOND, YLDODDL.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 11, 13, 14, 15. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
