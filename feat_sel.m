%feature selection using FEAST
clc;
clear;
load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature/HOG_aligned_split_10_15_nocontempt_train.mat');
load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature/Label_aligned_split_10_15_nocontempt_train.mat');
selectedIndices = feast('mrmr',300,double(featureVector_train*100),label_train);