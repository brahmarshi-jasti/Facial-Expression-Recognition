%testing video from webcam, detects face and outputs degree of inclinatio
%of face
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
frn=1;
for t=1:50
    nextFrame=vid.read();
    I=nextFrame;
    faceDetector = vision.CascadeObjectDetector('/home/ad/clandmark/LBP.xml');
    bboxes = step(faceDetector, I);  %[x y width height]
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
    figure(fig1);
    imshow(IFaces);
    
    bbox=[bboxes(:,1) bboxes(:,2) bboxes(:,1)+bboxes(:,3) bboxes(:,2)+bboxes(:,4) ]; %[x1 y1 x2 y2]
    n=size(bbox, 1); %no of faces detected
    
    
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
        deg
        %I_new=imrotate(I_temp, deg, 'bilinear', 'crop');
    end
    
    
    pause(0.1);
end 
vid.delete();
    