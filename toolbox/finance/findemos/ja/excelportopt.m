% EXCELPORTOPT   ���ϕ��U�L���t�����e�B�A���v�Z
%
% PortfOptResults = EXCELPORTOPT(AssetExpectedReturns, .....
%     AssetStandardDeviations, AssetCorrelationMatrix, .....
%     AssetUpperLowerBounds, AssetGroupConstraintMatrix, ....
%     FrontierReturns, PlotFlag)
% �́A����1�g�̎��Y�̊��Ҏ��v�A�W���΍��A���֍s�񂪗^����ꂽ�Ƃ��ɁA
% ���Y���Y�̕��ϕ��U�L���t�����e�B�A���v�Z���܂��B���̑��̃I�v�V����
% �����Ƃ��ẮA���Y�ɑ΂�����d�l�̏���l�A�����l�y�ю��Y�̉��d�l��
% ���`�����̏���A�������l�����܂��B
%
% EXCELPORTOPT �́A�|�[�g�t�H���I�œK���A�v���P�[�V�����ɂ���āA�R�[��
% ����邱�Ƃ��Ӑ}���Đ݌v���ꂽ PORTOPT �̈�̃o�[�W�����ł��B
%
% ����: 
% AssetExpectedReturns �́A�e���Y�̊��Ҏ��v���܂ރx�N�g���ł��B
%
% AssetStandardDeviations �́A�e���Y�̕W���΍����܂ރx�N�g���ł��B
%     
% AssetCorrelationMatrix �́A�e���Y�̗��𑊊�(historical correlation)�s
% ��ł��B
%     
% AssetUpperLowerBounds �́A�e���Y�̉��d�l�̏���y�щ����l���܂ލs��ł�
% (N�s2��̍s��, �����ŁAN �́A���Y����\���Ă��܂�)�B
%
% AssetGroupConstraintMatrix �́A���Y�ɑ΂�����d�l�̐��`�����̏���A
% �������w�肷��l����Ȃ�s��ł��B
%
% FrontierReturns (�I�v�V����)�́A�t�����e�B�A�֐��̕]���ɗp���������
% ���v�̃x�N�g���ł��B
%
% ���ӁF 
% �s�� AssetGroupConstraintMatrix �̊e�s�́A���Y������̒��ɂ��邩�ǂ���
% �������Ă��܂�(���Y���܂܂�Ă���Ƃ���1�C�܂܂�Ă��Ȃ��Ƃ���0�ł�)�B
% AssetRows �́A�^����ꂽ���Ҏ��v�y�ѕW���΍��Ɠ���̎����Ő�����Ɖ���
% ����܂��B���Y���������Ȃ����̍s�����Ȃ��ꍇ�A�Ō�̍s�𒴂��鎑�Y��
% �΂��Ă͒l0���K�p����܂��B
%
% �o��: 
% PortfolioOptimizationResults �́A�t�����e�B�A��̓_�ɑΉ�������Ҏ��v�A
% �W���΍��A���d�l����Ȃ�s��ł��B


%   Author(s) : D. Eiler, 09-30-96
%   Copyright 1995-2002 The MathWorks, Inc. 
