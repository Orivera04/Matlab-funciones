% INSTDELETE   条件に適合する商品を見つけだすことにより、商品の部分集合
%              を完全なものにします。
%
%   ISubSet = instdelete(ISet, 'FieldName', FieldList, ... 
%                              'Data' , DataList, ...      
%                              'Index', IndexSet, ...
%                              'Type', TypeList)
%
% 入力:
% 複数のパラメータ値の組を任意の順序で入力することができます。ただし、
% 一番目の引数には ISet 変数を入力してください。'FieldName' 及び 'Data' 
% パラメータを使用するときは、両方共に用いられなければなりません(どちらか
% 片方のみを使用することはできません)。なお、'Index' 及び 'Type' パラ
% メータはオプションです。
%
%   ISet       - 商品の集合からなる変数。商品は、タイプ毎に分類され、そ
%                のそれぞれのタイプについて互いに異なるデータフィールド
%                を設定することができます。記憶されたデータフィールドは
%                商品のそれぞれに対応する行ベクトル、または、文字列と
%                なっています。
% 
%   FieldList - データ値に適合する各データフィールドの名称をリスト表示す
%               る文字列、または、文字列で構成される NFIELDS 行1列のセル
%               配列。
%
%   DataList  - 各フィールドに入力できるデータ値からなる NVALUES 行 M 列
%               の配列、または、NFIELDS 行1列のセル配列です。この配列を
%               構成するそれぞれの行は、対応する FieldList 内で探索する
%               データ行の値を表示しています。列の数は任意で、パディング
%               によって付加された NaN 、または、スペースは、条件に適合
%               するかどうかのチェックを行う際には無視されます。
%
%   IndexSet  - 適合するかどうかのチェックをうける商品のポジションを限定
%               する NINST 行1列のベクトルです。デフォルトでは、商品変数
%               内で利用できる全てのインデックスに設定されています。
%
%   TypeList  - 適合するかどうかのチェックを受ける商品のタイプを限定する
%               文字列、または、文字列からなる NTYPE 行1列のセル配列です。
%               デフォルトでは、商品変数を構成する全てのタイプに設定され
%               ています。
%
% 出力:
%   ISubSet   - 入力された基準に適合しない商品を含む変数です。Field, 
%               Index, Type の全ての条件に適合する商品は、ISubSet から
%               削除されます。FieldName に対応する DataList に記載されて
%               いるいずれかの行と記憶された FieldName データが適合する
%               とき商品は個々の Field 条件と適合したことになります。
%
% 注意：
% より多くの適合基準の例を参照するには、"help instfind" とタイプしてくだ
% さい。
%
% 例題:
% 1) データファイルから InstSet 変数 ExampleInst を取得します。変数内
%    には、つぎの3つのタイプの商品が含まれています。
%    'Option', 'Futures',  'TBill'
%
%      load InstSetExamples.mat
%      instdisp(ExampleInst)
%
% 2) 新しい変数 ISet からオプションを全て除去します。
%   ISet = instdelete(ExampleInst, 'Type','Option');
%   instdisp(ISet)
%
% 参考 : INSTSELECT, INSTFIND, INSTGET, INSTADDFIELD.


%   Author(s) : J. Akao 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
