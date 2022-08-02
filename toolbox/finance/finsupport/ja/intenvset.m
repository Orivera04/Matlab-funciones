% INTENVSET   利子期間構造の属性を設定
%
%   [RateSpec, RateSpecOld] = intenvset('Parameter1', Value1 , ...
%       'Parameter2' , Value2 , ...)
%   [RateSpec, RateSpecOld] = intenvset(RateSpec , ....
%             'Parameter1' , Value1 , ...)
%
% 最初の使用法は、入力引数リストがパラメータと値の組で指定されている利子
% 期間構造(RateSpec)を生成します。パラメータ/値の組を構成するパラメータ
% 部は、出力構造 RateSpec の適切なフィールドとして認識されなければなり
% ません。なお、パラメータ/値の組を構成する値の部分は、このとき指定された
% パラメータが、指定された値をもつような形で、ペアを組むパラメータに割り
% 当てられています。なお、パラメータ名の先頭の数文字をタイプするだけで、
% パラメータを十分特定することができます。パラメータ名での大文字、小文字
% の区別は無視されます。適切なパラメータのフィールドのリストは、以下を
% 参照してください。
%
% 二番目の使用法は、指定されたパラメータを指定した値に変更することに
% よって、既存の利子期間構造 RateSpec を修正する際に用いるものです。
%   
% 入力引数及び出力引数を何ら伴わない形で、intenvset をコールした場合、
% 全てのパラメータ名とそれらのパラメータが取り得る値に関する情報を表示
% します。
%
% 入力:
%   Parameter    - 出力構造 RateSpec に適切なパラメータフィールド(以下を
%                  参照のこと)を表示する文字列です。
%   Value        - 対応するパラメータに割り当てられた値です。
%   RateSpec     - 変更の対象となる既存の利子期間構造です。おそらくこの
%                  利子期間構造は、INTENVSET を事前に実行したときに生成
%                  されたものであると考えられます。
%
%   INTENVSETのパラメータ名は次の通りです。
%   Compounding  - 年率換算時に、入力されたゼロ率をどのような度数で複利
%                  計算するかを示すスカラ値です。デフォルトは2です。
%     Disc       - StartDates(キャッシュフローの価格が決定される日付)か
%                  ら EndDates(キャッシュフローが受け取られる)までの投資
%                  区間における単位債券価格を示すNPOINTS 行NCURVES列の
%                  行列です。 
%     Rates      - 小数型で入力するNPOINTS 行 NCURVES列の行列です。Rates
%                  は、StartDates(キャッシュフローの価格が決定される日付)
%                  から EndDates(キャッシュフローが受け取られる)までの
%                  投資区間における利回りです。
%     EndDates   - 割引が適用される区間が終わる満期日を示すNPOINTS行1列
%                  ベクトル、または、スカラです。
%     StartDates - 割引が適用される区間が始まる日付を示すNPOINTS行1列
%                  のベクトル、または、スカラです。
%     ValuationDate  - 
%                  StartDates と EndDates で入力された投資限界の観測日
%                  (observation date)をシリアル日付形式で示すスカラ値で
%                  す。デフォルトは min(StartDates)です。
%     Basis      - 日数のカウント基準です。デフォルトは"0" 
%                  ( Actual/Actual)
%     EndMonthRule  - 
%                  月末規則です。デフォルトは"1" (月末規則は有効)
%
% 新しいRateSpecを生成するとき、intenvsetに受け継がれるパラメータの組に
% は、必ずStartDates, EndDates及びRates、または、Discのいずれかが含まれ
% なければなりません。
%
%% 出力：
%   RateSpec    - 利子期間構造の属性を簡約する形で作られた構造です。
%   RateSpecOld - INTENVSET の実行によって変更が加えられる以前の利子期間
%                 構造の属性を簡約した構造です。
%
% 例題:
%   [RateSpec] = intenvset('Rates', 0.05, 'StartDates', ....
%                '20-Jan-2001', 'EndDates', '20-Jan-2001')
%   [RateSpec] = intenvset(RateSpec, 'Compounding', 1)
% 
% 注意:
% 入力引数及び出力引数を割り当てずにintenvsetを呼び出すと、全てのパラ
% メータ名とそれらのとりうる値に関する情報を表示します。
%
% 参考 : INTENVGET.


%   Author(s): M. Reyes-Kattar, J. Akao 02/08/99
%   Copyright 1995-2002 The MathWorks, Inc. 
