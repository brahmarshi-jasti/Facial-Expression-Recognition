This file describes what each of the files listed below do.
align_crop.m : Aligns the face and neatly crops the face and shows the working (for one single image.) 

align_crop_save.m : Align and crop images from database, and resize them (and optionally rgb2gray) and save for feature extraction

testcam.m : testing video from webcam, detects face and outputs degree of inclination of face

Live_recognition.m : Performs facial expression recognition on video input from webCam. uses mexopenCV for videoInput 

crop.m : to only crop images, and resize them (and optionally rgb2gray) and save for feature extraction, automatically taking images from all folders. add exceptions in loop to exclude some

cv_c_g.m :perform 10 fold cross validation to find out values of C and gamma in svmtrain

feat_sel.m : %feature selection using FEAST

hog_trainVector.m : generate just the train vector and label from all folders of database. Prefer the hog_train_test file

hog_train_nosplit.m : generates train feature vector and label vectors for all the images in a class together and stores them as .mat files 

hog_train_test_split.m : generates both test and train feature vectors and label vecors for all the image folders and stores them as .mat files 

lbp_train_nosplit.m : generates train feature vector and label vectors for all the images in a class together and stores them as .mat files 

lbp_train_test_split.m : generates both test and train feature vectors and label vecors for all the image folders and stores them as .mat files 

svm_train_testSet_accuracy.m : train a model using libSVM and test it to find test set accuracy

svm_model_script_split.m : Automation script to train SVM model for different feature vectors on training set and stores all the models in a directory.

svm_model_script_nosplit.m : Automation script to train SVM model for different feature vectors on complete dataset for n-fold cross validation and stores all the models in a directory.