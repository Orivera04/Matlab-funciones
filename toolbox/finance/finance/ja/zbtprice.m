% ZBTPRICE   与えられた価格に対して、クーポン債データからゼロ曲線をブート
%            ストラップ法により出力
%
%        [ZeroRates, CurveDates] = zbtprice(Bonds, Prices, Settle, ....
%                OutputCompounding, OutputBasis, MaxIterations)
%
% 詳細： 
% この関数は、クーポン債の元のポートフォリオの基本パラメータと価値から、
% 「ブートストラップ」法を用いてゼロ曲線を導出します。ゼロ曲線は、理論上
% のゼロクーポン債のポートフォリオの満期利回りを総体的にとらえたものとし
% て定義されます。つまり、理論上のクーポン債は、元となるポートフォリオか
% ら導出されたものです。この関数が用いるブートストラップ法は、元のポート
% フォリオを構成する債券のキャッシュフロー日付間の整合性を必要としません。
% その代わり、ブートストラップ法は、全てのゼロ率を導出するために、理論上
% の額面債券裁定(arbitrage)及び利回りの内挿を使用します。
%
% 入力:
%    Bonds        - ゼロ曲線が導出されるクーポン債のポートフォリオです。
%                   詳しくは、債券パラメータの N 行 M 列の行列となり、こ
%                   の行列の各行は個々の債券に対応しており、各列は特定の
%                   パラメータに対応しています。この行列に必須となる列
%                   (パラメータ)は、つぎの通りです。
%    Maturity     - (列 1)ポートフォリオの各債券に対する満期日。シリアル
%                   日付番号で表示します。
%    CouponRate   - (列 2)ポートフォリオの各債券に対するクーポンレートを
%                   10進数で表示します。
% 
% なお、オプションの列(パラメータ)は、つぎの通りです。
%    Face         - (列3)ポートフォリオの各債券の額面価値。デフォルトは
%                   $100です。
%    Period       - (列4)年あたりのクーポン支払い回数です。整数で表示さ
%                   れます。取り得る値は 1, 2 (デフォルト), 3, 4, 6,12 
%                   のいずれかを設定します。
%    Basis        - (列5)ポートフォリオの各債券に対して適用される日数カ
%                   ウント基準を示す値です。取り得る値は、つぎの通りです。
%               1)Basis = 0 - actual/actual(デフォルト)
%               2)Basis = 1 - 30/360
%               3)Basis = 2 - actual/360
%               4)Basis = 3 - actual/365
%    EndMonthRule - (列 6)ポートフォリオを構成する各債券に対して月末規則
%                   を適用するかしないかを指定する値です。取り得る値は、
%                   つぎの通りとなります。
%               1)EndMonthRule = 1(デフォルト) 債券に対する月末規則は有
%                                効です(すなわち、月の末日にクーポン利払
%                                いを行う債券は、常に月の末日に支払いを
%                                行います)。
%               2)EndMonthRule = 0 
%                                月末規則は債券に対して無効となります。
%     Prices       -  Bonds 行列によって示されるポートフォリオを構成する
%                     各債券に対する価格値を示す N 行1列の列ベクトルです。
%     Settle       - ゼロ曲線が求められる際の0時点を示すスカラ値。通常、
%                    この値は、ゼロ曲線を導出するポートフォリオを構成す
%                    る債券の決済日となります。
%     OutputCompounding - 
%                    (オプション)出力されるゼロ利率を年率に換算するとき
%                    にどのくらいの割合で複利計算を行うかを示すスカラ値。
%                    デフォルトは半年複利計算(2)です。
%
%      OutputBasis  - (オプション)出力されるゼロ利率を年率に換算するとき
%                     にどの日数カウント基準を用いるかを示すスカラ値。入
%                     力できる値は、つぎの通りです。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%      MaxIterations - Bonds 行列を構成する各債券の満期日までの利回りを
%                      求める際に用いられる反復回数の最大値を設定するス
%                      カラ値。デフォルトは50です。
%
% 出力:     
%      ZeroRates     - 満期日により定義される所有期間内の各時点における
%                      内在的ゼロ率を示す値で構成される N 行1列の列ベク
%                      トル
%      CurveDates    - 所有期間内の各ゼロ率の満期日で構成される N 行1列
%                      の列ベクトル(源泉ポートフォリオを構成する決済から
%                      満期までの期間が最も長い債券のT=決済日からT=満期
%                      日までの時間が所有期間となります)。
%
%  注意： 
% 1)満期日が同一である1つ以上の債券が存在するポートフォリオの場合、平均
%   ゼロ率はその満期日に対して計算されます。
% 2)元のポートフォリオが十分な数の債券で構成されており、それらの債券が
%   満期日に関して均等に分布しているという条件を満たすことが、この関数の
%   パフォーマンスを高めることにつながります。
%
% 参考 : ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, ZERO2DISC, DISC2ZERO, 
%        ZERO2PYLD, PYLD2ZERO.


%	Author(s): J. Akao and C. Bassignani, 11-12-97 
%	Copyright 1995-2002 The MathWorks, Inc.  
