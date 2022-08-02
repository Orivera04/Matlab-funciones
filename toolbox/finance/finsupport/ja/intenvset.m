% INTENVSET   ���q���ԍ\���̑�����ݒ�
%
%   [RateSpec, RateSpecOld] = intenvset('Parameter1', Value1 , ...
%       'Parameter2' , Value2 , ...)
%   [RateSpec, RateSpecOld] = intenvset(RateSpec , ....
%             'Parameter1' , Value1 , ...)
%
% �ŏ��̎g�p�@�́A���͈������X�g���p�����[�^�ƒl�̑g�Ŏw�肳��Ă��闘�q
% ���ԍ\��(RateSpec)�𐶐����܂��B�p�����[�^/�l�̑g���\������p�����[�^
% ���́A�o�͍\�� RateSpec �̓K�؂ȃt�B�[���h�Ƃ��ĔF������Ȃ���΂Ȃ�
% �܂���B�Ȃ��A�p�����[�^/�l�̑g���\������l�̕����́A���̂Ƃ��w�肳�ꂽ
% �p�����[�^���A�w�肳�ꂽ�l�����悤�Ȍ`�ŁA�y�A��g�ރp�����[�^�Ɋ���
% ���Ă��Ă��܂��B�Ȃ��A�p�����[�^���̐擪�̐��������^�C�v���邾���ŁA
% �p�����[�^���\�����肷�邱�Ƃ��ł��܂��B�p�����[�^���ł̑啶���A������
% �̋�ʂ͖�������܂��B�K�؂ȃp�����[�^�̃t�B�[���h�̃��X�g�́A�ȉ���
% �Q�Ƃ��Ă��������B
%
% ��Ԗڂ̎g�p�@�́A�w�肳�ꂽ�p�����[�^���w�肵���l�ɕύX���邱�Ƃ�
% ����āA�����̗��q���ԍ\�� RateSpec ���C������ۂɗp������̂ł��B
%   
% ���͈����y�яo�͈��������町��Ȃ��`�ŁAintenvset ���R�[�������ꍇ�A
% �S�Ẵp�����[�^���Ƃ����̃p�����[�^����蓾��l�Ɋւ������\��
% ���܂��B
%
% ����:
%   Parameter    - �o�͍\�� RateSpec �ɓK�؂ȃp�����[�^�t�B�[���h(�ȉ���
%                  �Q�Ƃ̂���)��\�����镶����ł��B
%   Value        - �Ή�����p�����[�^�Ɋ��蓖�Ă�ꂽ�l�ł��B
%   RateSpec     - �ύX�̑ΏۂƂȂ�����̗��q���ԍ\���ł��B�����炭����
%                  ���q���ԍ\���́AINTENVSET �����O�Ɏ��s�����Ƃ��ɐ���
%                  ���ꂽ���̂ł���ƍl�����܂��B
%
%   INTENVSET�̃p�����[�^���͎��̒ʂ�ł��B
%   Compounding  - �N�����Z���ɁA���͂��ꂽ�[�������ǂ̂悤�ȓx���ŕ���
%                  �v�Z���邩�������X�J���l�ł��B�f�t�H���g��2�ł��B
%     Disc       - StartDates(�L���b�V���t���[�̉��i�����肳�����t)��
%                  �� EndDates(�L���b�V���t���[���󂯎����)�܂ł̓���
%                  ��Ԃɂ�����P�ʍ����i������NPOINTS �sNCURVES���
%                  �s��ł��B 
%     Rates      - �����^�œ��͂���NPOINTS �s NCURVES��̍s��ł��BRates
%                  �́AStartDates(�L���b�V���t���[�̉��i�����肳�����t)
%                  ���� EndDates(�L���b�V���t���[���󂯎����)�܂ł�
%                  ������Ԃɂ����闘���ł��B
%     EndDates   - �������K�p������Ԃ��I��閞����������NPOINTS�s1��
%                  �x�N�g���A�܂��́A�X�J���ł��B
%     StartDates - �������K�p������Ԃ��n�܂���t������NPOINTS�s1��
%                  �̃x�N�g���A�܂��́A�X�J���ł��B
%     ValuationDate  - 
%                  StartDates �� EndDates �œ��͂��ꂽ�������E�̊ϑ���
%                  (observation date)���V���A�����t�`���Ŏ����X�J���l��
%                  ���B�f�t�H���g�� min(StartDates)�ł��B
%     Basis      - �����̃J�E���g��ł��B�f�t�H���g��"0" 
%                  ( Actual/Actual)
%     EndMonthRule  - 
%                  �����K���ł��B�f�t�H���g��"1" (�����K���͗L��)
%
% �V����RateSpec�𐶐�����Ƃ��Aintenvset�Ɏ󂯌p�����p�����[�^�̑g��
% �́A�K��StartDates, EndDates�y��Rates�A�܂��́ADisc�̂����ꂩ���܂܂�
% �Ȃ���΂Ȃ�܂���B
%
%% �o�́F
%   RateSpec    - ���q���ԍ\���̑������Ȗ񂷂�`�ō��ꂽ�\���ł��B
%   RateSpecOld - INTENVSET �̎��s�ɂ���ĕύX����������ȑO�̗��q����
%                 �\���̑������Ȗ񂵂��\���ł��B
%
% ���:
%   [RateSpec] = intenvset('Rates', 0.05, 'StartDates', ....
%                '20-Jan-2001', 'EndDates', '20-Jan-2001')
%   [RateSpec] = intenvset(RateSpec, 'Compounding', 1)
% 
% ����:
% ���͈����y�яo�͈��������蓖�Ă���intenvset���Ăяo���ƁA�S�Ẵp��
% ���[�^���Ƃ����̂Ƃ肤��l�Ɋւ������\�����܂��B
%
% �Q�l : INTENVGET.


%   Author(s): M. Reyes-Kattar, J. Akao 02/08/99
%   Copyright 1995-2002 The MathWorks, Inc. 
