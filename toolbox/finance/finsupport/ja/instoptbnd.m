% INSTOPTBND   'OptBond' �^�C�v���i�̍쐬�֐�
%
% ���B�I�v�V�����A�܂��́A�o�~���[�_�I�v�V�������w�肷��ɂ́A���̂悤
% �ɐݒ肵�܂��B
% 
%   InstSet = instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates)
%   InstSet = ....
%    instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates, AmericanOpt)
%
% �č��I�v�V�������w�肷��ɂ́A���̂悤�ɐݒ肵�܂��B
% 
%   InstSet = instoptbnd(BondIndex, OptSpec, Strike, ...
%           ExerciseDates, AmericanOpt)
%
%   'OptBond'���i�����i�ϐ��ɒǉ�����ɂ́A���̂悤�ɐݒ肵�܂��B
% 
%   InstSet = instoptbnd(InstSetOld, OptSpec, ... )
%
%   'OptBond' ���i�̃t�B�[���h���^�f�[�^�����X�g�\������ɂ́A���̂悤
%   �ɐݒ肵�܂��B
%   [FieldList, ClassList, TypeString] = instoptbnd;
%
% ����: 
% �x�N�g�����̎w��̂Ȃ��v�f�ɂ��ẮANaN �l�����͂���܂��B���i�̐���
% �ɂ́A������1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^�����͍폜�A�܂���
% ��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A���̓f�[�^�̃N���X�ɉ�����
% FINARGPARSE ���g���ĉ��߂���܂��B�f�[�^�̃N���X���Q�Ƃ���ɂ́A
% "[FieldList, ClassList] = instoptbnd" �ƃ^�C�v���Ă��������B�Ȃ��A
% ���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t������œ��͂��Ă��������B
%
%   BondIndex     - ���i���w������C���f�b�N�X������ NINST �s1��̃x�N�g
%                   ���A���̃x�N�g���Ŏ������ 'Bond' �^�C�v�̊�b���i��
%                   InstSet �ϐ��ɂ��L������܂��B���f�[�^�̎w��ɂ�
%                   �ẮA "help instbond" ���^�C�v���Ă��������B
% 
%   OptSpec       - 'Call'�A�܂��́A'Put' �̂����ꂩ�̕����񂩂�Ȃ� 
%                    NINST �s1��̃��X�g
%   
% ���B�A�܂��́A�o�~���[�_�I�v�V�����ɂ��ẮA���̃p�����[�^���K�p��
% ��܂��B
%
%   Strike        - �����s�g���i�� NINST �s NSTRIKES ��̍s��ł��B�s��
%                   �̊e�s�́A����I�v�V�����̃X�P�W���[���ƂȂ��Ă��܂��B
%                   �I�v�V������NSTRIKES �Ŏ�����錠���s�g�@��̉񐔂�
%                   ������Ȃ��ꍇ�A�s�̖����́ANaN �Ńp�f�B���O����܂��B
% 
%   ExerciseDates - �����s�g���t�� NINST �s NSTRIKES ��̍s��ł��B�s��
%                   �̊e�s�́A����I�v�V�����̃X�P�W���[���ƂȂ��Ă��܂��B
%                   ���B�I�v�V�����ł́A�����s�g���́A�I�v�V�����̊�����
%                   ����(������)��1���݂̂ł��B
% 
%   AmericanOpt   - NINST �s1��̃x�N�g���t���O�ł��B���B�A�܂��́A�o�~
%                   ���[�_�I�v�V�����ł́AAmericanOpt �́A�[���ɐݒ肵��
%                   ���BAmericanOpt ���ANaN �A�܂��́A�����͂̏ꍇ�A����
%                   �t���O�̓f�t�H���g��0�ɐݒ肳��܂��B
%
% �č��I�v�V�����ɂ��ẮA���̃p�����[�^���K�p����܂��B
%
%   Strike        - �e�I�v�V�����ɑΉ����錠���s�g���i�� NINST �s1��̃x
%                   �N�g��
%   ExerciseDates - �����s�g������ NINST �s 2 ��̃x�N�g���ł��B���̃x�N
%                   �g���̍s�Ɏ������2�̓��t�ԂɈʒu����N�[�|����(��
%                   ���́A����2�̓��t�̂����ꂩ�ƈ�v����N�[�|����)��
%                   ����΁A ������̓��ł��A���̏��i�ɂ��ăI�v�V����
%                   �̌������s�g���邱�Ƃ��ł��܂��B�l���ANaN �łȂ����t
%                   ��������1�������͂��ꂽ�ꍇ�A�܂��́AExerciseDates
%                   ���ANINST �s1��̃x�N�g���ł������ꍇ�A��b�،��̌�
%                   �ϓ��� ExerciseDate �Ŏw�肳�ꂽ�P��̓��t�Ƃ̊Ԃ̊�
%                   �Ԃɂ����āA�I�v�V�����̌����s�g�͉\�ł���Ɖ��߂�
%                   ��邱�ƂɂȂ�܂��B
%   AmericanOpt �@- NINST �s1��̃x�N�g���t���O�ł��B�č��I�v�V�����̏�
%                   ���AAmericanOpt ��1�ɐݒ肵�܂��BAmericanOpt ������
%                   �č��̌����s�g���[�����Ăяo���ꍇ�ɂ͕K�{�ƂȂ�܂��B
%   
% �o��:
%   ISet �@�@�@�@-�@���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A
%                   ���̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[
%                   ���h��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[
%                   ���h�́A���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A
%                   ������ƂȂ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ���
%                   �́A"help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList �@�@- ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂���
%                   �X�g�\�����镶����ō\������� NFIELDS �s1��̃Z���z
%                   ��B
% 
%   ClassList �@�@- �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                   NFIELDS �s1 ��̃Z���z��A�����ɋL�ڂ����f�[�^�N��
%                   �X�ɂ���āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ�
%                   ���́A'dble', 'date',  'char' �ł��B 
% 
%   TypeString �@ - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                   TypeString = 'Bond'.
%
% �Q�l : INSTADD, INSTGET, INSTDISP, HJMPRICE.


%   Author(s): M. Reyes-Kattar 04/25/99
%   Copyright 1995-2002 The MathWorks, Inc. 
