% BONDDUR   Macaulayデュレーション及び修正デュレーション
%
% [D,M] =  BONDDUR(SD,MD,RV,CPN,YLD,PER,BASIS) は、定期的利払いの有価証券
% に対して、Macaulay デュレーション D と修正デュレーション M を年数で求
% めます。SD は決済日、MD は満期日、RV は額面価格、CPN はクーポンレート
% YLD は利回り、PER は年間の期間数(デフォルトは2)、BASIS は日数カウント
% 基準で: 0 =actual/actual (デフォルト)、1 = 30/360、2 = actual/360、
% 3 = actual/365のいずれかを設定します。日付は、シリアル日付番号、または、
% 日付文字列で入力してください。
%       
% 例題：つぎのデータが与えられているとき
%       
%       決済日　　        01-Dec-1994
%       満期日 　       　01-Jan-2001
%       額面価格 　       $100.00
%       クーポンレート 　 5%
%       利回り 　         4.34%
%       期間　　          半年
%       日数カウント基準  actual/actual
%       
%       [d,m] = bonddur('12/1/1994','1/1/2000',100,0.05,0.0434,2,0)
%       
% は、 Macaulay デュレーション d = 4.4720 年と修正デュレーション
% m = 4.3770 年を出力します。
% 
% 参考 : BONDCONV, CFDUR, CFCONV, BNDDURY.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
