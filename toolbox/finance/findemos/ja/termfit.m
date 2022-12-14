% TERMFIT   クーポン債の価格から円滑化ゼロ曲線を近似
%
% [ZeroRates, CurveDates, BootZeros, BootDates, BreakDates] = termfit(...
%     Smoothing, Bonds, Prices, Settle, ...
%         OutputCompounding, OutputBasis, CurveDates, BreakDates)
%
% 詳細：
% TERMFIT は、1組の債券の市場価格によって示唆される利率構造に平滑化した
% 曲線を適合させます。この適合利率構造は、債券の価格を正確に決定すること
% はありませんが、市場価格におけるいくつかのノイズを推定することができま
% す。SMOOTHING パラメータは、ゼロ曲線の円滑さと入力された債券の価格決定
% における誤差との間にみられるトレードオフを調整します。
% 
% 入力: 
%    Smoothing   - スカラ値, 0 <= Smoothing <= 1, 平滑化の度合いを適用す
%                  るかを指定します。
%             Smoothing = 0 は、債券の価格決定における誤差を最小にします。
%             Smoothing = 1 は、直線近似します。
%
%    Bonds       - ゼロ曲線が導出されるクーポン債のポートフォリオです。
%                  特に、債券パラメータの N 行 M 列の行列となり、各行は
%                  個々の債券に対応し、各列は特定のパラメータに対応して
%                  います。この行列に必須となる列(パラメータ)は、つぎの
%                  通りです。
%    Maturity    - (列 1)ポートフォリオの各債券に対する満期日。シリアル
%                  日付番号で表示します。
%    CouponRate  - (列 2)ポートフォリオの各債券に対するクーポンレート。
%                  10進数で表示します。
% 
% なお、オプションの列(パラメータ)は、つぎの通りです。
%    Face        - (列3)ポートフォリオの各債券の額面価値。デフォルトは
%                  $100です。
%    Period      - (列4)年あたりのクーポン支払い回数で、整数で表示されま
%                  す。取り得る値は 1, 2 (デフォルト), 3, 4, 6, 12です。
%    Basis       - (列5)ポートフォリオの各債券に対して適用される日数カウ
%                  ント基準を示す値です。取り得る値はつぎの通りです。
%               1)Basis = 0 - actual/actual(デフォルト)
%               2)Basis = 1 - 30/360
%               3)Basis = 2 - actual/360
%               4)Basis = 3 - actual/365
%    EndMonthRule - (列 6)ポートフォリオを構成する各債券に対して月末規則
%                   を適用するかしないかを指定する値です。取り得る値は、
%                   つぎの通りとなります。
%               1)EndMonthRule = 1(デフォルト)
%                     債券に対する月末規則は有効です(すなわち、月の末日
%                     にクーポン利払いを行う債券は、常に月の末日に支払い
%                     を行うことになります)。
%               2)EndMonthRule = 0 
%                     月末規則は債券に対して無効となっています。
%
%    Prices      -  Bonds 行列によって示されるポートフォリオを構成する
%                   各債券に対する価格値を示す N 行1列の列ベクトルです。
%    Settle      -  ゼロ曲線が求められる際の0時点を示すスカラ値。通常 
%                   この値は、ゼロ曲線を導出するポートフォリオを構成する
%                   債券の決済日となります。
%
%    OutputCompounding - 
%                   (オプション)出力されるゼロ利率を年率に換算するときに
%                    どのくらいの割合で複利計算を行うかを示すスカラ値。
%                    デフォルト値は、半年複利計算(2)です。
%
%    OutputBasis - 出力されるゼロ利率を年率に換算するときにどの日数カウ
%                  ント基準を用いるかを示すスカラ値。入力できる値は、つ
%                  ぎの通りです。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%    CurveDates  - 近似するゼロ率を示すシリアル日付の NumOut 行1列の列ベ
%                  クトルです。デフォルトでは、ポートフォリオを構成する
%                  いくつかの債券がキャッシュフローを有する日付で設定さ
%                  れます。
%    BreakDates  - 決済日と満期までが最も長い債券の満期日との間の日付か
%                  らなるNumBreaks 行1列の列ベクトルです。瞬時のフォワード
%                  曲線は、BreakDates 間の間隔で区分的に3次関数(cubic)と
%                  なります。決済日と満期までの期間が最も長い債券の満期日
%                  は、BreakDates に入力されていない場合でも自動的に節点群
%                  に加えられます。
%
% 出力：
%    ZeroRates  - 満期日によって定義された所有期間上の各点に対する近似
%                 ゼロ率の値からなる NumOut 行1列のベクトルです。
%    CurveDates - 所有期間上の各ゼロ率に対する満期日からなるNumOut行1列
%                 のベクトルです(所有期間は、T = Settle で定義された時間
%                 と源泉ポートフォリオを構成する債券の中で満期までの期間
%                 が最も長い債券の満期日 T = maturity までの期間として
%                 定義されます)。
%    BootZeros  - 入力されたポートフォリオの価格を正確に決定する債券満期
%                 日時のブートストラップゼロ率からなる NumBoot 行1列のベ
%                 クトルです。BootZores 曲線には、スムーシングは全く適用
%                 していません。ブートストラップ法の詳細については、
%                 ZBTPRICE を参照してください。
%    BootDates  - ブートストラップゼロ曲線の満期日からなる NumBoot 行1列
%                 のベクトルです
%    BreakDates - フォワード曲線のスプライン表示の構築に用いられる節点ベ
%                 クトルです。
%
% 注意： 
% TERMFIT は、フォワード利率曲線に対して、円滑な三次スプライン曲線を適合
% させます。適切な曲線が得られるかどうかは、引数 SMOOTHING の値とキュー
% ビック断面間の節点の設定に依ります。特定のデータセットに対して、パラ
% メータ設定は、実験による試行錯誤が必要です。
%
% このプログラムに組み込まれているカーブフィッテングモデルは、
% Mark Fisher, Douglas Nychka and David Zervos が、つぎの文献の中で紹介
% しているものです。
%
% 参考文献：Finance and Economics Discussion Series Working 
%           Paper # 95-1, published by the Division of Research and 
%           Statistics, Division of Monetary Affairs, Federal Reserve
%           Board, Washington, D.C.
%
%
%         この関数の実行にはスプラインツールボックスが必要です。
%
% 参考 : ZBTPRICE, ZBTYIELD, ZERO2FWD, FWD2ZERO, ZERO2DISC, DISC2ZERO,
%        ZERO2PYLD PYLD2ZERO.


%   Author(s): D. Eiler, 02-12-97, J. Akao 12/01/97
%   Copyright 1995-2002 The MathWorks, Inc.  
