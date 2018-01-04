%Aligns the face and neatly crops the face and shows the working (for one single image.) 
clear; 
clc;

addpath('/home/ad/clandmark/learning/flandmark/code/functions/');
model = '/home/ad/clandmark/data/flandmark_model.xml';
T = flandmark_xmlread(model);
flandmark = flandmark_class(model);


I=imread('new8.jpg');
faceDetector = vision.CascadeObjectDetector('/home/ad/clandmark/LBP.xml');
faceDetector.MergeThreshold = 5;
bboxes = step(faceDetector, I);  %[x y width height]
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
fig1=figure, imshow(IFaces), title('Detected faces');
fig2=figure, imshow(I), title('Initial Bounding box and Normalizing frame.');
hold on;
bbox=[bboxes(:,1) bboxes(:,2) bboxes(:,1)+bboxes(:,3) bboxes(:,2)+bboxes(:,4) ]; %[x1 y1 x2 y2]
n=size(bbox, 1); %no of faces detected
for i = 1 : n   %for each face separately
    figure(fig2);
    plotbox(bbox(i,:));
    frame=[bboxes(i,1)-20, bboxes(i,2)-20, bboxes(i,3)+40, bboxes(i,4)+40 ];%image frame to crop image, 20 pixels extra on each side of face
    I_temp=imcrop(I, frame);
    Ibw_temp=rgb2gray(I_temp);
    frame1=[bbox(i,1)-10, bbox(i,2)-10, bbox(i,3)+10, bbox(i,4)+10 ]; %this is just for plotting the frame using plotbox
    plotbox(frame1);
    fig3=figure;
    figure(fig3);
    imshow(I_temp), title('The image fed to flandmarks and the new BBox');
    hold on;
    bbox_temp=[1 1 size(Ibw_temp,2) size(Ibw_temp,1) ];
    P = flandmark.detect(Ibw_temp, int32(bbox_temp(1, :)));        
    comps = {}; for a = 1 : flandmark.getLandmarksCount(); comps{end+1} = ['S' num2str(a)]; end;
    X=[P(1,6) P(1,2) P(1,3) P(1,7) ];
    Y=[P(2,6) P(2,2) P(2,3) P(2,7) ];
    scatter(X, Y);
    p=polyfit(X,Y,1);
    y= p(1).*X + p(2);
    plot(X, y, '-');
    deg=atand(p(1));
    I_new=imrotate(I_temp, deg, 'bilinear', 'crop');
    rect=[20 20 size(I_new, 2)-40 size(I_new, 1)-40];
    I_new=imcrop(I_new, rect);
    figure, imshow(I_new);    
end;