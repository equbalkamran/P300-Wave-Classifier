function [trainedClassifier, validationAccuracy] = trainClassifiert1(trainingData)
% yfit=class.predictFcn(tepoch([43,58,74,75,92,110],:));  %getting results for epochs from testing dataset
%[trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% Returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: A matrix with the same number of rows and data type as
%       the matrix imported into the app.
%
%  Output:
%      trainedClassifier: A struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: A function to make predictions on new
%       data.
%
%      validationAccuracy: A double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a matrix containing only the predictor rows used for training.
% For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 02-Jan-2021 23:05:43


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
% Convert input to table
inputTable = array2table(trainingData', 'VariableNames', {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7', 'row_8', 'row_9', 'row_10', 'row_11', 'row_12', 'row_13', 'row_14', 'row_15', 'row_16', 'row_17', 'row_18', 'row_19', 'row_20', 'row_21', 'row_22', 'row_23', 'row_24', 'row_25', 'row_26', 'row_27', 'row_28', 'row_29', 'row_30', 'row_31', 'row_32', 'row_33', 'row_34', 'row_35', 'row_36', 'row_37', 'row_38', 'row_39', 'row_40', 'row_41', 'row_42', 'row_43', 'row_44', 'row_45', 'row_46', 'row_47', 'row_48', 'row_49', 'row_50', 'row_51', 'row_52', 'row_53', 'row_54', 'row_55', 'row_56', 'row_57', 'row_58', 'row_59', 'row_60', 'row_61', 'row_62', 'row_63', 'row_64', 'row_65', 'row_66', 'row_67', 'row_68', 'row_69', 'row_70', 'row_71', 'row_72', 'row_73', 'row_74', 'row_75', 'row_76', 'row_77', 'row_78', 'row_79', 'row_80', 'row_81', 'row_82', 'row_83', 'row_84', 'row_85', 'row_86', 'row_87', 'row_88', 'row_89', 'row_90', 'row_91', 'row_92', 'row_93', 'row_94', 'row_95', 'row_96', 'row_97', 'row_98', 'row_99', 'row_100', 'row_101', 'row_102', 'row_103', 'row_104', 'row_105', 'row_106', 'row_107', 'row_108', 'row_109', 'row_110', 'row_111', 'row_112', 'row_113', 'row_114', 'row_115', 'row_116', 'row_117', 'row_118', 'row_119', 'row_120', 'row_121', 'row_122', 'row_123', 'row_124', 'row_125', 'row_126', 'row_127', 'row_128', 'row_129', 'row_130', 'row_131', 'row_132', 'row_133', 'row_134', 'row_135', 'row_136', 'row_137', 'row_138', 'row_139', 'row_140', 'row_141', 'row_142', 'row_143', 'row_144', 'row_145', 'row_146', 'row_147', 'row_148', 'row_149', 'row_150', 'row_151', 'row_152', 'row_153', 'row_154', 'row_155', 'row_156', 'row_157'});

predictorNames = {'row_43', 'row_58', 'row_74', 'row_75', 'row_92', 'row_110'};
predictors = inputTable(:, predictorNames);
response = inputTable.row_157;
isCategoricalPredictor = [false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);

% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x', 'VariableNames', predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2020a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new predictor row matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nX must contain exactly 6 rows because this model was trained using 6 predictors. \nX must contain only predictor rows in exactly the same order and format as your training \ndata. Do not include the response row or any rows you did not import into the app. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
% Convert input to table
inputTable = array2table(trainingData', 'VariableNames', {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7', 'row_8', 'row_9', 'row_10', 'row_11', 'row_12', 'row_13', 'row_14', 'row_15', 'row_16', 'row_17', 'row_18', 'row_19', 'row_20', 'row_21', 'row_22', 'row_23', 'row_24', 'row_25', 'row_26', 'row_27', 'row_28', 'row_29', 'row_30', 'row_31', 'row_32', 'row_33', 'row_34', 'row_35', 'row_36', 'row_37', 'row_38', 'row_39', 'row_40', 'row_41', 'row_42', 'row_43', 'row_44', 'row_45', 'row_46', 'row_47', 'row_48', 'row_49', 'row_50', 'row_51', 'row_52', 'row_53', 'row_54', 'row_55', 'row_56', 'row_57', 'row_58', 'row_59', 'row_60', 'row_61', 'row_62', 'row_63', 'row_64', 'row_65', 'row_66', 'row_67', 'row_68', 'row_69', 'row_70', 'row_71', 'row_72', 'row_73', 'row_74', 'row_75', 'row_76', 'row_77', 'row_78', 'row_79', 'row_80', 'row_81', 'row_82', 'row_83', 'row_84', 'row_85', 'row_86', 'row_87', 'row_88', 'row_89', 'row_90', 'row_91', 'row_92', 'row_93', 'row_94', 'row_95', 'row_96', 'row_97', 'row_98', 'row_99', 'row_100', 'row_101', 'row_102', 'row_103', 'row_104', 'row_105', 'row_106', 'row_107', 'row_108', 'row_109', 'row_110', 'row_111', 'row_112', 'row_113', 'row_114', 'row_115', 'row_116', 'row_117', 'row_118', 'row_119', 'row_120', 'row_121', 'row_122', 'row_123', 'row_124', 'row_125', 'row_126', 'row_127', 'row_128', 'row_129', 'row_130', 'row_131', 'row_132', 'row_133', 'row_134', 'row_135', 'row_136', 'row_137', 'row_138', 'row_139', 'row_140', 'row_141', 'row_142', 'row_143', 'row_144', 'row_145', 'row_146', 'row_147', 'row_148', 'row_149', 'row_150', 'row_151', 'row_152', 'row_153', 'row_154', 'row_155', 'row_156', 'row_157'});

predictorNames = {'row_43', 'row_58', 'row_74', 'row_75', 'row_92', 'row_110'};
predictors = inputTable(:, predictorNames);
response = inputTable.row_157;
isCategoricalPredictor = [false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 5);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
