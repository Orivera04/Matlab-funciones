% INSTADDFIELD   ���i�W���ϐ��ɐV�������i��ǉ�
%
% ���[�U�������ō쐬�����^�C�v�̏��i�𐶐��������ꍇ�A�܂��́A�����̏W��
% �ɐV�������i��ǉ��������ꍇ�A�֐� INSTADDFIELD �����s���Ă��������B
%
%   ���i�ϐ���1�쐬����ɂ́A���̂悤�ɐݒ肵�܂��B
%   InstSet = instaddfield('FieldName', FieldList, ... 
%                       'Data' , DataList, ...      
%                       'Type', TypeString)
%
%   InstSet = instaddfield('FieldName', FieldList, ... 
%                       'FieldClass', ClassList, ...
%                       'Data' , DataList, ...      
%                       'Type', TypeString)
%
%   ���i��ǉ�����ɂ́A���̂悤�ɐݒ肵�܂��B
%   InstSet = instaddfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList, ...      
%                             'Type', TypeString)
%
% ����: 
% �����̃p�����[�^�l�̑g��C�ӂ̏����œ��͂��邱�Ƃ��ł��܂��B�������A
% ��Ԗڂ̈����ɂ́A������ InstSet �ϐ�����͂��Ă��������B
%
%   InstSetOld - ���i�̏W������Ȃ�ϐ��ł��B���i�́A�^�C�v���ɕ��ނ���
%                �Ă���A���ꂼ��̃^�C�v�ɂ��ĈقȂ�f�[�^�t�B�[���h
%                ��ݒ�ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h�́A���i�̂�
%                �ꂼ��ɑΉ�����s�x�N�g���A�܂��́A������ƂȂ��Ă���
%                ���B
%
%   FieldList  - �e�f�[�^�t�B�[���h�̖��̂��L�ڂ���������A�܂��́A����
%                ��� NFIELDS �s1��̃Z���z��BFieldList �ɂ́A 'Type'�A
%                �܂��́A'Index' �Ƃ������̂��L�ڂ��邱�Ƃ͂ł��܂���B
%                �����̃t�B�[���h���͓o�^����Ă��܂��B
% 
%   DataList   - �e�f�[�^�t�B�[���h�̒��g���\������f�[�^����Ȃ� NINST 
%                �s M ��̔z��A�܂��́ANFIELDS �s1��̃Z���z��B�f�[�^
%                �z��̊e�s�́A�X�̏��i�ɑΉ����Ă��܂��B�P��̍s�̏�
%                ���A���ʂ���A�ΏۂƂȂ�S�Ă̏��i�ɓK�p����܂��B���
%                ���́A�C�ӂŁA�f�[�^�͗����ɂ��ăp�f�B���O����܂��B
% 
%   ClassList  - �e�f�[�^�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶����A�܂�
%                �́A������� NFIELDS �s1��̃Z���z��BDataList �̉�͖@
%                �́A�����Ŏw�肳�ꂽ�f�[�^�N���X�ɂ���Č��肳��܂��B
%                ���͉\�ȕ�����́A'dble', 'date', 'char' �ł��B
%                'FieldClass' �� ClassList �̃y�A�́A��ɃI�v�V�����ƂȂ�
%                �܂��BClassList �́A�����̃t�B�[���h���A�܂��́A������
%                �t�B�[���h�������͂���Ă��Ȃ��ꍇ�A�f�[�^���琄�肳���
%                ���ƂɂȂ�܂��B
%   TypeString - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����B�قȂ�^�C�v��
%                ���i�́A�قȂ�t�B�[���h���W���������Ƃ��ł��܂��B
%
% �o��:   
%   InstSet    - �V�������̓f�[�^���܂ޏ��i�W���ϐ��ł��B
%
% ���:7���I�v�V��������Ƀ|�[�g�t�H���I���\�z���܂��B
%   % Strike Call  Put
%   %  95    12.2  2.9
%   % 100     9.2  4.9
%   % 105     6.8  7.4
%   Strike = (95:5:105)'
%   CallP = [12.2; 9.2; 6.8]
%   
%   %  �f�[�^�t�B�[���h 'Strike', 'Price', 'Opt' ��L����3�R�[���I�v
%      �V��������͂��܂��B
%   ISet = instaddfield('Type','Option', ...
%                       'FieldName',{'Strike','Price','Opt'}, ...
%                       'Data',{ Strike,  CallP, 'Call'});
%   instdisp(ISet)
%   
%   % �敨�_�����͂��A���͉��߃N���X��ݒ肵�܂��B
%   ISet = instaddfield(ISet,'Type','Futures', ...
%                       'FieldName',{'Delivery','F'}, ...
%                       'FieldClass',{  'date'  , 'dble'}, ...
%                       'Data' ,{'01-Jul-99' , 104.4  });
%   instdisp(ISet)
%   
%   % �v�b�g�I�v�V��������͂��܂��B
%   FN = instfields(ISet,'Type','Option')
%   ISet = instaddfield(ISet,'Type','Option','FieldName',FN,...
%                       'Data',{105, 7.4, 'Put'});
%   instdisp(ISet)
%   
%   % ��������̃v�b�g�ɂ��ăv���[�X�z���_���쐬���܂��B
%   ISet = instaddfield(ISet,'Type','Option','FieldName','Opt',....
%          'Data','Put')
%   instdisp(ISet)
%   
%   % �������i��ǉ����܂��B
%   ISet = instaddfield(ISet, 'Type', 'TBill', 'FieldName',....
%          'Price','Data',99)
%   instdisp(ISet)
%   
%
% �Q�l : INSTSETFIELD, INSTGETCELL, INSTGET, FINARGPARSE, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
