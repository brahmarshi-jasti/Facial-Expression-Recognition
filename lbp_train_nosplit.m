%generates train feature vector and label vectors for all the images in a class together and stores
%them as .mat files 
clear;
clc;
opdir_train='/home/ad/clandmark/FeatureVectors/RaFD/LBP/LBP_feature';
indir_train='/home/ad/clandmark/Databases/RaFD/Database_gray_aligned/both';
olddir=cd;

cellSize=10;
%numBins=15;

file_train=[sprintf('LBP_aligned_nosplit_%d_nocontempt',cellSize) '.mat'];
labelfile_train=[sprintf('Label_aligned_nosplit_%d_nocontempt',cellSize) '.mat'];
featureVector_train=[];
label_train=[];


for i=1:8
    if i~=2
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

    end
        
    
end
cd(opdir_train);
save(file_train, 'featureVector_train');
save(labelfile_train, 'label_train');
cd(olddir);