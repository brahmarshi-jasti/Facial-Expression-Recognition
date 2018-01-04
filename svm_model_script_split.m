%Automation script to train SVM model for different feature vectors on training set and stores all the models
%in a directory.
clear;
clc;
opdir='/home/ad/clandmark/trainedModels/RaFD';
olddir=cd;
for method={'HOG' 'LBP'}
    method=method{1};
    train_dir=['/home/ad/clandmark/FeatureVectors/RaFD/' method '/' method '_feature'];
    test_dir=['/home/ad/clandmark/FeatureVectors/RaFD/' method '/' method '_test'];
    
    for align={ 'aligned' 'noalign'}
        align=align{1};
        for expr={'all' 'nocontempt'}
            expr=expr{1};
            if strcmp(method, 'HOG')
                num='10_15';
            else
                num='10';
            end
            train_vector=[method '_' align '_split_' num '_' expr '_train.mat'];
            train_label=['Label_' align '_split_' num '_' expr '_train.mat'];
            test_vector=[method '_' align '_split_' num '_' expr '_test.mat'];
            test_label=['Label_' align '_split_' num '_' expr '_test.mat'];
            
            train_vector_dir=fullfile(train_dir,train_vector);
            train_label_dir=fullfile(train_dir,train_label);
            test_vector_dir=fullfile(test_dir,test_vector);
            test_label_dir=fullfile(test_dir,test_label);
            
            load(train_vector_dir);
            load(train_label_dir);
            load(test_vector_dir);
            load(test_label_dir);
            model=svmtrain( label_train, double(featureVector_train), '-c 1000 -g 0.05 ');
            [PredictLabel, accuracy, prob]=svmpredict(label_test, double(featureVector_test), model);
            filename=[ sprintf('Accuracy_%0.2f_', accuracy(1)) method '_' align '_split_' num '_' expr '_train.mat' ];
            cd(opdir);
            save(filename, 'model');
            cd(olddir);
            
        end    
    end
end