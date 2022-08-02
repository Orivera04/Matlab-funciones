% INSTSETFIELD   商品集合変数に含まれる既存の商品についてデータの設定を
%                実行
%
% 全ての商品にフィールドを追加するか、または、リセットを行うには、つぎの
% ように設定します。
%   InstSet = instsetfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList)
%
% 商品のサブセットにフィールドを追加するか、または、リセットを行うには、
% つぎのように設定します。
%   InstSet = instsetfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList, ...      
%                             'Index', IndexSet, ...
%                             'Type', TypeList)
%
% 入力:
% 複数のパラメータ値の組を任意の順序で入力することができます。ただし、
% 一番目の引数には既存のInstSet変数を入力してください。
%
% InstSetOld -  商品の集合からなる変数。商品は、タイプ毎に分類され、その
%               それぞれのタイプについて互いに異なるデータフィールドを
%               設定することができます。記憶されたデータフィールドは、
%               商品のそれぞれに対応する行ベクトル、または、文字列と
%               なっています。
% 
%   FieldList - 各データフィールドの名称をリスト表示する文字列、または、
%               それらの文字列で構成される NFIELDS 行1列のセル配列。なお
%               FieldList には、'Type'、または、'Index' を指定することは
%               できません。これらの値は留保されています。
%
%   DataList  - 各フィールドに対応するデータ内容からなる NINST 行 M 列の
%               配列、または、NFIELDS 行1列のセル配列です。データ配列を
%               構成する各行は個々の商品に対応しています。単一の行は、
%               複写され、対象となる全ての商品に適用されます。列の数は
%               任意で、データは列に従ってパディングされます。
%
%   TypeList  - 対象となる商品のタイプを限定する文字列、または、文字列か
%               らなる NTYPE 行1列のセル配列です。
%
%   IndexSet  - 対象となる商品のポジションを限定する NINST 行1列のベクト
%               ル。TypeList も同時に設定された場合、参照される商品は、
%               TypeList に記載された、いずれか1つのタイプであると同時に
%               IndexSet に含まれている商品でなければなりません。
%
% 出力:   
%   InstSet   - 新しい入力データを含む商品集合変数です。
%
% 例題: 
% 1) InstSet 変数, ExampleInstSF をデータファイルから取得します。この
%    変数の中には、つぎの3つのタイプの商品が含まれています。
%   'Option', 'Futures', 'TBill'
%
%   load InstSetExamples.mat
%
%   ISet = ExampleInstSF;
%   instdisp(ISet)
%   
% 2) 95年に権利が行使されるインデックス 6: 2.9のオプションについて
%    データを入力します。
%   ISet = instsetfield(ISet, 'Index',6, 'FieldName',....
%         {'Strike','Price'},'Data',{  95    ,  2.9 });
%   instdisp(ISet)
%   
% 3) 現金商品について、新しいフィールド Maturity を作成します。
%   MDate = datenum('7/1/99')
%   ISet = instsetfield(ISet, 'Type', 'TBill', 'FieldName', .....
%     'Maturity', 'FieldClass', 'date', 'Data', MDate );
%   instdisp(ISet)
%   
% 4) 全ての商品について、新しいフィールド Contracts を作成します。
%   ISet = instsetfield(ISet, 'FieldName', 'Contracts', 'Data', 0);
%   instdisp(ISet)
%   
%   
% 5) 商品のいくつかについて、Contracts フィールドの設定を行います。
%   ISet = instsetfield(ISet,'Index',[3; 5; 4; 7],'FieldName',....
%        'Contracts', 'Data', [1000; -1000; -1000; 6]);
%   instdisp(ISet)
%
% 参考 : INSTADDFIELD, INSTGET, INSTGETCELL, INSTDISP, FINARGPARSE.


%   Copyright 1995-2002 The MathWorks, Inc. 
