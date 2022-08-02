% FINARGDBLE   引数に NaN をパディングした行からなる倍精度配列にフォー
%              マット
%
% 長さが互いに異なる行を NaN でパディングした NROWS 行 MAXCOLS 列の行列
% を生成します。入力は、倍精度の数、または、文字列から解析された数です。
% 出力される行は、入力された行列の行から生成されるか、または、入力された
% セル配列の値から生成されます。
%
%   [DbleMat] = finargdble(NumericArg)
%   [DbleMat] = finargdble(StringArg)
%   [DbleMat] = finargdble(CellArg)
%
% 入力:
%   NumericArg - NROWS 行 MAXCOLS 列のクラス倍精度の数値配列
%
%   StringArg  - 数値の NROWS 行 STRLEN 列のキャラクタ列。個々の数値は、
%                STR2DOUBLE によって解析されます。スペースを構成する数は
%                サポートしていません。行は、別々な列に設定されるいくつ
%                かの数字を含むことができます。数値に置き換えることの
%                できない値は、NaN で表示されます。
%
%   CellArg    - 倍精度の数、または、キャラクタ行列からなる NROWS 行1列
%                のセル配列です。このセル配列を構成するそれぞれのセルは
%                単一の行として処理されます。セルを構成する複数の要素は
%                別々の列に出力されます。なお、空のセル、または、不適切
%                な文字列については、NaN で表示されます。
%
% 出力:
%   DbleMat    - NROWS 行 MAXCOLS 列のクラス倍精度数列。MAXCOLS は、それ
%                ぞれの行を構成する数字の数の最大値です。この値よりも短
%                い長さの行は、行列を満たすために NaN によってパディング
%                されます。空の入力は単一の NaN 出力を生成しますが、数と
%                認識されないタイプの入力については、NaN ではなく、空の
%                出力を生成します。
%
% 例題:
%     Arg = { 38, 'NULL', 45, NaN, 27, [], 58 }
%     Darg = finargdble(Arg)
%     Darg =
%         38
%        NaN
%         45
%        NaN
%         27
%        NaN
%         58
%
%     Arg = { '14.5', '1e2', '28' }
%     Darg = finargdble(Arg)
%     Darg =
%        14.5000
%       100.0000
%        28.0000
%
%     Arg = { [1 2], [1], [1 2 3] }    
%     Darg = finargdble(Arg)
%     Darg =
%         1    2   NaN
%         1  NaN   NaN
%         1    2     3
% 
% 参考 : FINARGCAT, STR2DOUBLE, NUM2STR, NUM2CELL, FINARGDATE, FINARGCHAR.


%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
