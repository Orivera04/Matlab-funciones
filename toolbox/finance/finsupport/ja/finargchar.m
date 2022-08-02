% FINARGCHAR   引数をキャラクタ配列にフォーマット
%
% 入力されたセル配列、数字 ASCII 数列、キャラクタ配列からNROWS行STRLEN列
% のキャラクタ配列を生成します。文字列として処理できない入力については、
% 全て空白行として出力します。出力される配列は、入力行列の行、または、
% 入力セル配列の入力値から生成されます。
%
%   [CharMat] = finargchar(StringArg)
%   [CharMat] = finargchar(AsciiArg)
%   [CharMat] = finargchar(CellArg)
%
% 入力:
%   StringArg - NROWS 行 STRLEN 列のキャラクタ列
%   AsciiArg  - ASCII 値の NROWS 行 STRLEN 列のクラス倍精度配列
%   CellArg   - キャラクタ、または、ASCII 行列を含むNROWS行1列のセル配列
%               各セルは、単一の行として処理されます。行列のセルは、空白
%               によって、区切られて、単一の行に配列され、処理されます。
%               空白のセルは空白の行を生成します。
%     
% 出力:
%   CharMat   - NROWS 行 STRLEN 列のキャラクタです。空白の入力は、単一の
%               空白出力を生成します。また、無効なタイプの入力は空の出力
%               を生成します。
%
% 参考 : CHAR, CELLSTR, DOUBLE, FINARGDATE, FINARGDBLE.


%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
