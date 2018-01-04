%to align and crop images from database, and resize them (and optionally rgb2gray) and save for feature extraction 
clear; 
clc;
set(gcf,'visible','off');
addpath('/home/ad/clandmark/learning/flandmark/code/functions/');
model = '/home/ad/clandmark/data/flandmark_model.xml';
T = flandmark_xmlread(model);
flandmark = flandmark_class(model);

%mkdir('/home/ad/clandmark/outputimages/8');
opdir='/home/ad/clandmark/outputimages/1';
olddir=cd;
cd('/home/ad/clandmark/RaFD Database/1');
files = dir('*.jpg');
for file = files'
    
    I=imread(file.name);
    faceDetector = vision.CascadeObjectDetector('/home/ad/clandmark/LBP.xml');
    bboxes = step(faceDetector, I);  %[x y width height]
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
    bbox=[bboxes(:,1) bboxes(:,2) bboxes(:,1)+bboxes(:,3) bboxes(:,2)+bboxes(:,4) ]; %[x1 y1 x2 y2]
    n=size(bbox, 1); %no of faces detected
    
    for i = 1 : n   %for each face separately
        
        frame=[bboxes(i,1)-20, bboxes(i,2)-20, bboxes(i,3)+40, bboxes(i,4)+40 ];%image frame to crop image, 10 pixels extra on each side of face
        I_temp=imcrop(I, frame);
        Ibw_temp=rgb2gray(I_temp);
        bbox_temp=[1 1 size(Ibw_temp,2) size(Ibw_temp,1) ];
        P = flandmark.detect(Ibw_temp, int32(bbox_temp(1, :)));        
        comps = {}; for a = 1 : flandmark.getLandmarksCount(); comps{end+1} = ['S' num2str(a)]; end;
        X=[P(1,6) P(1,2) P(1,3) P(1,7) ];
        Y=[P(2,6) P(2,2) P(2,3) P(2,7) ];
        scatter(X, Y);
        p=polyfit(X,Y,1);
        y= p(1).*X + p(2);
        deg=atand(p(1));
        I_new=imrotate(I_temp, deg, 'bilinear', 'crop');
        rect=[20 20 size(I_new, 2)-40 size(I_new, 1)-40];
        I_new=imcrop(I_new, rect);
        fullname = fullfile(opdir,file.name);
        I_new=imresize(I_new, [128 128]);
        I_new=rgb2gray(I_new);
        imwrite(I_new,fullname);
        
    end; 

    
end

cd(olddir);
