% KSTEST   1標本に対する Kolmogorov-Smirnov 適合に関する仮説検定
%
% H = KSTEST(X,CDF,ALPHA,TAIL) は、ランダム標本 X が、連続な累積分布関数 
% CDF である仮定が成り立つか否かの Kolmogorov-Smirnov(K-S)検定を行います。
% CDF はオプションです。省略するか、設定しない(たとえば、空行列 [] で
% 設定)場合、仮定した c.d.fは、標準正規分布 N(0,1) であると仮定します。
% ALPHA と TAIL もオプションのスカラ入力です。ALPHA は希望する有意水準
% (デフォルト = 0.05)で、TAIL は、検定のタイプ(デフォルト = 0)を示します。
% H は、仮説検定の結果を示します。
%      H = 0 => は、有意水準 ALPHA で帰無仮説を棄却できません。
%      H = 1 => は、有意水準 ALPHA で帰無仮説を棄却します。
% 
% S(x) を標本ベクトル X から推定した経験的な c.d.f. とします。また、
% F(x) は未知ですが、対応する真の母集団の c.d.f.とし、CDF は、帰無仮説の
% 基で設定された既知の入力の c.d.f. とします。
% 
% 帰無仮説：すべての x に対して、F(x) は、CDF に等しい。
%      TAIL =  0 (両側検定)では、対立仮説：F(x) は、CDF と等しくない。
%      TAIL =  1 (片側検定)では、対立仮説：F(x) は、CDF より大きい。
%      TAIL = -1 (片側検定)では、対立仮説：F(x) は、CDF より小さい。
%
% TAIL = 0, 1, -1 に対して、K-S 検定統計量は、それぞれ、
% T = max|S(x) - CDF|, T = max[S(x) - CDF], T = max[CDF - S(x)] です。
%
% X は、ある分布からランダムな標本を表す行ベクトルまたは列ベクトルです。
% X の欠測値は、NaN(Not-a-Number)で表し、これを無視します。
%
% CDF は、帰無仮説の基での c.d.f です。これを設定すると、(x,y)の値の組の
% 2列の行列になります。1列目には x 軸のデータ、2列目には対応する y 軸の 
% c.d.f. データが含まれます。K-S 検定統計量は、X の中の観測値に対して
% 生じているので、計算は、CDF が X の中の観測で設定される場合のみ非常に
% 有効になります。CDF の1列目は、X に独立なx-軸の点を表し、CDF は、
% ベクトル X の中の観測値で、内挿により"リサンプル"されます。この場合、
% x 軸に沿った区間は、内挿がうまく適用された X の中の観測値全体になります。
%
% [H,P] = KSTEST(...) は、漸近的な P-値 P も出力します。
%
% [H,P,KSSTAT] = KSTEST(...) は、TAIL で設定された検定タイプに対して、
% 上で設定した K-S 検定統計量 KSSTAT も出力します。
%
% [H,P,KSSTAT,CV] = KSTEST(...) は、検定の臨界値 CV も出力します。
%
% 一般に、帰無仮説を棄却する決定は、臨界値をベースにしています。CV = NaN 
% の場合、決定は、P-値をベースにしています。
%
% 参考 : KSTEST2, LILLIETEST, CDFPLOT.


% Author(s): R.A. Baker, 08/14/98
% Copyright 1993-2002 The MathWorks, Inc. 
% $Revision: 1.6 $   $ Date: 1998/01/30 13:45:34 $
