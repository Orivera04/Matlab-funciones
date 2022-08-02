% INSTFIND   �����ɓK�����鏤�i������
%
% Type, Field�A�܂��́AIndex �̊e�l�ɓK�����鏤�i�̃C���f�b�N�X���o��
% ���܂��B
%
%   IndexMatch = instfind(InstSet, 'FieldName', FieldList, ... 
%                               'Data' , DataList, ...      
%                               'Index', IndexSet, ...
%                               'Type', TypeList)
%
% ����: 
% �����̃p�����[�^�l�̑g��C�ӂ̏����œ��͂��邱�Ƃ��ł��܂��B�������A
% 1�Ԗڂ̈����ɂ́AISet �ϐ�����͂��Ă��������B'FieldName' �y�� 'Data' 
% �p�����[�^���g�p����Ƃ��́A�������ɗp�����Ȃ���΂Ȃ�܂���(�ǂ���
% ���Е��݂̂��g�p���邱�Ƃ͂ł��܂���)�B�Ȃ��A'Index' �y�� 'Type'�p��
% ���[�^�̓I�v�V�����ł��B
%
%   InstSet     - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A��
%                 �̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h
%                 ��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h��
%                 ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A�������
%                 �Ȃ��Ă��܂��B
%
%   FieldList   - �f�[�^�l�ɓK������e�f�[�^�t�B�[���h�̖��̂����X�g�\��
%                 ���镶����A�܂��́A������ō\������� NFIELDS �s1���
%                 �Z���z��B
%
%   DataList    - �e�t�B�[���h�ɓ��͉\�Ȓl������ NVALUES �s M ��̔z��
%                 �܂��́ANFIELDS �s1��̃Z���z��ł��B�z����\������e
%                 �s�́A�Ή����� FieldList ���ŒT�������f�[�^�s�̒l��
%                 �\�����Ă��܂��B��̐��͔C�ӂŁA�p�f�B���O�ŕt�����ꂽ
%                 NaN �A�܂��́A�X�y�[�X�͓K�����邩�̃`�F�b�N���s���ۂ�
%                 �͖�������܂��B
%
%   IndexSet    - �K�����邩�̃`�F�b�N���s�����i�̃|�W�V���������肷�� 
%                 NINST �s 1��̃x�N�g���B�f�t�H���g�ł͏��i�ϐ����ŗ��p
%                 �ł���S�ẴC���f�b�N�X�ɐݒ肳��Ă��܂��B
%
%   TypeList    - �K�����邩�̃`�F�b�N���󂯂鏤�i�̃^�C�v�����肷�镶��
%                 ��A�܂��́A�����񂩂�Ȃ� NTYPE �s1��Z���z��ł��B
%                 �f�t�H���g�ł́A���i�ϐ����\������S�Ẵ^�C�v�ɐݒ�
%                 ����Ă��܂��B
%
% �o��:
%   IndexMatch  - ���͂��ꂽ��ɓK�����鏤�i�̃|�W�V���������� NINST 
%                 �s1��̃x�N�g���ł��BField, Index, Type �̑S�Ă̏�����
%                 �K�����鏤�i�� IndexMatch �ɏo�͂���܂��BFieldName ��
%                 �Ή����� DataList �ɋL�ڂ���Ă��邢���ꂩ�̍s�ƋL��
%                 ���ꂽ FieldName �f�[�^���K������Ƃ��A���i�͌X�� 
%                 Field �����ƓK���������ƂɂȂ�܂��B
%
% ���:
%
% 1) �f�[�^�t�@�C�� InstSetExamples.mat ����A�ݒ肳�ꂽ�ϐ� ExampleInst
%    �̏��i�����o���܂��B�ϐ��́AOption, Futures, TBill ��3�̏��i
%    �^�C�v���܂�ł��܂��B
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
% 2) 95�N�ɍs�g�����I�v�V������ ExampleInst ���̃C���f�b�N�X���܂�
%    Opt95 �̃x�N�g�����쐬���܂��B
%      Opt95 = instfind(ExampleInst, 'FieldName','Strike','Data','95') 
%
% 3) Futures �� Treasury �̖��ׂ̂������i��ݒu���܂��B
%      Types = instfind(ExampleInst,'Type',{'Futures';'TBill'})
%
%
% �Q�l: INSTSELECT, INSTGET, INSTGETCELL, INSTADDFIELD.

%   Copyright 1995-2002 The MathWorks, Inc. 
