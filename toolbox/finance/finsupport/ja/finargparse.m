% FINARGPARSE   引数をその引数のクラスに従って解析し、デフォルトのスト
%               レージに出力
%
% M 個の引数からなる集合を1つの命令によって解析することが可能です。
%
%   [Arr] = finargparse(ClassString, A)
%   [Arr1, Arr2, ..., ArrM] = finargparse(ClassList, A1, A2, ... AM)
%
% 入力:
%   ClassList           - 文字列、または、各フィールドのデータクラスを
%                         リスト表示する文字列からなる M 行1列のセル配列。
%                         ここで、設定されたクラスによって、DataList の
%                         解析法が定まります。入力可能な文字列は、'dble'
%                         'date', 'char' です。
%
%   A, A1, ... AM       - デフォルトの配列ストレージ形式に解析される引数。
%                         "help finargdate", "help finargchar", 
%                         "help finargdble" のいずれかをタイプすれば、
%                         入力可能な形式や、その解釈の詳細を参照できます。
%
% 出力:
%   Arr, Arr1, ... ArrM - 対応する入力引数のデフォルトの配列表現を表示し
%                         ます。'date' 及び 'dble' の2つのクラスは倍精度
%                         の配列で、'char' はキャラクタ配列となります。
%
% 参考 : FINARGFMT, FINARGDATE, FINARGDBLE, FINARGCHAR.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
