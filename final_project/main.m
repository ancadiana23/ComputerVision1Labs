%% main function 
%% fine-tune cnn
[net, info, expdir] = finetune_cnn();

%% Hyper Parameter Tuning
expdir = 'data/cnn_assignment-lenet';

%for bs = 50:50:100
%    for ep = 40:40:120
%        nets.fine_tuned = load(fullfile(expdir, strcat('b',num2str(bs),'_e', num2str(ep),'.mat'))); 
%        nets.fine_tuned = nets.fine_tuned.net;
%        nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
%        nets.pre_trained = nets.pre_trained.net; 
%        data = load(fullfile(expdir, 'imdb-stl.mat'));
%        train_svm(nets, data);
%    end
%end

%% results (couldnt save them properly)
%% batch = 50; epoch = 40
% CNN: fine_tuned_accuracy: 0.83, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 83.43
%% batch = 50; epoch = 80
% CNN: fine_tuned_accuracy: 0.83, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 83.43
%% batch = 50; epoch = 120
% CNN: fine_tuned_accuracy: 0.83, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 82.95
%% batch = 100; epoch = 40
%CNN: fine_tuned_accuracy: 0.77, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 76.98
%% batch = 100; epoch = 80
% CNN: fine_tuned_accuracy: 0.77, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 77.40
%% batch = 100; epoch = 120
%CNN: fine_tuned_accuracy: 0.77, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 77.53

%% frozen performance
% Load networks
nets.fine_tuned = load(fullfile(expdir, 'frozen-80.mat')); 
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-stl.mat'));
train_svm(nets, data);
% CNN: fine_tuned_accuracy: 0.60, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 69.08

%% dropout performance 
nets.fine_tuned = load(fullfile(expdir, 'dropout-80.mat')); 
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-stl.mat'));
train_svm(nets, data);
% CNN: fine_tuned_accuracy: 0.79, SVM: pre_trained_accuracy: 69.08, fine_tuned_accuracy: 81.03

%% Data Augmentation
nets.fine_tuned = load(fullfile(expdir, 'augmentation-80.mat')); 
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-stl.mat'));
train_svm(nets, data);
% CNN: fine_tuned_accuracy: 0.82, SVM: pre_trained_accuracy: 69.05, fine_tuned_accuracy: 81.03


%% More FC layers
nets.fine_tuned = load(fullfile(expdir, 'more-connected-80.mat')); 
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-stl.mat'));
train_svm(nets, data);
% CNN: fine_tuned_accuracy: 0.84, SVM: pre_trained_accuracy: 69.05, fine_tuned_accuracy: 83.33


%% All Adjustments (Dropouts, More Conv Layers and Augmentation)
nets.fine_tuned = load(fullfile(expdir, 'all-80.mat')); 
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-stl.mat'));
train_svm(nets, data);
% CNN: fine_tuned_accuracy: 0.82, SVM: pre_trained_accuracy: 69.05, fine_tuned_accuracy: 81.67


% Load data
data = load(fullfile(expdir, 'imdb-stl.mat'));

% Extract features
[svm.pre_trained.trainset, svm.pre_trained.testset] = get_svm_data(data, nets.pre_trained);
[svm.fine_tuned.trainset,  svm.fine_tuned.testset] = get_svm_data(data, nets.fine_tuned);

addpath('tsne')

% Run TSNE
figure1 = figure('Color',[1 1 1]);
tsne_pre = tsne(svm.pre_trained.testset.features, ...
                [], ...
                2, 6, 50);
gscatter(tsne_pre(:, 1), tsne_pre(:, 2), data.meta.classes(svm.pre_trained.testset.labels)');
savefig('results/tsne_pre.fig')

figure2 = figure('Color',[1 1 1]);
tsne_fine = tsne(svm.fine_tuned.testset.features, ...
                 [], ...
                 2, 6, 50);
gscatter(tsne_fine(:, 1), tsne_fine(:, 2), data.meta.classes(svm.fine_tuned.testset.labels)');
savefig('results/tsne_fine.fig')


