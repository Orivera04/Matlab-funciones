% PRBOND   定期利払いの有価証券の価格を出力
%
% [P,AI] = PRBOND(SD,MD,RV,CPN,YLD,PER,BASIS) は、定期的利払いの有価証券
% の価格 P と経過利子 AI を出力します。SD は決済日、MD は満期日、RV は額
% 面価格、CPN はクーポンレート、YLD は利回り、PER は年間の期間数(デフォ
% ルトは2)、BASIS は日数カウント基準で: 0 =actual/actual (デフォルト)、
% 1 = 30/360、2 = actual/360、3 = actual/365のいずれかを設定します。日付
% は、シリアル日付番号、または、日付文字列で入力してください。この関数は
% CPN = 0 とすることにより、ゼロクーポン債にも純割引有価証券にも適用され
% ます。
% 
% 例題：以下のデータを使用すると、
%   
%              SD = '02/01/1960'
%              MD = '01/01/1990'
%              RV = 1000
%              CPN = 0.08
%              YLD = 0.06
%              PER = 2
%              BASIS = 0
%       
%              [p,ai] = prbond(sd,md,rv,cpn,yld,per,basis)
%       
% この結果、p = 1276.39 及び ai = 6.81が出力されます。
% 
% 参考 : YLDBOND, PRMAT, PRDISC.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 6, 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
