% BDTBOND   Black-Derman-Toyモデルによるオプションが組み込まれた債券の
%           価格
%  
% コール、または、プットオプションが組み込まれた債券の価格及び感応度を
% 計算します。債券の評価は、Black-Derman-Toyモデルに基づいて行われます。
% このモデルは、投入利回り曲線(あるいは信用格差)とボラティリティ曲線
% から金利オプションの価格決定を行うためのモデルです。
%
%  [Price, Sensitivities, DiscTree, PriceTree] = ....
%               bdtbond(OptBond, ZeroCurve, VolatilityCurve,...
%               Accuracy, CreditCurve, ComputeSensitivity)
%
% Accuracy 以外の引数は、構造体となっています。引数変数の名称を置き換える
% ことはできますが、フィールド名は厳密に同じものを用いなければなりません。
% 変数及びフィールドは以下の変数、フィールド名書式の順番でリストアップ
% されています。オプションフィールド、または、変数については、空行列 [] 
% に設定すると、デフォルト値が呼び出されます。なお、構造体のオプションの
% フィールドについては、未設定のままでも構いません。
%
% 入力:
% OptBond : (必須)可能なコール、プットオプションをもつ対象債券。
%           フィールドは、スカラ、または、日付文字列です。
%
%     対象証券に対して詳細設定を行うフィールドです。債券パラメータに
%     関する詳細については、当該パラメータ名＋FTBによって呼び出される
%     ヘルプを参照してください。
%
%    - OptBond.Settle          :  (必須)決済日
%    - OptBond.Maturity        :  (必須)満期日
%    - OptBond.Period          :  (必須)クーポン支払いの頻度。
%                                  デフォルトは2
%    - OptBond.Basis           :  (オプション)市場日付カウント基準。
%                                  デフォルトは0 (actual/actual)
%    - OptBond.EndMonthRule    :  (オプション)月末規則。デフォルトは1
%                                  (有効)
%    - OptBond.FirstCouponDate :  (オプション)最初のクーポン期間が不定期
%                                  の場合に支払われる最初のクーポン支払
%    - OptBond.LastCouponDate  :  (オプション)最後のクーポン期間が不定期
%                                  の場合に支払われる最後のクーポン支払
%    - OptBond.IssueDate       :  (オプション)最初のクーポン期間が不定期
%                                  の場合の債券の発行日
%    - OptBond.StartDate       :  (オプション)決済前でない場合の債券の先
%                                  スタート日
%    - OptBond.CouponRate      :  (オプション)クーポンレート(利札利率)
%    - OptBond.Face            :  (オプション)債券の満期時支払い。
%                                  デフォルトは100
% 
%      オプションとなる債券の詳細指定フィールド：
%      コール、または、プットに関するフィールドの設定を行うこともでき
%      ます。コールは、債券の発行者によって行われると想定され、プットは
%      債券の所有者によって行われると想定されます。そのため、コールは
%      債券所有者に対する債券の価値を低めることにつながりますが、プットは
%      債券の価値を高めることになります。
%
%    - OptBond.CallStrike     : (必須)コールオプション権利行使価格
%    - OptBond.CallType       : (オプション)フラグ1(米国)、または、0 
%                                (欧州)。デフォルトは欧州オプション 
%                                (CallType = 1)です。
%    - OptBond.CallExpiryDate : (オプション)米国オプションの権利行使の
%                                最終期限日。または、欧州オプションの場合
%                                権利行使が可能となる唯一の日付。デフォ
%                                ルトは、債券の満期日となっています。
%    - OptBond.CallStartDate  : (オプション)米国オプションの権利行使が
%                                最初に可能となる日付。デフォルトでは、
%                                債券の決済日となっています。
%    - OptBond.PutStrike      : (必須)プットオプション権利行使価格
%    - OptBond.PutType        : (オプション)フラグ1(米国)、または、0 
%                                (欧州)。デフォルトでは米国オプションと
%                                なっています(PutType = 1)。
%    - OptBond.PutExpiryDate  : (オプション)米国オプションの権利行使の
%                                最終期限日。または、欧州オプションの場合
%                                権利行使が可能となる唯一の日付。デフォ
%                                ルトでは債券の満期日となっています。
%    - OptBond.PutStartDate   : (オプション)米国オプションの権利行使が
%                                最初に可能となる日付。デフォルトでは債券
%                                の決済日となっています。
%  
%  ZeroCurve : (必須)1組の NCURVE(date, decimal rate)で示される利回り曲線
%              が債券の時間的スパンをカバーするために内挿されます。最初の
%              曲線の日付より前の時間では、最初のレートが使用され、最後の
%              曲線の日付より後の時間では、最後のレートが使用されます。 
%    - ZeroCurve.CurveDates : (必須)[NCURVE 行1列の行列] 満期日のベクトル
%                             日付は日付文字列、または、シリアル日付番号
%                             です。
%    - ZeroCurve.ZeroRates  : (必須)[NCURVE 行1列の行列] レートのベクトル
%
%  VolatilityCurve : (必須)短期レートの瞬間ボラティリティ曲線。この曲線
%                    は、1組の NCURVE2(date, decimal rate)で構成され、
%                    債券の時間的スパンをカバーするために内挿されます。  
%    - VolatilityCurve.CurveDates      : (必須)[NCURVE2 行1列の行列]日付
%                                         のベクトル
%    - VolatilityCurve.VolatilityRates : (必須)[NCURVE2 行1列の行列] 
%                                         10進法表記の年間ボラティリティの
%                                         ベクトル
%
%  Accuracy    : (必須)この引数は、構造体ではありません。スカラ値 Accuracy
%                は、半年払いのクーポン期間ごとにツリーのステップがいくつ
%                進むかを指定する引数です。より大きな値を割り当てるほど、
%                出力される解は、より正確なものとなりますが、その一方で
%                時間とメモリをより多く使うことになります。
%
%  CreditCurve : (オプション)デフォルトのリスクから生じるゼロ率スプレッド
%                曲線。この曲線は1組の NCURVE3(date, basis point)で構成
%                され、債券の時間的スパンをカバーするために内挿されます。
%    - CreditCurve.CurveDates  : (必須)[NCURVE3 行1列の行列] シリアル
%                                日付番号、または、日付文字列のベクトル
%    - CreditCurve.CreditRates : (必須)[NCURVE3 行1列の行列] ベーシス
%                                ポイントにおける信用格差の値(10進数の
%                                レートではありません)を示すベクトル。
%                                ゼロ率への変更を効率的に行う方法は、
%                                CreditRates/10000です。
%
%  ComputeSensitivity : (オプション) (オプション付き及びオプションなし)
%                       債券の感応度測度の計算を行うかどうかを指定します。
%                       フィールドに1の値を入力すれば、感応度測度は計算
%                       され、0の値を入力すれば、測度は計算されません。
%                       感応度は、有限の差分計算によって算出されます。
%                       デフォルトでは感応度は計算されず、価格のみが出力
%                       されます。
%    - ComputeSensitivity.Duration : (必須)スカラ 1、または、0
%    - ComputeSensitivity.Convexity: (必須)スカラ 1、または、0
%    - ComputeSensitivity.Vega     : (必須)スカラ 1、または、0
%
%  出力:
%  価格 : オプション付き債券及びオプションなし債券の価値
%    - Price.OptionFreePrice  : 何らのオプションも付けられていない債券の
%                               価格(スカラ)
%    - Price.OptionEmbedPrice : オプション付き債券のスカラ値で示された
%                               価格(債券の保有者にとっての価値)
%    - Price.OptionValue      : オプションの債券所有者にとっての価値
%                               (スカラ)
%     
%  感応度
%    - Sensitivities.Duration     : 利回り曲線の平行移動に対するオプション
%                                   フリー債券の感応度   
%    - Sensitivities.EffDuration  : 利回り曲線のシフトに対するオプション
%                                   組み込み価格の感応度
%    - Sensitivities.Convexity    : 利回り曲線のシフトに対するデュレー
%                                   ションの感応度
%    - Sensitivities.EffConvexity : 利回り曲線のシフトに対する Eff デュ
%                                   レーションの感応度
%    - Sensitivities.Vega         : ボラティリティ曲線の平行移動に対する
%                                   オプション組み込み価格の感応度
%
% 割引ツリー : 利率構造の二項ツリーを再結合。このツリーは、決済から満期
% までの時間 NPERIODS をカバーし、各クーポン期間毎に、Accuracy で指定
% されたステップ数だけ進みます。決済時点及び決済と最初の支払い間の短期
% レートは、あらかじめ決定されています。
%  
%    - DiscTree.Values   : 短期割引ファクタの [NSTATES行NPERIODS列]の
%                          行列です。NPERIODS列は、連続する時間に対応し
%                          ています。一方、NSTATES 行は、利率プロセスの
%                          状態に対応しています。値が入力されていない
%                          状態は、NaN 値でマスクされています。
%  
% 時点 Dates(i) における現金の額と割引 Values(j,i)とを掛け合わせることに
% より、ツリーのエッジ (j,i)と交差した後の Dates(i-1)における価格を求める
% ことができます。ツリーのノード (j,i)における短期レート R(j,i)は、つぎの
% 式を満たします。
% 
%      (1+ R(j,i)/Frequency)^(-(Times(j)-Times(j-1)))= Values(j,i)
% 
%    - DiscTree.Times     : [1 行 NPERIODS 列]クーポン期間単位でのツリー
%                           ノードタイムのベクトル(ftbTFactors 参照)
%    - DiscTree.Dates     : [1 行 NPERIODS 列]シリアル日付番号で示された
%                           ツリーノードタイムのベクトル
%    - DiscTree.Type      : 短期割引
%    - DiscTree.Frequency : 投入債券の複利頻度(compounding frequency)
%    - DiscTree.ErrorFlag : (0、または、1)、1に設定すると短期レートが
%                           負となります。
%
%  PriceTree : ツリーノードでの現金総額を表す二項ツリーを再結合。価格
%  ツリーは、債券キャッシュフロー及びオプションペイオフから計算されます。
%  債券のクリーン価格は、Price Tree Value からクーポン支払い及び経過利子
%  を差し引くことによって計算できます。
%    - PriceTree.Values [NSTATES 行 NPERIODS 列] 価格状態を示す行列
%    - PriceTree.Times   : [1行NPERIODS列] クーポン期間単位でのツリー
%                          ノードタイムのベクトル(ftbTFactors 参照)
%    - PriceTree.Dates   : [1行NPERIODS列] シリアル日付番号で表示された
%                          ツリーノードタイムのベクトル
%    - PriceTree.AccrInt : [1行NPERIODS列] 各時点で支払われるべき経過
%                          利子のベクトル
%    - PriceTree.Coupons : [1行NPERIODS列] 各時点におけるクーポン支払い
%                          のベクトル
%    - DiscTree.Type     : 'Price'
%
% 参考 : BDTTRANS.


%   Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
