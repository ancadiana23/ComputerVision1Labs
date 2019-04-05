
display('Loading data ...')
test_data = load('stl10_matlab/test.mat');
train_data = load('stl10_matlab/train.mat');

[test_image_count, ~] = size(test_data.X);
[train_image_count, ~] = size(train_data.X);

% Set of global variables
CLUSTER_COUNT = 2000; % 400, 1000, 4000; number of KNN cluster
SIFT_SAMPLING = "dense"; % "keypoint", "dense"
SIFT_COLOR = "opponent"; % "gray", "rgb", "opponent"

% Data Preprocessing
display('Data Preprocessing...')
tic
% reshape and store the 8000 test_images in a (8000, 96, 96, 3) sized
% vector
test_images_raw_data = reshape(test_data.X, test_image_count, 96, 96, 3);
test_class_label = test_data.y;

% reshape and store the 5000 train_images in a (5000, 96, 96, 3) sized
% vector
train_images_raw_data = reshape(train_data.X,train_image_count, 96, 96, 3);
train_class_label = train_data.y;

% Extract data from 5 classes (airplanes, birds, cars, horses, ships) for
% the training data.

% Now we need to extract the data relevant to us (the following classes):
% airplanes (class/label 1)
% birds (class/label 2)
% cars (class/label 3)
% horses (class/label 7)
% ships (class/label 9)

% each of the classes has 500 training images (and 800 test images) So here
% we eliminate all the data from irrelevant classes (we keep 5 out of 10
% classes) See above for 'label-class' assignment.
test_images_raw_data = test_images_raw_data(test_class_label == 1 ...
    | test_class_label == 2 ...
    | test_class_label == 3 ...
    | test_class_label == 7 ...
    | test_class_label == 9,:,:,:);
% and the labels ...
test_class_label = test_class_label(test_class_label == 1 ...
    | test_class_label == 2 ...
    | test_class_label == 3 ...
    | test_class_label == 7 ...
    | test_class_label == 9);

% Here we separate the training data into the classes
train_images_cl_air = train_images_raw_data(train_class_label==1,:,:,:);
train_images_cl_birds = train_images_raw_data(train_class_label==2,:,:,:);
train_images_cl_cars = train_images_raw_data(train_class_label==3,:,:,:);
train_images_cl_horses = train_images_raw_data(train_class_label==7,:,:,:);
train_images_cl_ships = train_images_raw_data(train_class_label==9,:,:,:);


% Before we want to train a BoW based Image Classifier, we need to do the
% following:
%   1. Save all train and test images in an array
%   2. Preprocess, depending on the vl_sift method we use
%       2.1 into 'Single'
%       2.2 RGB
%       2.3 oponent-SIFT?
%
% Output: Array of images ready to use vl_sift on
%       For now: only normal sift (in gray form)

% Creating cells to store the vl_sift data
% 'test_images_sift{i}' contains vl_sift result of test image i


% 2.1 Feature extraction:

% take subset of the data: (800 test and 500 train)

% using 'vl_sift' we create cells of the vl_sift data, namely
% 'test_images_sift' and 'test_images_descr' and also the array
% 'test_descr_matrix' that concatenates the descriptor data.

% There are 2500 train images and 4000 test images in total (500/800 per class)
% Here we define the number of images for training the clustering (K-means)
% needs to be multiples of 5 and below 2500
% test_image_count = 800;
train_image_count_cluster = 1000;

