% TICK2RET   価格時系列から増加収益時系列を出力
%
% この関数は、NASSETS 個の資産の価格の NUMOBS 個の観測値間で実現される
% 資産収益を計算します。
% 
% [RetSeries, RetIntervals] = tick2ret(TickSeries, TickTimes)
%  
% 入力:
%    TickSeries   : 自己資産価格の NUMOBS 行 NASSETS 列の行列。最初の行
%                   は、資産の当初価格で、最後の行は最後の(最も新しい)
%                   観測値を示しています。
%    TickTimes    : (オプション)観測時間の NUMOBS 行1列の増加ベクトル。
%                   時間は数値で示された、シリアル日付番号(日単位)、また
%                   は、任意の単位(年など)で示される10進数のいずれかで
%                   入力します。
%
% 出力：
%    RetSeries    : 増加収益の観測値からなる NUMOBS-1 行 NASSETS 列の行
%                   列です。i 番目の収益は、TickTimes(i)から TickTimes
%                   (i+1)の期間に生じたもので、年間収益へのスケーリング
%                   は、適用されません。
% 
%                   RetSeries(i)= TickSeries(i+1)/TickSeries(i)- 1;
%
%    RetIntervals : (オプション)観測値間の時間間隔のスカラ値、または、
%                   NUMOBS-1 行1列のベクトルです。引数 TickTimes に指定
%                   がないときは、全ての間隔が長さ1であると仮定されます。
%
% 参考 : RET2TICK, EWSTATS.


%   Author(s): J. Akao 3/24/98
%   Copyright 1995-2002 The MathWorks, Inc.  
