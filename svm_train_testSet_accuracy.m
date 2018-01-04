%train a model using SVM and test it to find test set accuracy
clear;
clc;
%load('newFeatureVectors300_split_mrmr.mat');
load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature/HOG_aligned_split_10_15_nocontempt_train.mat');
load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature/Label_aligned_split_10_15_nocontempt_train.mat');
%load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_test/Label_aligned_split_10_15_nocontempt_test.mat');
model=svmtrain( label_train, double(featureVector_train), '-c 128 -g 0.002');
save('trainedmodel_final.mat', 'model');

%[PredictLabel, accuracy, prob]=svmpredict(label_test, double(featureVector_test_300), model);
