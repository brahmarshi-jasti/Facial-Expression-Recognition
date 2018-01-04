%generate just the train vector and label from all folders of database.
%Prefer the hog_train_test file
clear;
clc;
opdir='/home/ad/clandmark/HOG_feature';
indir='/home/ad/clandmark/Database_rgb/no_align';
olddir=cd;
filename='HOG__noalign_201_10_15.mat';
file_label='Label__noalign_201_10_15.mat';
featureVector=[];
label=[];

cellSize=10;
numBins=15;
for i=1:8
    folder = [sprintf('%d',i)];
    fullname = fullfile(indir,folder);
    cd(fullname);
    files=dir('*.jpg');
    
    for file=files'
        img=imread(file.name);
        f=extractHOGFeatures(img, 'CellSize', [cellSize cellSize], 'NumBins', numBins);
        featureVector=[featureVector; f];
        label=[label; i];
    end
end
cd(opdir);
save(filename, 'featureVector');
save(file_label, 'label');
cd(olddir);