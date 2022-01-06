%%%test for Random MultiGraphs Ensemble Learning
clear all;
clc;

%===== basic parameters =================================
bandNum = 4; % number of band for LPE band selection  
w = 7;       % patch size
% LBP feature extraction
r = 1;  nr = 8;
kg = 4;

fprintf('... ... loading data begin ...\n');
load IndianPines_Data.mat;
fprintf('... ... loading data finished...\n');

% training number for Inidan_Pines dataset
CTrain = [3 72 42 12 24 37 2 24 2 49 120 30 10 64 20 5];

%===== basic parameters ===============================
no_class = max(gth(:));

% data normalization
Data = z./max(z(:));
[ylen, xlen, spec_dim] = size(Data);

% band selection  
tic;
X = reshape(Data, ylen*xlen, spec_dim);
Psi = PCA_Train(X', bandNum);
X = X*Psi;
DataTmp = reshape(X, ylen, xlen, size(Psi,2));
clear X Psi;
%LBP feature extraction
mapping = getmapping(nr,'u2'); 
Feature_P = LBP_feature_global(DataTmp, r, nr, mapping, w, gth);
clear nr r z DataTmp;


lbp_dim = size(Feature_P, 3);
% spatial  data
DataSpat = NewScale(reshape(Feature_P, ylen*xlen, lbp_dim));
% spectral data
DataSpec = NewScale(reshape(Data, ylen*xlen, spec_dim));
% spatial and spectral data combination
DataSpec = DataSpec(:, 1:150);
Data_spec_spat = [DataSpat, DataSpec];
clear DataSpat DataSpec Data Feature_P bandNum;
clear lbp_dim mapping w;

Data = []; Labels = [];

for i = 1: no_class
    pos = find(gth==i);
    Data = [Data; Data_spec_spat(pos, :)];
    Labels = [Labels, length(pos)];
end
clear  Data_spec_spat;

DataTrn = []; DataTst = [];  CTest = [];
k = 0; 
for i = 1: no_class
    Data_tmp = Data((k+1):(Labels(i)+k), :);
    k = Labels(i) + k;
    index_i = randperm(Labels(i));
    DataTrn = [DataTrn; Data_tmp(index_i(1:CTrain(i)), :)];
    index_i = find(gth==i);
    CTest(i) = length(index_i);
end
DataTst = Data;
clear k Data_tmp Data index_i;

TrnLab = []; TstLab = [];
for jj = 1: length(CTrain)
   TrnLab = [TrnLab; jj * ones(CTrain(jj),1)];
end
for jj = 1: length(CTest)
   TstLab = [TstLab; jj * ones(CTest(jj),1)];
end
 
X=[DataTrn;DataTst];
[N,Dim] = size(X);
clear CTest CTrain gth DataTrn DataTst; 

fprintf('... ... Graph number:%d ... ...\n', kg);

kf = floor(Dim/4);

label_index = find(TrnLab~=0);
labels = [TrnLab;TstLab];
[G,F]  = MultiGraphs(X,labels,label_index,kg,kf);
toc;

[val, predict_res]=max(F,[],2);
        
[Pr, ConfMat] = GetAccuracy(predict_res(length(label_index)+1:end), ...
                            labels(length(label_index)+1:end));

fprintf(' ... ... Final Accuracy: %f\n', Pr.OA);
fprintf(' ... ... Final Kappa: %f\n', Pr.Kappa);
fprintf('%.4f\n', Pr.UA);


