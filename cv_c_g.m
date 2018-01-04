%perform cross validation to find out values of C and G
load('newFeatureVectors300_nosplit_mrmr.mat');
load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature/HOG_aligned_nosplit_10_15_nocontempt.mat');
load('/home/ad/clandmark/FeatureVectors/RaFD/HOG/HOG_feature/Label_aligned_nosplit_10_15_nocontempt.mat');
folds = 10;
[C,gamma] = meshgrid(-5:2:15, -15:2:3);

%# grid search, and cross-validation
cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain(label_train, double(featureVector_train_300), sprintf('-c %f -g %f -v %d', 2^C(i), 2^gamma(i), folds));
end

%# pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);

%# contour plot of paramter selection
contour(C, gamma, reshape(cv_acc,size(C))), colorbar
hold on
plot(C(idx), gamma(idx), 'rx')
text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
    'HorizontalAlign','left', 'VerticalAlign','top')
hold off
xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')

%# now you can train you model using best_C and best_gamma
best_C = 2^C(idx);
best_gamma = 2^gamma(idx);

%values obtained after running it for 8 hrs- c=128, g=0.0020