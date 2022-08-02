% INSTFIXED   'Fixed'�^�C�v ���i�̍쐬�֐�
%
% �f�[�^�z�񂩂�V�������i�ϐ��𐶐�����ɂ́A���̂悤�ɐݒ肵�܂��B
% 
%   ISet = instfixed(CouponRate, Settle, Maturity, Reset, Basis, ....
%          Principal)
%
% ���i�ϐ���'Fixed'���i��ǉ�����ɂ́A���̂悤�ɐݒ肵�܂��B
% 
%   ISet = instfixed(ISet, CouponRate, Settle, Maturity, Reset,...
%                  Basis, Principal)
%
%  'Fixed' ���i�ɑΉ�����t�B�[���h���^�f�[�^�����X�g�A�b�v����ɂ́A
% ���̂悤�ɐݒ肵�܂��B
% 
%   [FieldList, ClassList, TypeString] = instfixed;
%
% ����: 
% �f�[�^�����ɂ́ANINST �s1��̃x�N�g���A�X�J���A�܂��́A��̂����ꂩ��
% ���͂ł��܂��B�x�N�g�����̎w��̂Ȃ����͂ɂ��ẮANaN �l�����͂���
% �܂��B���i�̐����ɂ́A������1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^
% �����͍폜�A�܂��́A��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A����
% �f�[�^�̃N���X�ɉ����āAFINARGPARSE ���g���ĉ��߂���܂��B�f�[�^��
% �N���X���Q�Ƃ���ɂ́A"[FieldList, ClassList] = instfixed" �ƃ^�C�v
% ���Ă��������B�Ȃ��A���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t
% ������œ��͂��Ă��������B
%
%   CouponRate      - 10�i���\�L�̔N����
%   Settle          - ���ϓ�
%   Maturity        - ������
%   Reset           - �N�ɉ��񌈍ς��s���邩�̕p�x�ł��B
%                     �f�t�H���g��1�ł��B
%   Basis           - �����J�E���g��B�f�t�H���g�� 0 (actual/actual)�B
%   Principal       - �z�茳�{(���ڌ��{)�B�f�t�H���g��100�ł��B
%   
% �o��:
%   ISet       - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A��
%                �̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h
%                ��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h��
%                ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A������Ƃ�
%                ���Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ��ẮA
%                "help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList  - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂����X
%                �g�\�����镶����ō\������� NFIELDS �s1��̃Z���z��B
% 
%   ClassList  - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                NFIELDS�s1��̃Z���z��A�����ɋL�ڂ����f�[�^�N���X��
%                ����āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ����́A
%                'dble', 'date',  'char'�ł��B 
%   TypeString - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                TypeString = 'Fixed'.
%
% �Q�l : INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 04/28/99
%   Copyright 1995-2002 The MathWorks, Inc. 
