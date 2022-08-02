% INSTFLOAT   'Float' �^�C�v ���i�̍쐬�֐�
%
% �V�������i�ϐ����f�[�^�z�񂩂琶������ɂ́A���̂悤�ɐݒ肵�Ă���
% �����B
% 
%   ISet = instfloat(Spread, Settle, Maturity, Reset, Basis, Principal)
%
% ���i�ϐ��� 'Float' ���i��ǉ�����ɂ́A���̂悤�ɐݒ肵�Ă��������B
%   ISet = instfloat(ISet, Spread, Settle, Maturity, Reset, ...
%                      Basis, Principal)
% 
% 'Float' ���i�ɓK�p�����t�B�[���h���^�f�[�^�����X�g�\������ɂ́A��
% �̂悤�ɐݒ肵�܂��B
% 
%   [FieldList, ClassList, TypeString] = instfloat;
%
% ����: 
% �f�[�^�����́ANINST �s1��̃x�N�g���A�X�J���A�܂��́A��̂����ꂩ��
% ���͂ł��܂��B�x�N�g�����̎w��̂Ȃ����͂ɂ��ẮANaN �l�����͂���
% �܂��B���i�̐����ɂ́A������1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^
% �����͍폜�A�܂��́A��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A����
% �f�[�^�̃N���X�ɉ����āAFINARGPARSE ���g���ĉ��߂���܂��B�f�[�^��
% �N���X���Q�Ƃ���ɂ́A"[FieldList, ClassList] = instfloat"�ƃ^�C�v
% ���Ă��������B�Ȃ����t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t������
% �œ��͂��Ă��������B
%
%   Spread     - ������𒴂���x�[�V�X�|�C���g�̐��B
%   Settle     - ���ϓ�
%   Maturity   - ������
%   Reset      - �N�ɉ��񖞊����K��邩�̕p�x�ł��B�f�t�H���g��1�B
%   Basis      - �����J�E���g��B�f�t�H���g��0(actual/actual)
%   Principal  - �z�茳�{(���ڌ��{)�B
%   
% �o��:
%   ISet       - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A��
%                �̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h
%                ��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h��
%                ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A�������
%                �Ȃ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ��ẮA
%                "help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList  - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂����X
%                �g�\�����镶����ō\������� NFIELDS �s1��̃Z���z��B
% 
%   ClassList  - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                NFIELDS�s1��̃Z���z��A�����ɋL�ڂ����f�[�^�N���X��
%                ����āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ����́A
%                'dble', 'date',  'char' �ł��B 
% 
%   TypeString - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                TypeString = 'float'.
%
% �Q�l : INSTBOND, INSTCAP, INSTSWAP, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 04/25/99
%   Copyright 1995-2002 The MathWorks, Inc. 
