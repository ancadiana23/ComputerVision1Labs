%% main function 


%% fine-tune cnn

[net, info, expdir] = finetune_cnn();

%% extract features and train svm

nets.fine_tuned = load(fullfile(expdir, 'your_new_model.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-stl.mat'));

[net, info, expdir] = finetune_cnn();

%% Hyper Parameter Tuning

clear, clc
expdir = 'data/cnn_assignment-lenet';

res_cell = {};
ix = 1;

for bs = 50:50:100
    for ep = 40:40:120
        nets.fine_tuned = load(fullfile(expdir, strcat('b',num2str(bs),'_e', num2str(ep),'.mat'))); 
        nets.fine_tuned = nets.fine_tuned.net;
        nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); 
        nets.pre_trained = nets.pre_trained.net; 
        data = load(fullfile(expdir, 'imdb-stl.mat'));
        res_cell{ix} = train_svm(nets, data);
        ix = ix+1;
    end
end

clc

ix = 1;
for bs = 50:50:100
    for ep = 40:40:120
        disp('CNN: fine_tuned_accuracy   SVM: pre_trained_accuracy:  Fine_tuned_accuracy:')
        disp(strcat('b',num2str(bs),'_e', num2str(ep)))
        res_cell{ix}
        ix = ix+1;
    end
end

%%
train_svm(nets, data);
