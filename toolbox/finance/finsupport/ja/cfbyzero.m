% CFBYZERO   1組のゼロ曲線群によりキャッシュフローの価格決定
%
%   Price = cfbyzero(RateSpec, CFlowAmounts, CFlowDates, Settle)
%
%   Price = cfbyzero(RateSpec, CFlowAmounts, CFlowDates, ...
%                              Settle, Basis)
%
% 入力(必須): キャッシュフロー引数の詳細については、"help instcf" を
%             タイプしてください。
%
%   RateSpec     - 年率換算された 年率換算されたゼロ利率構造体です。
%
%   ZeroRates    - 10進法で示されたゼロ率の NPOINTS 行 NCURVES 列の行列
%                  です。たとえば、5%はゼロ率では 0.05となります。ゼロ率
%                  は、0から EndTime までの利回りです。
%
%   CFlowAmounts - キャッシュフローの額で構成されるNINST行MOSTCFS列の
%                  行列です。
%   CFlowDates   - キャッシュフロー日付の NINST 行 MOSTCFS 列の行列です。
%   Settle       - 決済日。この日付にキャッシュフローの価格が決定され
%                  ます。
%
% オプション入力：
%   Basis        - 日付のカウント基準。デフォルトは0です。(actual/actual)
%
% 出力:
%   Price        - 時間0における期待価格からなる NINST 行1列の行列です。
%                  行列の各列がそれぞれ１つのゼロ曲線に対応しています。
%
% 参考 : BONDBYZERO, FIXEDBYZERO, FLOATBYZERO, SWAPBYZERO.


%   Author(s): J. Akao 25-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
