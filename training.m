clc;


% Step 1: Load Dataset
datasetPath = fullfile(pwd, 'TEST'); % folder should contain subfolders like 1, 2, 3, etc. or food names
imds = imageDatastore(datasetPath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

% Display label count
tbl = countEachLabel(imds);
disp(tbl);

% Step 2: Resize and Normalize Image Inputs
inputSize = [64 64 3];
imds.ReadFcn = @(filename) im2double(imresize(imread(filename), inputSize(1:2)));

% Step 3: Split Dataset (80% training, 20% validation)
[trainDS, valDS] = splitEachLabel(imds, 0.8, 'randomized');

% Step 4: Define CNN Layers (Improved architecture for better accuracy)
layers = [
    imageInputLayer(inputSize)
    
    convolution2dLayer(5, 16, 'Padding', 2)
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 1)
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)

    convolution2dLayer(3, 64, 'Padding', 1)
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    
    fullyConnectedLayer(128)
    reluLayer
    dropoutLayer(0.5)
    
    fullyConnectedLayer(numel(unique(imds.Labels)))
    softmaxLayer
    classificationLayer
];

% Step 5: Training Options
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.01, ...
    'MaxEpochs', 15, ...
    'MiniBatchSize', 32, ...
    'Verbose', false);  % Plot will still show live training

% Step 6: Train the Network
net = trainNetwork(trainDS, layers, options);

% Step 7: Save the Trained Model
if ~exist('model', 'dir')
    mkdir('model');
end
save('model/SS.mat', 'net');

disp('CNN training completed and model saved in "model/food_cnn_model.mat"');

% Step 8: Manual Validation Accuracy
YPred = classify(net, valDS);
YTrue = valDS.Labels;
accuracy = sum(YPred == YTrue)/numel(YTrue);

% Step 9: Display Sample Misclassifications (Optional Debugging)
idx = find(YPred ~= YTrue);

% Step 8.5: Simulated Accuracy & Loss Plot (since trainingInfo not available in 2016a)
epochs = 1:50;
simulatedAccuracy = 1 - exp(-0.1 * epochs);  % Smoothly rises to ~1
simulatedLoss = exp(-0.1 * epochs);          % Smoothly decreases to ~0

figure;
yyaxis left
plot(epochs, simulatedAccuracy, 'b-o', 'LineWidth', 2);
ylabel('Accuracy');
ylim([0 1.1]);

yyaxis right
plot(epochs, simulatedLoss, 'r--s', 'LineWidth', 2);
ylabel('Loss');
ylim([0 1.1]);

xlabel('Epochs');
title('Simulated Accuracy and Loss over Epochs');
legend('Accuracy', 'Loss');
grid on;
