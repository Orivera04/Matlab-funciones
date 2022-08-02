% INSTFIND   条件に適合する商品を検索
%
% Type, Field、または、Index の各値に適合する商品のインデックスを出力
% します。
%
%   IndexMatch = instfind(InstSet, 'FieldName', FieldList, ... 
%                               'Data' , DataList, ...      
%                               'Index', IndexSet, ...
%                               'Type', TypeList)
%
% 入力: 
% 複数のパラメータ値の組を任意の順序で入力することができます。ただし、
% 1番目の引数には、ISet 変数を入力してください。'FieldName' 及び 'Data' 
% パラメータを使用するときは、両方共に用いられなければなりません(どちら
% か片方のみを使用することはできません)。なお、'Index' 及び 'Type'パラ
% メータはオプションです。
%
%   InstSet     - 商品の集合からなる変数。商品は、タイプ毎に分類され、そ
%                 のそれぞれのタイプについて互いに異なるデータフィールド
%                 を設定することができます。記憶されたデータフィールドは
%                 商品のそれぞれに対応する行ベクトル、または、文字列と
%                 なっています。
%
%   FieldList   - データ値に適合する各データフィールドの名称をリスト表示
%                 する文字列、または、文字列で構成される NFIELDS 行1列の
%                 セル配列。
%
%   DataList    - 各フィールドに入力可能な値を示す NVALUES 行 M 列の配列
%                 または、NFIELDS 行1列のセル配列です。配列を構成する各
%                 行は、対応する FieldList 内で探索されるデータ行の値を
%                 表示しています。列の数は任意で、パディングで付加された
%                 NaN 、または、スペースは適合するかのチェックを行う際に
%                 は無視されます。
%
%   IndexSet    - 適合するかのチェックを行う商品のポジションを限定する 
%                 NINST 行 1列のベクトル。デフォルトでは商品変数内で利用
%                 できる全てのインデックスに設定されています。
%
%   TypeList    - 適合するかのチェックを受ける商品のタイプを限定する文字
%                 列、または、文字列からなる NTYPE 行1列セル配列です。
%                 デフォルトでは、商品変数を構成する全てのタイプに設定
%                 されています。
%
% 出力:
%   IndexMatch  - 入力された基準に適合する商品のポジションを示す NINST 
%                 行1列のベクトルです。Field, Index, Type の全ての条件に
%                 適合する商品が IndexMatch に出力されます。FieldName に
%                 対応する DataList に記載されているいずれかの行と記憶
%                 された FieldName データが適合するとき、商品は個々の 
%                 Field 条件と適合したことになります。
%
% 例題:
%
% 1) データファイル InstSetExamples.mat から、設定された変数 ExampleInst
%    の商品を取り出します。変数は、Option, Futures, TBill の3つの商品
%    タイプを含んでいます。
%
%      load InstSetExamples.mat
%      ISet = ExampleInstFind
%      instdisp(ISet)
%
%      Index Type   Strike Price Opt  Contracts
% 	   1     Option  95    12.2  Call     0     
% 	   2     Option 100     9.2  Call     0     
% 	   3     Option 105     6.8  Call  1000    
%      
%  	   Index Type    Delivery       F     Contracts
% 	   4     Futures 01-Jul-1999    104.4 -1000    
%      
% 	   Index Type   Strike   Price Opt  Contracts
% 	   5     Option 105      7.4   Put  -1000     
% 	   6     Option  95      2.9   Put      0     
% 	
% 	   Index Type  Price Maturity       Contracts
% 	   7     TBill 99    01-Jul-1999    6      
%
% 2) 95年に行使されるオプションの ExampleInst 内のインデックスを含む
%    Opt95 のベクトルを作成します。
%      Opt95 = instfind(ExampleInst, 'FieldName','Strike','Data','95') 
%
% 3) Futures と Treasury の明細のついた商品を設置します。
%      Types = instfind(ExampleInst,'Type',{'Futures';'TBill'})
%
%
% 参考: INSTSELECT, INSTGET, INSTGETCELL, INSTADDFIELD.

%   Copyright 1995-2002 The MathWorks, Inc. 
