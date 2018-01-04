%generates train feature vector and label vectors for all the images in a class together and stores
%them as .mat files 
clear;
clc;
opdir_train='/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature';
indir_train='/home/ad/clandmark/Databases/RaFD/Database_rgb_aligned/both';
olddir=cd;

cellSize=10;
numBins=15;

file_train=[sprintf('HOG_aligned_nosplit_%d_%d_all',cellSize, numBins) '.mat'];
labelfile_train=[sprintf('Label_aligned_nosplit_%d_%d_all',cellSize, numBins) '.mat'];
featureVector_train=[];
label_train=[];


for i=1:8
    %if i~=2
        folder = [sprintf('%d',i)];
        fullname = fullfile(indir_train,folder);
        cd(fullname);
        files=dir('*.jpg');

        for file=files'
            img=imread(file.name);
            f=extractHOGFeatures(img, 'CellSize', [cellSize cellSize], 'NumBins', numBins);
            featureVector_train=[featureVector_train; f];
            label_train=[label_train; i];
        end

    %end
        
    
end
cd(opdir_train);
save(file_train, 'featureVector_train');
save(labelfile_train, 'label_train');
cd(olddir);