% BONDCONV   コンベクシティ
%
% [PC,YC] = BONDCONV(SD,MD,RV,CPN,YLD,PER,BASIS) は、期間 PC と年数 YC 
% における有価証券のコンベクシティを出力します。SD は決済日、MD は満期日、
% RV は額面価格、CPN はクーポンレート、YLD は利回り、PER は年間の期間数
% (デフォルトは2)、BASIS は日数カウント基準で: 0 =actual/actual (デフォ
% ルト)、1 = 30/360、2 = actual/360、3 = actual/365のいずれかを設定しま
% す。日付はシリアル日付番号、または、日付文字列で入力してください。
%       
% 例題：
% つぎのデータが与えられているとき
%       
%       決済日　　        01-Dec-1994
%       満期日 　　       01-Jan-2001
%       額面価格 　       $100.00
%       クーポンレート 　 5%
%       利回り 　         4.34%
%       期間　　          半年
%       日数カウント基準  actual/actual
%       
%       [pc,yc] = bondconv('12/1/1994','1/1/2000',100,0.05,0.0434,2,0)
%       
% は、 pc = 92.13 期間と yc = 23.03 年を出力します。
%
% 参考 : BONDDUR, CFCONV, CFDUR, BNDCONVY.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
