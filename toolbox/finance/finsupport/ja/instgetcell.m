% INSTGETCELL   商品変数からデータ及びコンテクストを抽出
%
%   [DataList, FieldList, ClassList , IndexSet, TypeSet ] = ... 
%      instgetcell(InstSet, ...
%                 'FieldName', FieldList, ...
%                 'Index', IndexSet, ...
%                 'Type', TypeList)
%
% 入力:
% 複数のパラメータ値の組を任意の順序で入力できます。ただし、最初の引数は
% InstSet でなくてはなりません。なお、InstSet 引数は必須です。
%
% InstSet - 商品の集合からなる変数。商品は、タイプ毎に分類され、そのそれ
%           ぞれのタイプについて互いに異なるデータフィールドを設定するこ
%           とができます。記憶されたデータフィールドは、商品のそれぞれに
%           対応する行ベクトル、または、文字列となっています。
%
%   FieldList  - 
%           各データフィールドの名称をリスト表示する文字列、または、その
%           文字列で構成される NFIELDS 行1列のセル配列。FieldList につい
%           ても、'Type' か 'Index' のいずれかを入力できます。このいずれ
%           かを入力すれば、それに対応してタイプを示す文字列とインデック
%           ス番号が、それぞれ出力されます。デフォルトでは、全てのフィー
%           ルドが出力された商品セットについて利用可能となっています。
%   TypeList   - 
%           実行対象となる商品のタイプを TypeList に記載されたタイプに適
%           合するものに制約する文字列、または、文字列からなる NTYPE 行1
%           列のセル配列。デフォルトでは、商品変数内の全てのタイプが対象
%           となっています。
%   IndexSet   - 
%           実行対象となる商品のポジションを示す NINST 行1列のベクトルで
%           す。TypeList も同時に設定された場合、参照される商品は、
%           TypeList に記載された、いずれか1つのタイプであると同時に、
%           IndexSet に含まれている商品でなければなりません。デフォルト
%           では商品変数の全てのインデックスが利用可能となっています。
% 
% 出力：
%   DataList   - 
%           各フィールドに入力可能な値を示す NFIELDS 行1列のセル配列です。
%           配列を構成する各セルは、NINST 行 M 列の配列となっており、
%           その各行は、IndexSet を構成する各々の商品と対応しています。
%           利用可能でない全てのデータは、NaN 、または、スペースで出力
%           されます。
%   FieldList  - 
%           DataList の各フィールド名をリスト表示する文字列の NFIELDS 行
%           1列のセル配列
%   ClassList  - 
%           DataList の各フィールドのクラスをリスト表示する文字列の 
%           NFIELDS 行1列のセル配列。ここに、記載されるデータクラスに
%           よって、入力データの解釈法が決まります。なお、入力可能な
%           引数は 'dble', 'date', 'char'です。 
%   IndexSet   - 
%           DataList に出力される商品のポジションを示す NINST 行1列のベ
%           クトル
%   TypeSet    - 
%           DataList に出力される商品を示す各行のタイプをリスト表示する
%           文字列からなる NINST 行1列のセル配列
%
% 注意：
% この関数は、商品変数の構造が未知であるケースでのプログラミングで用いる
% のが最も適しています。変数内のデータへのアクセスについては、INSTGET を
% 用いる方がより直接的なアクセスが可能です。
%
% 例題:
% 1) InstSet 変数、ExampleInst をデータファイルから取得します。この変数
%    の中には、つぎの3つのタイプの商品が含まれています。
%    'Option', 'Futures', 'TBill'
%
%    load InstSetExamples.mat
%    instdisp(ExampleInst)
%
%    Index Type   Strike Price Opt  Contracts
%    1    Option  95    12.2  Call     0    
%    2     Option 100     9.2  Call     0    
%    3     Option 105     6.8  Call  1000    
%     
%    Index Type    Delivery       F     Contracts
%    4     Futures 01-Jul-1999    104.4 -1000    
%     
%    Index Type   Strike Price Opt  Contracts
%    5     Option 105     7.4  Put  -1000    
%    6     Option  95     2.9  Put      0    
%     
%    Index Type  Price Maturity       Contracts
%    7     TBill 99    01-Jul-1999    6        
%
% 2) 全ての商品を対象にその価格と契約数を取得します。
%   FieldList = {'Price'; 'Contracts'}
%   DataList = instgetcell(ExampleInst, 'FieldName', FieldList )
%   P = DataList{1}
%   C = DataList{2}
%   
% 3) つぎのオプションデータを全て取得します。 
%       Strike, Price, Opt, Contracts
%   [DataList, FieldList, ClassList] = ....
%          instgetcell(ExampleInst,'Type','Option')
%   
% 4) データをコンマ区切りリストで表示します。
%    セル配列リストの詳細については、 "help lists"をタイプしてください。
%   DataList{:}
%   
% 参考 : INSTGET, INSTADDFIELD, INSTDISP.


%   Author(s): J. Akao, 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
