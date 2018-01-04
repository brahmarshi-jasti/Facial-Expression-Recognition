%generates both test and train feature vectors and label vecors for all the image folders and stores
%them as .mat files 
clear;
clc;
opdir_train='/home/ad/clandmark/FeatureVectors/RaFD/LBP/LBP_feature';
opdir_test='/home/ad/clandmark/FeatureVectors/RaFD/LBP/LBP_test';
indir_train='/home/ad/clandmark/Databases/RaFD/Database_gray_aligned/Training';
indir_test='/home/ad/clandmark/Databases/RaFD/Database_gray_aligned/Test';
olddir=cd;

cellSize=10;
%numBins=15;

file_train=[sprintf('LBP_aligned_split_%d_all_train',cellSize) '.mat'];
labelfile_train=[sprintf('Label_aligned_split_%d_all_train',cellSize) '.mat'];
file_test=[sprintf('LBP_aligned_split_%d_all_test',cellSize) '.mat'];
labelfile_test=[sprintf('Label_aligned_split_%d_all_test',cellSize) '.mat'];
featureVector_train=[];
label_train=[];
featureVector_test=[];
label_test=[];


for i=1:8
    %if i~=2
        folder = [sprintf('%d',i)];
        fullname = fullfile(indir_train,folder);
        cd(fullname);
        files=dir('*.jpg');

        for file=files'
            img=imread(file.name);
            f=extractLBPFeatures(img, 'CellSize', [cellSize cellSize]);
            featureVector_train=[featureVector_train; f];
            label_train=[label_train; i];
        end

        fullname = fullfile(indir_test,folder);
        cd(fullname);
        files=dir('*.jpg');

        for file=files'
            img=imread(file.name);
            f=extractLBPFeatures(img, 'CellSize', [cellSize cellSize]);
            featureVector_test=[featureVector_test; f];
            label_test=[label_test; i];
        end
    %end
        
    
end
cd(opdir_train);
save(file_train, 'featureVector_train');
save(labelfile_train, 'label_train');
cd(opdir_test);
save(file_test, 'featureVector_test');
save(labelfile_test, 'label_test');
cd(olddir);       