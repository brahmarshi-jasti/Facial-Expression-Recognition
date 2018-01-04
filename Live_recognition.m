%Performs facial expression recognition on video input from webCam. uses
%mexopenCV for videoInput
clear; 
clc;
addpath('/home/ad/clandmark/learning/flandmark/code/functions/');
model = '/home/ad/clandmark/data/flandmark_model.xml';
T = flandmark_xmlread(model);
flandmark = flandmark_class(model);
fig1=figure;
fig2=figure;
set(fig2, 'Visible', 'off'); 
vid=cv.VideoCapture(0);
%pause(2);
if ~vid.isOpened()
    error('Camera failed to initialize.');
end
for t=1:150
    nextFrame=vid.read();
    I=nextFrame;
    faceDetector = vision.CascadeObjectDetector('/home/ad/clandmark/LBP.xml');
    bboxes = step(faceDetector, I);  %[x y width height]    
    bbox=[bboxes(:,1) bboxes(:,2) bboxes(:,1)+bboxes(:,3) bboxes(:,2)+bboxes(:,4) ]; %[x1 y1 x2 y2]
    n=size(bbox, 1);%no of faces detected
    expr=cell(n,1);
    key=['Anger   ';'Contempt'; 'Disgust ';'Fear    ';'Happy   ';'Neutral ';'Sad     ';'Surprise'];
    key=cellstr(key);
    for i = 1 : n   %for each face separately
        figure(fig2);
        %set(gcf, 'Visible', 'off');
        frame=[bboxes(i,1)-20, bboxes(i,2)-20, bboxes(i,3)+40, bboxes(i,4)+40 ];%image frame to crop image, 10 pixels extra on each side of face
        I_temp=imcrop(I, frame);
        Ibw_temp=rgb2gray(I_temp);
        bbox_temp=[1 1 size(Ibw_temp,2) size(Ibw_temp,1) ];
        P = flandmark.detect(Ibw_temp, int32(bbox_temp(1, :)));        
        comps = {}; for a = 1 : flandmark.getLandmarksCount(); comps{end+1} = ['S' num2str(a)]; end;
        X=[P(1,6) P(1,2) P(1,3) P(1,7) ];
        Y=[P(2,6) P(2,2) P(2,3) P(2,7) ];
        scatter(X, Y);
        
        figure(fig1);
        p=polyfit(X,Y,1);
        y= p(1).*X + p(2);
        deg=atand(p(1));
        I_new=imrotate(I_temp, deg, 'bilinear', 'crop');
        rect=[20 20 size(I_new, 2)-40 size(I_new, 1)-40];
        I_new=imcrop(I_new, rect);
        I_new=imresize(I_new, [128 128]);
        f=extractHOGFeatures(I_new, 'CellSize', [10 10], 'NumBins', 15);
        %load('three_hundred_indices_mrmr.mat');
        %f_300=[];
        %for k=1:300
        %    j=selectedIndices(k);
        %    f_300= [f_300 f(:,j)];
        %end
        
        %load('/home/ad/clandmark/trainedModels/RaFD/trainedmodel_final.mat');
        %load('trainedmodel_final_300_mrmr.mat');
        load('trainedmodel_final.mat');
        label=[2.0];
        [PredictLabel, accuracy, prob]=svmpredict(double(label), double(f), model);
        val=PredictLabel(1,1);
        expr{i}=key{val};
       
    end
    figure(fig1);
    if i~=0
        IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, expr);
        imshow(IFaces);
    else
        imshow(I);
    end;
    
    pause(0.1);
end 
vid.delete();
    
    