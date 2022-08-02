% INTENVGET   利子期間構造の属性を取得
%
%   ParameterValue = intenvget(RateSpec , 'ParameterName')
%
% 入力:
%   RateSpec       - 利子期間構造の属性を簡約して作成された構造
%
%   ParameterName  - アクセス対象となるパラメータ名を示す文字列です。
%                    ここで、指定されたパラメータの値が構造 RateSpec 
%                    より抽出されます。パラメータ値が、RateSpec で指定
%                    されていない場合、空行列が出力されます。パラメータ名
%                    の先頭の数文字をタイプするだけで、パラメータを十分
%                    特定することができます。なお、パラメータ名での
%                    大文字、小文字の区別は無視されます。
%
%  INTENVGETのパラメータ名は、つぎの通りです。
%     Compounding 
%     Disc
%     Rates 
%     EndTimes
%     StartTimes
%     EndDates
%     StartDates
%     ValuationDate
%     Basis
%     EndMonthRule
%
% 出力:
%   ParameterValue - 構造 RateSpec から抽出された ParameterName で指定
%                    するパラメータの値。パラメータ値が、RateSpec で指定
%                    されていない場合、空行列を出力します。
%
% 例題:
%   [RateSpec] = intenvset('Rates', 0.08, 'EndTimes', 2)
%   R = intenvget(RateSpec, 'Rates')
%   [R, RateSpec] = intenvget(RateSpec, 'Rates')
%
% 参考 : INTENVSET.


%   Author(s): M. Reyes-Kattar 02/08/99
%   Copyright 1995-2002 The MathWorks, Inc. 
