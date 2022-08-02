% FINARGFMT   引数クラスに適合する文字列に引数を変換
%
% M個の引数からなる集合を1回のコールで文字列に変換することができます。
%
%   [AString] = finargfmt(ClassString, A)
%   [AString1, AString2, ..., AStringM] = ....
%               finargfmt(ClassList, A1, A2, ... AM)
%
% 入力:
%   ClassList     - 文字列、または、各フィールドのデータクラスをリスト
%                   表示する文字列からなる M 行1列のセル配列。ここで、
%                   設定されたクラスによって、DataList の解析法が定まり
%                   ます。入力可能な文字列は、'dble', 'date', 'char'です。
%
%   A, A1, ... AM - FINARGPARSE が解析する引数。デフォルトのストレージ
%                   形式です。'date' 及び 'dble' の2つのクラスは倍精度の
%                   数列で、一方、'char' はキャラクタ配列となります。
%
% 出力:
% AString, AString1, ... AStringM - 
%                   対応する入力引数のフォーマットされた文字列表現。
%                   クラス 'date' は、DATEDISP に従ってフォーマットされ、
%                   クラス 'dble' は、NUM2STR に従ってフォーマットされ
%                   ます。
%
% 注意：
% オプションのフォーマット指定子を省略するには、直接 DATEDISP、または、
% NUM2STR をコールしてください。なお、FINARGFMT は、常にデフォルトの
% フォーマットを使用します。
%
% 参考 : FINARGPARSE, NUM2STR, DATEDISP.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
