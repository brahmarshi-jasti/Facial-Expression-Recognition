%performs 10-cv training on non split feature vector and outputs accuracy 
%for all split feature vectors
clear;
clc;
opdir='/home/ad/clandmark/trainedModels/RaFD/nosplit';
olddir=cd;
for method={'HOG' 'LBP'}
    method=method{1};
    train_dir=['/home/ad/clandmark/FeatureVectors/RaFD/' method '/' method '_feature'];
    
    for align={ 'aligned' 'noalign'}
        align=align{1};
        for expr={'all' 'nocontempt'}
            expr=expr{1};
            if strcmp(method, 'HOG')
                num='10_15';
            else
                num='10';
            end
            train_vector=[method '_' align '_nosplit_' num '_' expr '.mat'];
            train_label=['Label_' align '_nosplit_' num '_' expr '.mat'];
            
            train_vector_dir=fullfile(train_dir,train_vector);
            train_label_dir=fullfile(train_dir,train_label);
          
            load(train_vector_dir);
            load(train_label_dir);

            cva=svmtrain( label_train, double(featureVector_train), '-c 1000 -g 0.05 -v 10')
            filename=[ sprintf('Accuracy_%0.2f_', cva) method '_' align '_nosplit_' num '_' expr ];
            cd(opdir);
            save(filename, 'cva');
            cd(olddir);
            
        end    
    end
end