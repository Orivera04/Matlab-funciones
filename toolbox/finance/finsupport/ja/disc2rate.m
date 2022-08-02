% DISC2RATE   キャッシュフロー割引ファクタを利率に換算
%
% NPOINTS の時間間隔に渡って、設定したキャッシュフロー割引から利回りを
% 計算します。NCURVES 個の異なる利率曲線は、それらの利率曲線が同一の時間
% 構造を持つ場合に限り、一度に変換することができます。インターバルは、
% ゼロ曲線、または、フォワード曲線で表示することも可能です。
%
% 使用法 1: インターバルポイントは、期間単位表示の時間で入力します。
%   [Rates] = disc2rate(Compounding, Disc, EndTimes, StartTimes)
%   [Rates] = disc2rate(Compounding, Disc, EndTimes)
%
% 使用法 2: ValuationDate は省略できます。また、インターバルポイントは
%           日付で入力します。
%   [Rates, EndTimes, StartTimes] = disc2rate(Compounding, Disc, ... 
%     EndDates, StartDates, ValuationDate)
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
%   Disc        - 割引を示す NPOINTS x NCURVES のベクトルです。Disc は、
%                 キャッシュフローが評価される StartTimes から、キャッ
%                 シュフローの受取日である EndTimes を終点とするインター
%                 バルに対する単位債券価格です。
%
%   使用法1: ValuationDate が省略されなかったケースでは、3番目及び4番目
%            の引数は時間として解釈されます。
%
%   EndTimes    - 割引が適用されるインターバルの終点となる時間を期間単位
%                 で示す NPOINTS 行1列のベクトルです。
%
%   StartTimes  - 割引が適用されるインターバルの始点となる時間を期間単位
%                 で示す NPOINTS 行1列のベクトルです。StartTimes はオプ
%                 ションの引数で、デフォルト値は0です。
%
%   使用法 2 : ValuationDate が省略された場合、3番目及び4番目の引数は日
%              付として解釈されます。 日付 ValuationDate は、時間を計算
%              する際のゼロ点として用いられます。
%
%   EndDates    - 割引が適用されるインターバルの終点となる満期日をシリア
%                 ル日付形式で示すスカラ値、または、NPOINTS 行1列のベク
%                 トルです。
%
%   StartDates  - 割引が適用されるインターバルの始点となる日付をシリアル
%                 日付形式で示すスカラ値、または、NPOINTS 行 1列のベクト
%                 ルです。StartDates はオプションの引数で、デフォルト値
%                 は ValuationDate です。
%
%   ValuationDate - 
%                 StartDates と EndDates で入力された投資限界の観測日
%                 (observation date)をシリアル日付形式で示すスカラ値で
%                 す。ValuationDate は、使用法2では必須となります。一
%                 方、使用法1では、ValuationDate は省略するか、空行列
%                 によって入力をパスしなければなりません。
%
% 出力:
%   Rates       - NPOINTS 回の時間インターバルに対応する利回りを示す 
%                 NPOINTS x NCURVES の行列です。
% 
%   StartTimes  - 割引が適用されるインターバルの始点となる時間を示す 
%                 NPOINTS 行 1列の列ベクトルです。そして、この時間は、
%                 期間単位で測定されます。
%
%   EndTimes    -  割引が適用されるインターバルの終点となる時間を示す 
%                  NPOINTS 行 1列の列ベクトルです。そして、この時間は、
%                  期間単位で測定されます。
%  
% 注意：
% Compounding = 365 (毎日複利)の場合、 StartTimes と EndTimes は、日単位
% で測定されます。それ以外の場合、この引数は、SIA 半年タイムファクタ 
% Tsemi から、公式  T = Tsemi/2 * F によって計算された値を含むことに
% なります。ここで、F は複利計算の頻度を示しています。たとえば、連続複利
% の場合、F は1に設定されます。
%
% 投資インターバルは、入力された時間(使用法 1)、または、入力された日付
% (使用法 2)のいずれかに指定できます。引数 ValuationDate が入力されると
% 日付解釈が呼び出され引数 ValuationDate が省略されると、デフォルトの
% 時間解釈が呼び出されることになります。
%
% 参考 : RATE2DISC, RATETIMES.


%   Author(s): J. Akao 11/03/98
%   Copyright 1995-2002 The MathWorks, Inc. 
