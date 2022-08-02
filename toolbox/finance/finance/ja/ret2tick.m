% RET2TICK   当初価格と増加収益から一連の価格を生成
%
% この関数は、NASSET 個の投資と NUMOBS 個の増加収益の観測値から価格を
% 生成します。
% 
% [TickSeries, TickTimes] = ....
%          ret2tick(RetSeries, StartPrice, RetIntervals, StartTime)
%  
% 入力:
%    RetSeries    : 増加収益の観測値からなる NUMOBS 行 NASSETS 列の行列
%                   です。i 番目の収益は、TickTimes(i)から TickTimes(i+1)
%                   の期間に生じたもので、年間収益へのスケーリングは
%                   なされません。
%
%    StartPrice   : (オプション)当初資産価格の1行 NASSETS 列のベクトルで
%                   す。StartPrice に指定がないときは、価格は1からスタート
%                   します。
%
%    RetIntervals : (オプション)観測値間の時間間隔のスカラ値、または、
%                   NUMOBS 行 1列のベクトルです。引数 RetIntervals を指
%                   定しない場合、全ての間隔が長さ1であると仮定されます。
%
%    StartTime    : (オプション)最初の観測値の開始時間
%
% 出力:
%    TickSeries   : 自己資産価格の NUMOBS+1 行 NASSETS 列の行列。最初の
%                   行は、資産の当初価格で、最後の行は最後の(最も新しい)
%                   観測値を示しています。
%
%    TickTimes    : 価格に対応する観測時間の NUMOBS+1 行1列のベクトル。
%                   当初時間は、StartTime で特に指示がない限り0となりま
%                   す。
%
% 参考 : TICK2RET, PORTSIM.


%   Author(s): J. Akao 3/24/98
%   Copyright 1995-2002 The MathWorks, Inc.  
