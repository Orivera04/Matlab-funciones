% INSTSETFIELD   ���i�W���ϐ��Ɋ܂܂������̏��i�ɂ��ăf�[�^�̐ݒ��
%                ���s
%
% �S�Ă̏��i�Ƀt�B�[���h��ǉ����邩�A�܂��́A���Z�b�g���s���ɂ́A����
% �悤�ɐݒ肵�܂��B
%   InstSet = instsetfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList)
%
% ���i�̃T�u�Z�b�g�Ƀt�B�[���h��ǉ����邩�A�܂��́A���Z�b�g���s���ɂ́A
% ���̂悤�ɐݒ肵�܂��B
%   InstSet = instsetfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList, ...      
%                             'Index', IndexSet, ...
%                             'Type', TypeList)
%
% ����:
% �����̃p�����[�^�l�̑g��C�ӂ̏����œ��͂��邱�Ƃ��ł��܂��B�������A
% ��Ԗڂ̈����ɂ͊�����InstSet�ϐ�����͂��Ă��������B
%
% InstSetOld -  ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A����
%               ���ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h��
%               �ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h�́A
%               ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A�������
%               �Ȃ��Ă��܂��B
% 
%   FieldList - �e�f�[�^�t�B�[���h�̖��̂����X�g�\�����镶����A�܂��́A
%               �����̕�����ō\������� NFIELDS �s1��̃Z���z��B�Ȃ�
%               FieldList �ɂ́A'Type'�A�܂��́A'Index' ���w�肷�邱�Ƃ�
%               �ł��܂���B�����̒l�͗��ۂ���Ă��܂��B
%
%   DataList  - �e�t�B�[���h�ɑΉ�����f�[�^���e����Ȃ� NINST �s M ���
%               �z��A�܂��́ANFIELDS �s1��̃Z���z��ł��B�f�[�^�z���
%               �\������e�s�͌X�̏��i�ɑΉ����Ă��܂��B�P��̍s�́A
%               ���ʂ���A�ΏۂƂȂ�S�Ă̏��i�ɓK�p����܂��B��̐���
%               �C�ӂŁA�f�[�^�͗�ɏ]���ăp�f�B���O����܂��B
%
%   TypeList  - �ΏۂƂȂ鏤�i�̃^�C�v�����肷�镶����A�܂��́A������
%               ��Ȃ� NTYPE �s1��̃Z���z��ł��B
%
%   IndexSet  - �ΏۂƂȂ鏤�i�̃|�W�V���������肷�� NINST �s1��̃x�N�g
%               ���BTypeList �������ɐݒ肳�ꂽ�ꍇ�A�Q�Ƃ���鏤�i�́A
%               TypeList �ɋL�ڂ��ꂽ�A�����ꂩ1�̃^�C�v�ł���Ɠ�����
%               IndexSet �Ɋ܂܂�Ă��鏤�i�łȂ���΂Ȃ�܂���B
%
% �o��:   
%   InstSet   - �V�������̓f�[�^���܂ޏ��i�W���ϐ��ł��B
%
% ���: 
% 1) InstSet �ϐ�, ExampleInstSF ���f�[�^�t�@�C������擾���܂��B����
%    �ϐ��̒��ɂ́A����3�̃^�C�v�̏��i���܂܂�Ă��܂��B
%   'Option', 'Futures', 'TBill'
%
%   load InstSetExamples.mat
%
%   ISet = ExampleInstSF;
%   instdisp(ISet)
%   
% 2) 95�N�Ɍ������s�g�����C���f�b�N�X 6: 2.9�̃I�v�V�����ɂ���
%    �f�[�^����͂��܂��B
%   ISet = instsetfield(ISet, 'Index',6, 'FieldName',....
%         {'Strike','Price'},'Data',{  95    ,  2.9 });
%   instdisp(ISet)
%   
% 3) �������i�ɂ��āA�V�����t�B�[���h Maturity ���쐬���܂��B
%   MDate = datenum('7/1/99')
%   ISet = instsetfield(ISet, 'Type', 'TBill', 'FieldName', .....
%     'Maturity', 'FieldClass', 'date', 'Data', MDate );
%   instdisp(ISet)
%   
% 4) �S�Ă̏��i�ɂ��āA�V�����t�B�[���h Contracts ���쐬���܂��B
%   ISet = instsetfield(ISet, 'FieldName', 'Contracts', 'Data', 0);
%   instdisp(ISet)
%   
%   
% 5) ���i�̂������ɂ��āAContracts �t�B�[���h�̐ݒ���s���܂��B
%   ISet = instsetfield(ISet,'Index',[3; 5; 4; 7],'FieldName',....
%        'Contracts', 'Data', [1000; -1000; -1000; 6]);
%   instdisp(ISet)
%
% �Q�l : INSTADDFIELD, INSTGET, INSTGETCELL, INSTDISP, FINARGPARSE.


%   Copyright 1995-2002 The MathWorks, Inc. 
