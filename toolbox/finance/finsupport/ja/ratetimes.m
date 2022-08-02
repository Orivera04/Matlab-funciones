% RATETIMES   利子率環境を定義する時間インターバルを変更
%
% 利子率環境を、時間インターバルの集合に対する利回りで定義し、他の時間
% インターバルの集合に対する利回りを計算します。ゼロ率は時間に対して
% 区分的に線形であると仮定されます。
%
% 使用法 1
%   [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%      RefRates, RefEndTimes, RefStartTimes, EndTimes)
%
%   [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%      RefRates, RefEndTimes, RefStartTimes, EndTimes, StartTimes)
%     
%   オプション: RefStartTimes, StartTimes
%
% 使用法 2 : 
%   ValuationDate は省略できます。なお、インターバルポイントは日付で
%   入力してください。
%   [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%      RefRates, RefEndDates, RefStartDates, EndDates, StartDates, ...
%      ValuationDate)
%
% 入力:
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
%   RefRates    - 基準となる利率を10進数で示す NREFPTS 行 NCURVES 列の
%                 ベクトルです。RefRates は、キャッシュフローが評価される 
%                 RefStartTimes から、キャッシュフローの受取日である 
%                 RefEndTimes を終点とする投資インターバルに対する利回り
%                 です。
%
%   使用法 1: ValuationDate が省略されない場合、3番目及び4番目の引数は
%             時間として解釈されます。
%
%   RefEndTimes   - RefRates に対応するインターバルの終点となる時間を
%                   期間単位で示す NREFPTS 行1列のベクトルです。
%
%   RefStartTimes - RefRates に対応するインターバルの始点となる時間を
%                   期間単位で示す NREFPTS 行1列ベクトルです。
%                   RefStartTimes は、オプションの引数で、デフォルト値は
%                   0です。
%
%   EndTimes      - 割引が適用されるインターバルの終点となる時間を期間
%                   単位で示す NPOINTS 行1列のベクトルです。
%
%   StartTimes    - 割引が適用されるインターバルの始点となる時間を期間
%                   単位で示す NPOINTS 行1列のベクトルです。StartTimes は
%                   オプションの引数で、デフォルト値は0です。
%
%   使用法 2:ValuationDate が省略された場合、3番目及び4番目の引数は日付
%            として解釈されます。 日付 ValuationDate は、時間を計算する
%            際のゼロ座標として用いられます。
%
%   RefEndDates   - RefRates に対応するインターバルの終点となる満期日を
%                   シリアル日付形式で示すスカラ値、または、NREFPTS 行
%                   1列のベクトルです。
%
%   RefStartDates - RefRates に対応するインターバルの始点となる日付を
%                   シリアル日付形式で示すスカラ値、または、NREFPTS行1列
%                   のベクトルです。RefStartDates は、オプションの引数で
%                   デフォルト値は、ValuationDate と等値です。
%
%   EndDates      - 希望する利率となる新しいインターバルの終点となる
%                   満期日をシリアル日付形式で示すスカラ値、または、
%                   NPOINTS行1列のベクトルです。
%
%   StartDates    - 希望する利率となる新しいインターバルの始点となる日付
%                   をシリアル日付形式で示すスカラ値、または、NPOINTS行
%                   1列のベクトルです。StartDates はオプションの引数で、
%                   デフォルト値は ValuationDate と等値です。
%
%   ValuationDate - StartDates と EndDates で入力された投資限界の観測日
%                   (observation date)をシリアル日付形式で示すスカラ値で
%                   す。ValuationDate は使用法2では必須となります。一方
%                   使用法1では、ValuationDate は省略するか、空行列に
%                   よって入力をパスしなければなりません。
%
% 出力:
%   Rates         - 基準利率構造によって暗示され、新しいインターバルで
%                   サンプリングされる利子率を示す NPOINTS x NCURVES の
%                   列ベクトルです。
% 
%   StartTimes    - 希望する利率となる新しいインターバルの始点となる時間
%                   を示す NPOINTS 行1列の列ベクトルです。なお、この時間
%                   は、期間単位で測定されます。
%
%   EndTimes      -  希望する利率となる新しいインターバルの終点となる
%                    時間を示す NPOINTS 行1列の列ベクトルです。なお、
%                    この時間は、期間単位で測定されます。
%  
% 注意：
% Compounding = 365 (daily)の場合、 StartTimes と EndTimes は、日単位で
% 測定されます。それ以外の場合、この引数は、SIA 半年タイムファクタ Tsemi
% から、公式 T = Tsemi/2 * F によって計算された値を含むことになります。
% ここで、F は複利計算の頻度を示しています。たとえば、連続複利の場合、
% F は1に設定されます。
%
% 投資インターバルは、入力された時間 (使用法 1)、または、入力された日付
% (使用法 2)のいずれかによって指定できます。引数 ValuationDate が入力
% されると、日付解釈が呼び出され、引数 ValuationDate が省略されると、
% デフォルトの時間解釈が呼び出されることになります。
%
% 例題:
%   1)基準環境が、6、12、24ヶ月時点でのゼロ率の集合であるとします。時間
%     0、6、12ヶ月にスタートする1年フォワード利率の集合を出力します。
%
%   RefRates = [0.05; 0.06; 0.065];
%   RefEndTimes = [1; 2; 4];
%   StartTimes = [0; 1; 2];
%   EndTimes   = [2; 3; 4];
%   Rates = ratetimes(2, RefRates, RefEndTimes, 0, EndTimes, StartTimes)
% 
%   2)異なる日付にゼロ利回り曲線を内挿します。ゼロ曲線は、ValuationDate 
%     のデフォルトの日付にスタートします。
%
%   RefRates = [0.04; 0.05; 0.052];
%   RefDates = [729756; 729907; 730121];
%   Dates    = [730241; 730486];
%   ValuationDate   = 729391;
%   [Rate] = ratetimes(2, RefRates, RefDates, [], Dates, [],....
%              ValuationDate)
%
% 参考 : RATE2DISC, DISC2RATE.


%   Author(s): J. Akao 12/15/98
%   Copyright 1995-2002 The MathWorks, Inc. 
