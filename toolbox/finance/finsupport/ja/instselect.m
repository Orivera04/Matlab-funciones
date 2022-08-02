% INSTSELECT   条件に適合する商品のサブセットを出力
%
%   InstSubSet = instselect(InstSet, 'FieldName', FieldList, ... 
%                              'Data' , DataList, ...      
%                              'Index', IndexSet, ...
%                              'Type', TypeList)
%
% 入力: 
% 複数のパラメータ値の組を任意の順序で入力することができます。ただし、
% 一番目の引数には ISet 変数を入力してください。'FieldName' 及び 'Data' 
% パラメータを使用するときは、両方共に用いなければなりません(どちらか片方
% のみを使用することはできません)。なお、'Index' 及び 'Type' パラメータ
% はオプションです。
%
%   InstSet    - 商品の集合からなる変数。商品は、タイプ毎に分類され、
%                そのそれぞれのタイプについて互いに異なるデータフィールド
%                を設定することができます。記憶されたデータフィールドは
%                商品のそれぞれに対応する行ベクトル、または、文字列と
%                なっています。
%
%   FieldList  - データ値に適合する各データフィールドの名称をリスト表示
%                する文字列、または、文字列で構成される NFIELDS 行1列の
%                セル配列。
%
%   DataList   - 各フィールドに入力できるデータ値からなるNVALUES行M列
%                の配列、または、NFIELDS 行1列のセル配列です。この配列
%                を構成するそれぞれの行は、対応する FieldList 内で探索す
%                るデータ行の値を表示しています。列の数は任意で、パディ
%                ングによって付加された NaN、または、スペースは、条件に
%                適合するかどうかのチェックを行う際には無視されます。
%
%   IndexSet   - 適合するかどうかのチェックをうける商品のポジションを
%                限定する NINST 行1列のベクトルです。デフォルトでは商品
%                変数内で利用できる全てのインデックスに設定されています。
%
%   TypeList   - 適合するかどうかのチェックをうける商品のタイプを限定す
%                る文字列、または、文字列からなる NTYPE 行1列のセル配列
%                です。デフォルトでは、商品変数を構成する全てのタイプに
%                設定されています。
%
% 出力:
%   InstSubSet - 入力された基準に適合する商品を含む変数です。Field, 
%                Index, Type の全ての条件に適合する商品が、InstSubSet に
%                出力されます。FieldName に、対応する DataList に記載
%                されているいずれかの行と記憶された FieldName データが
%                適合するとき、商品は個々の Field 条件と 適合したことに
%                なります。
%
% 注意：
% 基準に適合するかどうかのテストに使用する基準の具体例をより多く参照した
% いユーザは、 "help instfind" とタイプしてください。
%
% 例題:
% 1) InstSet 変数, ExampleInst をデータファイルから取得します。
%    この変数の中には、つぎの3つのタイプの商品が含まれています。
%    'Option', 'Futures', 'TBill'
%
%   load InstSetExamples.mat
%   instdisp(ExampleInst)
%
% 2) 95年に行使されるオプションを伴う新しい変数を作成します。
%   ISet = instselect(ExampleInst, 'FieldName','Strike','Data',95)
%   instdisp(ISet)
%
% 参考 : INSTFIND, INSTDELETE, INSTGET, INSTADDFIELD.


%   Author(s) : J. Akao 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
