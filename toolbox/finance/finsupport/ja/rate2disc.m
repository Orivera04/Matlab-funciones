% RATE2DISC   利子率をキャッシュフロー割引ファクタに変換
%
% NPOINTS の時間間隔に渡って、年利率を与えて、キャッシュ割引を決定します。
% NCURVES 個の異なる利率曲線は、同一の時間構造をもつ場合に限り、一度に
% 変換することができます。インターバルはゼロ曲線、または、フォワード曲線
% で表示することも可能です。
%
% 使用法 1: インターバルポイントは、期間単位表示の時間で入力します。
%   [Disc] = rate2disc(Compounding, Rates, EndTimes)
%   [Disc] = rate2disc(Compounding, Rates, EndTimes, StartTimes)
%
% 使用法 2: ValuationDate は省略できます。また、インターバルポイントは
%           日付で入力します。
%   [Disc, EndTimes, StartTimes] = rate2disc(Compounding, Rates, ... 
%     EndDates, StartDates, ValuationDate)
% 
% 入力
%   Compounding - 年率換算時に、入力されたゼロ率をどのような度数で複利
%                 計算するかを示すスカラ値です。この引数は、割引ファクタ
%                 及び Times の解釈に適用する式をつぎのように決定します。
%     1)Compounding = 1, 2, 3, 4, 6, 12 = F
%        Disc = (1 + Z/F)^(-T), ここで、F は複利度数です。Z はゼロ率、
%        T は期間単位(periodic unit)で示された回数で、T = F の場合、1年を
%        指し示します。
%     2)Compounding = 365 
%        Disc = (1 + Z/F)^(-T)、ここで、F は基準となる年の日数、T は基準
%        となる年に基づいて計算される経過日数です。
%     3)Compounding = -1
%        Disc = exp( -T * Z ), T は年で示された時間を示しています。
%
%   Rates       - 10進法で表わした NPOINTS 行 NCURVES 列の行列です。たと
%                 えば、5 は、Rates では、0.05 です。Rates は、キャッシュ
%                 フローが評価される StartTimes から、キャッシュフロー
%                 の受取日である EndTimes を終点とする投資インターバルに
%                 対する利回りです。
%
%   使用法 1:ValuationDate が省略されなかったケースでは、3番目及び4番目
%            の引数は、時間として解釈されます。
%
%   EndTimes    - 割引が適用されるインターバルの終点となる時間を期間単位
%                 で示す NPOINTS 行1列のベクトルです。
%
%   StartTimes  - 割引が適用されるインターバルの始点となる時間を期間単位
%                 で示す NPOINTS 行1列のベクトルです。StartTimes はオプ
%                 ションの引数でデフォルト値は0です。
%
%   使用法 2:ValuationDate が省略された場合、3番目及び4番目の引数は日付
%            として解釈されます。 日付 ValuationDate は、時間を計算する
%            際のゼロ点として用いられます。
%
%   EndDates      - 割引が適用されるインターバルの終点となる満期日をシリ
%                   アル日付形式で示すスカラ値、または、NPOINTS 行1列の
%                   ベクトルです。
%
%   StartDates    - 割引が適用されるインターバルの始点となる日付をシリア
%                   ル日付形式で示すスカラ値、または、NPOINTS 行 1列の
%                   ベクトルです。StartDates はオプションの引数で、
%                   デフォルト値は ValuationDate です。
%
%   ValuationDate - StartDates と EndDates で入力された投資限界の観測日
%                   (observation date)をシリアル日付形式で示すスカラ値で
%                   す。ValuationDate は、使用法2では必須となります。
%                   一方、使用法1では、ValuationDate は省略するか、
%                   空行列によって入力をパスしなければなりません。
%
% 出力:
%   Disc          - EndTime で示された時点で受け取る単位キャッシュフロー
%                   が、StartTime で指定された時点で有する価値を10進数表
%                   記で示す割引ファクタからなる NPOINTS 行 NCURVES 列の
%                   列ベクトルです。
% 
%   StartTimes    - 割引が適用されるインターバルの始点となる時間を示す 
%                   NPOINTS 行1列の列ベクトルです。そして、この時間は、
%                   期間単位で測定されます。
%
%   EndTimes      - 割引が適用されるインターバルの終点となる時間を示す 
%                   NPOINTS 行1列の列ベクトルです。そして、この時間は、
%                   期間単位で測定されます。
%  
% 注意：
% Compounding = 365 (毎日複利)の場合、 StartTimes と EndTimes は、日単位
% で測定されます。それ以外の場合、この引数は、SIA 半年タイムファクタ 
% Tsemi から、公式  T = Tsemi/2 * F によって計算された値を含むことになり
% ます。ここで、F は複利計算の頻度を示しています。たとえば、連続複利の
% 場合、F は1に設定されます。
%
% 投資インターバルは、入力された時間(使用法 1)、または、入力された日付
% (使用法 2)のいずれかに指定できます。引数 ValuationDate が入力されると
% 日付解釈が呼び出され引数 ValuationDate が省略されると、デフォルトの
% 時間解釈が呼び出されることになります。
%
% 例題:
%   1) 6ヶ月, 12ヶ月, 24ヶ月における割引をゼロ曲線から計算します。キャッ
%      シュフローまでの時間は、1, 2, 4で、ここでは、キャッシュフローの
%      現在価値(時間0)を計算します。
%
%   Compounding = 2;
%   Rates = [0.05; 0.06; 0.065];
%   EndTimes   = [1; 2; 4];
%   Disc = rate2disc(Compounding, Rates, EndTimes)
%
%   StartTimes = [0; 0; 0];
%   Disc = rate2disc(Compounding, Rates, EndTimes, StartTimes)
% 
%   2)6ヶ月, 12ヶ月, 24ヶ月における割引をゼロ曲線から計算します。時間
%     範囲の終点を日付で指定します。
%
%   Compounding = 2;
%   Rates = [0.05; 0.06; 0.065];
%   EndDates = ['10/15/97'; '04/15/98'; '04/15/99'];
%   ValuationDate = '4/15/97'; 
%   Disc = rate2disc(Compounding, Rates, EndDates, [], ValuationDate)
%
%   3)現時点を始点とする1年フォワード利率から6ヶ月及び12ヶ月の割引を計算
%     します。複利計算では毎月複利を適用します。キャッシュフローまでの
%     時間は、12、18、24、フォワードタイムは、0、6、12　です。
%
%   Compounding = 12;
%   Rates = [0.05; 0.04; 0.06];
%   EndTimes = [12; 18; 24];
%   StartTimes = [0; 6; 12];
%   Disc = rate2disc(Compounding, Rates, EndTimes, StartTimes)
%
% 参考 : DISC2RATE, RATETIMES.


%   Author(s): J. Akao 11/03/98
%   Copyright 1995-2002 The MathWorks, Inc. 
