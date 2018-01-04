%to only crop images, and resize them (and optionally rgb2gray) and save
%for feature extraction, automatically taking images from all folders. add
%exceptions in loop to exclude some
clear; 
clc;
set(gcf,'visible','off');
%mkdir('/home/ad/clandmark/outputimages/8');

for i=1:8
    folder = [sprintf('%d',i)];
    opdir_parent='/home/ad/clandmark/outputimages';
    opdir = fullfile(opdir_parent,folder);
    olddir=cd;
    indir_parent='/home/ad/clandmark/RaFD Database';
    indir=fullfile(indir_parent, folder);
    cd(indir);
    files = dir('*.jpg');
    for file = files'

        I=imread(file.name);
        faceDetector = vision.CascadeObjectDetector('/home/ad/clandmark/LBP.xml');
        bboxes = step(faceDetector, I);  %[x y width height]
        I_new=imcrop(I, bboxes);
        fullname = fullfile(opdir,file.name);
        I_new=imresize(I_new, [128 128]);
        I_new=rgb2gray(I_new);
        imwrite(I_new,fullname); 
    end
    cd(olddir);
end