cluster_train_images = cat(1, ...
    train_images_cl_air(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_birds(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_cars(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_horses(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_ships(1:train_image_count_cluster/5,:,:,:));
toc

display('Gathering image descriptor data for training K-means...')
tic
% Here we save the vl_sift results and concatenate the descriptor data in a
% matrix, so we can apply k-means on it.
cluster_train_descr_matrix = [];


for i = 1:train_image_count_cluster
   train_images_descr = my_sift(cluster_train_images(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
   cluster_train_descr_matrix = [cluster_train_descr_matrix; train_images_descr'];
end

display('cluster_train_descr_matrix')
size(cluster_train_descr_matrix)
toc

% using vl_sift data , we use knn clustering to cluster
% all the descriptors (we have multiple descriptors for each image), so we
% get a lot of descriptors and the clustering does not cluster images, but
% descriptors.

% C is then a CLUSTER_COUNTx128 matrix, where the rows are the cluster
% centres
display('Training Kmeans...')
tic
[~, C] = kmeans(double(cluster_train_descr_matrix), CLUSTER_COUNT); 
size(C)
toc 
% for 500 images and 400 cluster it takes ~22 seconds

% This cluster defines a vocabulary: one cluster is one word. 
% 1 image = set of words

% define function 'find_cluster_vector' that returns the normalized cluster 
% representation of an image (returns an 1xCLUSTER_COUNT array). (It uses 
% the internal function "get_closest_cluster" which returns the
% corresponding cluster for each descriptor.)
% -> we need train_image_count x CLUSTER_COUNT array
% looking at all possible cluster centre seems to be the easiest way to
% implement this.

% 'find_cluster_vector' will be used in the next step: Encoding


% 2.3 Encoding Features Using Visual Vocabulary
% using this clustering, we can represent each image as a collecion of
% words:
% 1. extract descriptors 
% 2. assign word to each descriptor

display('Assigning cluster to the training data...')
tic

svm_train_images_bow_hist_air = [];
svm_train_images_bow_hist_birds = [];
svm_train_images_bow_hist_cars = [];
svm_train_images_bow_hist_horses = [];
svm_train_images_bow_hist_ships = [];


%svm_train_descr_matrix = [];


% 2.4 Representing images by frequencies of visual words
% 1. represent image by words and their frequencies (histogram of its visual words)
% 2. normalize histogram
% This is all done in the 'find_cluster_vector'-function



% for i = (train_image_count_cluster/5+1):train_image_count/5

% Here we create the words for the different class-images. These will be
% used for training the SVMs

training_size = 2500 - train_image_count_cluster;
training_size
for i = train_image_count_cluster/5+1:2500/5
   descr = my_sift(train_images_cl_air(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_air = cat(1,svm_train_images_bow_hist_air,cluster_vector);
   
   descr = my_sift(train_images_cl_birds(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_birds = cat(1,svm_train_images_bow_hist_birds,cluster_vector);
   
   descr = my_sift(train_images_cl_cars(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_cars = cat(1,svm_train_images_bow_hist_cars,cluster_vector);
   
   descr = my_sift(train_images_cl_horses(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_horses = cat(1,svm_train_images_bow_hist_horses,cluster_vector);
   
   descr = my_sift(train_images_cl_ships(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_ships = cat(1,svm_train_images_bow_hist_ships,cluster_vector);
   
   %train_descr_matrix = [train_descr_matrix; train_images_descr{i}'];
end
toc


%size(svm_train_images_bow_hist_ships)


% 2.5 Classification
% After representing every image as a histogram over the vocabulary we can
% train a SVM classifier for image classification. We train the SVM on data
% we have not used for the clustering and apply the SVM on the BoWs,
% which are vectors of size CLUSTER_COUNT.
% 1. Train a SVM classifier for each object class (-> 5 binary classifiers)
%   1.1 Create set of positive examples
%      1.1.1 Take images of this class that we did not use for clustering
%           (use at least 50 training images of this class)
%      1.1.2 Represent them with histograms 
%   1.2 Create a set of negative examples
%      1.2.1 Take images from other classes we did not use for clustering
%           (use at least 50 training images per other class -> in sum at least 200)
%   1.3 Train SVM classifier for this class
%vl_compilenn
% To classify image, apply all 5 SVM classifier to it and take the class
% with the highest probability.

% current data size for testing = 250 for every svm training (50 per class, we use the same ones here)
display('Training all 5 SVMModels...')
tic

% Creating training labels
Y_air = zeros(1,training_size);
Y_air(1:training_size/5) = ones(1,training_size/5);

Y_birds = zeros(1,training_size);
Y_birds(training_size/5+1:training_size/5*2) = ones(1,training_size/5);

Y_cars = zeros(1,training_size);
Y_cars(training_size/5*2+1:training_size/5*3) = ones(1,training_size/5);

Y_horses = zeros(1,training_size);
Y_horses(training_size/5*3+1:training_size/5*4) = ones(1,training_size/5);

Y_ships = zeros(1,training_size);
Y_ships(training_size/5*4+1:training_size/5*5) = ones(1,training_size/5);

% Creating the training dataset (training_size/5 of each)

X = [
    svm_train_images_bow_hist_air(1:training_size/5,:);
    svm_train_images_bow_hist_birds(1:training_size/5,:);
    svm_train_images_bow_hist_cars(1:training_size/5,:);
    svm_train_images_bow_hist_horses(1:training_size/5,:);
    svm_train_images_bow_hist_ships(1:training_size/5,:)];

size(X)

hAxes = axes( figure ); % I usually use figure; hAxes = gca; here, but this is even more explicit.
hImage = imshow(rgb2gray(squeeze(train_images_cl_air(i,:,:,:))), 'Parent', hAxes);


size(Y_air')
SVMModel_air = fitcsvm(X,Y_air','Standardize',true,'Cost',[0 1;4 0], 'ClassNames',[1,0],'KernelFunction','linear');
SVMModel_birds = fitcsvm(X,Y_birds','Standardize',true,'Cost',[0 1;4 0], 'ClassNames',[1,0],'KernelFunction','linear');
SVMModel_cars = fitcsvm(X,Y_cars','Standardize',true,'Cost',[0 1;4 0], 'ClassNames',[1,0],'KernelFunction','linear');
SVMModel_horses = fitcsvm(X,Y_horses','Standardize',true,'Cost',[0 1;4 0], 'ClassNames',[1,0],'KernelFunction','linear');
SVMModel_ships = fitcsvm(X,Y_ships','Standardize',true,'Cost',[0 1;4 0], 'ClassNames',[1,0],'KernelFunction','linear');
toc

display('Initiating testing phase...')
display('Finding cluster vectors of testing data ...')
tic
% test_images_raw_data = reshape(test_data.X, test_image_count, 96, 96, 3);
% test_classes_label = test_data.y;
test_data_count = 500;

test_data = test_images_raw_data(1:test_data_count,:,:,:);
test_label = test_class_label(1:test_data_count);
% test_hist represents the histograms of the test data. On these histograms
% we will apply the SVM classifier.
test_hist = [];
for i = 1:test_data_count
    descr = my_sift(test_data(i,:,:,:), SIFT_SAMPLING, SIFT_COLOR);
    cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
    test_hist = [test_hist; cluster_vector];
end
display('test_hist')
size(test_hist)

toc
% -> compute histograms for the test data
display('Predict Scores ...')
tic
% define our test_data
newX = test_hist;


% score_air etc. are a nx2 array, where the second column are the
% probabilities of a positive prediction
[~ , score_air] = predict(SVMModel_air,newX);
[~ , score_birds] = predict(SVMModel_birds,newX);
[~ , score_cars] = predict(SVMModel_cars,newX);
[~ , score_horses] = predict(SVMModel_horses,newX);
[~ , score_ships] = predict(SVMModel_ships,newX);
toc
%score_air
%[air_sort, air_order] = sort(score_air(:,2));
%air_sort
%test_label_sorted = test_label(air_order,:);
%test_data_sorted = test_data(air_order,:,:,:);

display('Sort scores, label data and image data and computing mAP...')
tic
size(score_air)
[sorted_air_score, air_order] = sort(score_air(:,2));
data_sorted_air = test_data(air_order,:,:,:);
label_sorted_air = test_label(air_order,:);
label_sorted_air = label_sorted_air == 1;
mAP_air = get_map(label_sorted_air);

size(score_birds)
[sorted_birds_score, birds_order] = sort(score_birds(:,2));
data_sorted_birds = test_data(birds_order,:,:,:);
label_sorted_birds = test_label(birds_order,:);
label_sorted_birds = label_sorted_birds == 2;
mAP_birds = get_map(label_sorted_birds);

size(score_cars)
[sorted_cars_score, cars_order] = sort(score_cars(:,2));
data_sorted_cars = test_data(cars_order,:,:,:);
label_sorted_cars = test_label(cars_order,:);
label_sorted_cars = label_sorted_cars == 3;
mAP_cars = get_map(label_sorted_cars);

size(score_horses)
[sorted_horses_score, horses_order] = sort(score_horses(:,2));
data_sorted_horses = test_data(horses_order,:,:,:);
label_sorted_horses = test_label(horses_order,:);
label_sorted_horses = label_sorted_horses == 7;
mAP_horses = get_map(label_sorted_horses);

size(score_ships)
[sorted_ships_score, ships_order] = sort(score_ships(:,2));
data_sorted_ships = test_data(ships_order,:,:,:);
label_sorted_ships = test_label(ships_order,:);
label_sorted_ships = label_sorted_ships == 9;
mAP_ships = get_map(label_sorted_ships);
toc
display('Saving the results and images ...')
tic
settings_str = "map_results/" + CLUSTER_COUNT +"_"+ SIFT_SAMPLING +"_"+ SIFT_COLOR + ".txt";

fileID = fopen(settings_str, 'w+');
fileID
fprintf(fileID, 'mAP air-class: %.5f\n', mAP_air);
fprintf(fileID, 'mAP birds-class: %.5f\n', mAP_birds);
fprintf(fileID, 'mAP cars-class: %.5f\n', mAP_cars);
fprintf(fileID, 'mAP horses-class: %.5f\n', mAP_horses);
fprintf(fileID, 'mAP ships-class: %.5f\n', mAP_ships);

fclose(fileID);

image_subfolder = CLUSTER_COUNT +"_"+ SIFT_SAMPLING +"_"+ SIFT_COLOR;
mkdir("bow_images/" + image_subfolder);
imdir = "bow_images/" + image_subfolder + "/";
for i = 1:5
    top_str = imdir + "air_top_" + i + "_" + sorted_air_score(i) + ".jpg";
    bot_str = imdir + "air_bot_" + i + "_" + sorted_air_score(end-i+1) + ".jpg";
    imwrite(rgb2gray(squeeze(data_sorted_air(i,:,:,:))), top_str, 'jpg');
    imwrite(rgb2gray(squeeze(data_sorted_air(end-i+1,:,:,:))), bot_str, 'jpg');
    
    top_str = imdir + "birds_top_" + i + "_" + sorted_birds_score(i) + ".jpg";
    bot_str = imdir + "birds_bot_" + i + "_" + sorted_birds_score(end-i+1) + ".jpg";
    imwrite(rgb2gray(squeeze(data_sorted_birds(i,:,:,:))), top_str, 'jpg');
    imwrite(rgb2gray(squeeze(data_sorted_birds(end-i+1,:,:,:))), bot_str, 'jpg');
    
    top_str = imdir + "cars_top_" + i + "_" + sorted_cars_score(i) + ".jpg";
    bot_str = imdir + "cars_bot_" + i + "_" + sorted_cars_score(end-i+1) + ".jpg";
    imwrite(rgb2gray(squeeze(data_sorted_cars(i,:,:,:))), top_str, 'jpg');
    imwrite(rgb2gray(squeeze(data_sorted_cars(end-i+1,:,:,:))), bot_str, 'jpg');

    top_str = imdir + "horses_top_" + i + "_" + sorted_horses_score(i) + ".jpg";
    bot_str = imdir + "horses_bot_" + i + "_" + sorted_horses_score(end-i+1) + ".jpg";
    imwrite(rgb2gray(squeeze(data_sorted_horses(i,:,:,:))), top_str, 'jpg');
    imwrite(rgb2gray(squeeze(data_sorted_horses(end-i+1,:,:,:))), bot_str, 'jpg');

    top_str = imdir + "ships_top_" + i + "_" + sorted_ships_score(i) + ".jpg";
    bot_str = imdir + "ships_bot_" + i + "_" + sorted_ships_score(end-i+1) + ".jpg";
    imwrite(rgb2gray(squeeze(data_sorted_ships(i,:,:,:))), top_str, 'jpg');
    imwrite(rgb2gray(squeeze(data_sorted_ships(end-i+1,:,:,:))), bot_str, 'jpg'); 
end
toc
%{
for i=1:5
    hAxes = axes( figure ); % I usually use figure; hAxes = gca; here, but this is even more explicit.
    hImage = imshow(rgb2gray(squeeze(test_data_sorted(i,:,:,:))), 'Parent', hAxes);
end
%}


% for sorting: [A_sort, A_order] = sort(A) -> B(A_order,:) is B sorted by
% values in A


% Evaluation

% Do not forget to swtich out every vl_sift function in the code
% Maybe even create a custom_sift_function, with one additional parameter,
% that decides on the type of sift function. This parameter can then be set
% at the start of the demo.

% 1. create get_map function , done

% 2. understand how the results should be processed:
% create a list of results for each binary classifier 
% (one for airplanes, one for birds , one for cars, ...) of score-values
% sort by that score-value

% 3. write method to save first 5 and last 5 images  in subfolder

% 4. save the results of mAP, according to the classes, in a file, where
% its name indicates the settings


