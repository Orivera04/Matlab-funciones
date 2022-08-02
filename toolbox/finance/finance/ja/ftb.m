% FTB   Financial Toolbox 引数のヘルプのリスト
%
% "help ftpARGUMENT" とタイプすることにより、ARGUMENT で指定された引数、
% または、項のヘルプを参照することができます。ヘルプが利用できるものを
% 示します。
%
% クーポン構造の設定
%   ftbSettle              -  決済日
%   ftbMaturity            -  満期日
%   ftbIssueDate           -  発行日
%   ftbStartDate           -  債券をあらかじめスタートさせる日付
%   ftbFirstCouponDate     -  最初のクーポン日
%   ftbLastCouponDate      -  最後のクーポン日
%
%   ftbPeriod              -  市場での年間支払い数
%   ftbBasis               -  市場での日数カウント基準
%                             たとえば、2 = actual/360
%   ftbEndMonthRule        -  市場での月末規則
%
% 債券の金額設定
%   ftbCouponRate          -  クーポンレート(クーポン利率)
%   ftbFace                -  額面価値
%
% クーポン支払いリスト
%   ftbCFlowAmounts        -  キャッシュフローの額
%   ftbCFlowDates          -  キャッシュフローの日付
%   ftbTFactors            -  決済日からの時間ファクタ
%   ftbCFlowFlags          -  支払いのタイプと内容
%
% 個々の商品の金額及び利回りパラメータ
%   ftbAccrfrac            -  クーポン支払い額のうち経過利子として支払
%                             われるべき金額
%
% 個々の商品の日付パラメータ
%   ftbNumCouponsRemaining -  満期までに残されたクーポン支払いの回数
%   ftbNextCouponDate      -  次回クーポン支払日の日付
%   ftbPreviousCoupondate  -  前回、または、現行クーポン支払日の日付
%   ftbNumDaysPeriod       -  現行クーポン期間の日数
%   ftbNumDaysNext         -  次回クーポン支払いまでの日数
%   ftbNumDaysPrevious     -  現行クーポン支払い日からの日数


%   Copyright 1995-2002 The MathWorks, Inc. 
