% INSTFIELDS   商品変数に記憶されているフィールドのリストを抽出します。
%
% この関数は、フィールド名及びフィールドのデータストレージクラスの問い
% 合わせを行う関数です。
%
%   [FieldList, ClassList] = instfields(InstSet, 'Type', TypeList)
%   [FieldList, ClassList] = instfields(InstSet)
%
% 入力: 
%   InstSet   - 商品の集合からなる変数。商品は、タイプ毎に分類され、その
%               それぞれのタイプについて互いに異なるデータフィールドを設
%               定することができます。記憶されたデータフィールドは、商品
%               のそれぞれに対応する行ベクトル、または、文字列となってい
%               ます。
%   TypeList  - 検索対象となる商品タイプをリストアップした文字列、または
%               文字列からなる NTYPE 行1列のセル配列
%
% 出力:
%   FieldList - リストアップされた商品タイプに対応するデータフィールドの
%               名称をリスト表示する文字列からなる NFIELDS 行1列のセル配
%               列。
%   ClassList - DataList を構成する各フィールドのデータクラスを記載する
%               文字列からなる NFIELDS 行1列のセル配列です。ここに記載さ
%               れるデータクラスによって、入力データの解釈法が決定されま
%               す。入力可能な引数は、'dble', 'date',  'char'です。 
%     
% 例題:
% 1) InstSet 変数, ExampleInst をデータファイルから取得します。
%
%   load InstSetExamples.mat
%   instdisp(ExampleInst)
%
% 2) 'Option' タイプに対応するフィールドをリスト表示します。
%   [FieldList, ClassList] = instfields(ExampleInst, 'Type', 'Option')
%
% 3) 'Option' 及び 'TBill' の2つのタイプに対応するフィールドをリスト
%       表示します。
%   FieldList = instfields(ExampleInst, 'Type', {'Option', 'TBill'})
%
% 4) 変数を構成する全てのタイプに対応するフィールドをリスト表示します。
%   FieldList = instfields(ExampleInst)
%
% 参考 : INSTTYPES, INSTLENGTH, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
