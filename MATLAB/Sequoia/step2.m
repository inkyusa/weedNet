clear all;
close all;
target1=getFolderInfo('../../data/Sequoia/Test','crop');
gpuPath='/home/yourFolder/SegNet-Tutorial/Sequoia';


outputFolder='./segnet';

trainPath=[outputFolder '/' 'train'];
trainannoPath=[outputFolder  '/' 'trainannot'];
valPath=[outputFolder  '/' 'val'];
valannoPath=[outputFolder  '/' 'valannot'];
testPath=[outputFolder  '/' 'test'];
testannoPath=[outputFolder '/' 'testannot'];

mkdir(outputFolder);
mkdir(trainPath);
mkdir(trainannoPath);
mkdir(testPath);
mkdir(testannoPath);
mkdir(valPath);
mkdir(valannoPath);

%======================
%   Target1
%======================

%[target1.trainInd,target1.valInd,target1.testInd]=dividerand(length(target1.dirImgInfo),0.8,0.1,0.1);
[target1.trainInd,target1.valInd,target1.testInd]=dividerand(length(target1.dirImgInfo),0.01,0.01,0.98);

for i=1:length(target1.trainInd)
   %train image copy
   srcImgFileName=[target1.path '/plant/img/' target1.dirImgInfo(target1.trainInd(i)).name];
   [~,name,~]=fileparts(target1.dirImgInfo(target1.trainInd(i)).name);
   dstImgFileName=[trainPath '/' name '_' target1.type '.png'];   
   copyfile(srcImgFileName,dstImgFileName);
   srcSegFileName=[target1.path '/plant/seg/' target1.dirImgInfo(target1.trainInd(i)).name];
   imgPlant=imread(srcSegFileName);
   imgSz=size(imgPlant);
   %train annot generation
   imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
   if strcmp(target1.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
   if strcmp(target1.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
   dstSegFileName=[trainannoPath '/' name '_' target1.type '.png'];
   imwrite(uint8(imgGt),dstSegFileName);
end

for i=1:length(target1.valInd)
   %validation image copy
   srcImgFileName=[target1.path '/plant/img/' target1.dirImgInfo(target1.valInd(i)).name];
   [~,name,~]=fileparts(target1.dirImgInfo(target1.valInd(i)).name);
   dstImgFileName=[valPath '/' name '_' target1.type '.png'];   
   copyfile(srcImgFileName,dstImgFileName);
   srcSegFileName=[target1.path '/plant/seg/' target1.dirImgInfo(target1.valInd(i)).name];
   imgPlant=imread(srcSegFileName);
   imgSz=size(imgPlant);
   %validataion annot generation
   imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
   if strcmp(target1.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
   if strcmp(target1.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
   dstSegFileName=[valannoPath '/' name '_' target1.type '.png'];
   imwrite(uint8(imgGt),dstSegFileName);
end

for i=1:length(target1.testInd)
   %test image copy
   srcImgFileName=[target1.path '/plant/img/' target1.dirImgInfo(target1.testInd(i)).name];
   [~,name,~]=fileparts(target1.dirImgInfo(target1.testInd(i)).name);
   dstImgFileName=[testPath '/' name '_' target1.type '.png'];   
   copyfile(srcImgFileName,dstImgFileName);
   srcSegFileName=[target1.path '/plant/seg/' target1.dirImgInfo(target1.testInd(i)).name];
   imgPlant=imread(srcSegFileName);
   imgSz=size(imgPlant);
   %test annot generation
   imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
   if strcmp(target1.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
   if strcmp(target1.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
   dstSegFileName=[testannoPath '/' name '_' target1.type '.png'];
   imwrite(uint8(imgGt),dstSegFileName);
end

%======================
%   Target2
%======================
status=exist('target2','var');

if status 
    [target2.trainInd,target2.valInd,target2.testInd]=dividerand(length(target2.dirImgInfo),0.8,0.1,0.1);
    for i=1:length(target2.trainInd)
       %train image copy
       srcImgFileName=[target2.path '/plant/img/' target2.dirImgInfo(target2.trainInd(i)).name];
       [~,name,~]=fileparts(target2.dirImgInfo(target2.trainInd(i)).name);
       dstImgFileName=[trainPath '/' name '_' target2.type '.png'];   
       copyfile(srcImgFileName,dstImgFileName);
       srcSegFileName=[target2.path '/plant/seg/' target2.dirImgInfo(target2.trainInd(i)).name];
       imgPlant=imread(srcSegFileName);
       imgSz=size(imgPlant);
       %train annot generation
       imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
       if strcmp(target2.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
       if strcmp(target2.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
       dstSegFileName=[trainannoPath '/' name '_' target2.type '.png'];
       imwrite(uint8(imgGt),dstSegFileName);
    end

    for i=1:length(target2.valInd)
       %validataion image copy
       srcImgFileName=[target2.path '/plant/img/' target2.dirImgInfo(target2.valInd(i)).name];
       [~,name,~]=fileparts(target2.dirImgInfo(target2.valInd(i)).name);
       dstImgFileName=[valPath '/' name '_' target2.type '.png'];   
       copyfile(srcImgFileName,dstImgFileName);
       srcSegFileName=[target2.path '/plant/seg/' target2.dirImgInfo(target2.valInd(i)).name];
       imgPlant=imread(srcSegFileName);
       imgSz=size(imgPlant);
       %validataion annot generation
       imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
       if strcmp(target2.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
       if strcmp(target2.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
       dstSegFileName=[valannoPath '/' name '_' target2.type '.png'];
       imwrite(uint8(imgGt),dstSegFileName);
    end

    for i=1:length(target2.testInd)
       %test image copy
       srcImgFileName=[target2.path '/plant/img/' target2.dirImgInfo(target2.testInd(i)).name];
       [~,name,~]=fileparts(target2.dirImgInfo(target2.testInd(i)).name);
       dstImgFileName=[testPath '/' name '_' target2.type '.png'];   
       copyfile(srcImgFileName,dstImgFileName);
       srcSegFileName=[target2.path '/plant/seg/' target2.dirImgInfo(target2.testInd(i)).name];
       imgPlant=imread(srcSegFileName);
       imgSz=size(imgPlant);
       %test annot generation
       imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
       if strcmp(target2.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
       if strcmp(target2.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
       dstSegFileName=[testannoPath '/' name '_' target2.type '.png'];
       imwrite(uint8(imgGt),dstSegFileName);
    end
end

%    Sanity check.
%     figure(1);
%     map=[plantColor;weedColor];
%     rgb=label2rgb(imgGt,map,[0,0,0]);
%     imshow(rgb);
%     pause();



%===================
%   Train
%===================

trainFolderPath=trainPath;
trainAnnotFolderPath=trainannoPath;

dirTrainInfo=dir(trainFolderPath);
dirTrainAnnotInfo=dir(trainAnnotFolderPath);
dirTrainInfo(1)=[];  %delete '.' and '..'
dirTrainInfo(1)=[];
dirTrainAnnotInfo(1)=[];  %delete '.' and '..'
dirTrainAnnotInfo(1)=[];

fileTrainTxt = fopen('./segnet/train.txt','w');
for i=1:length(dirTrainInfo)
    trainStr=fullfile(gpuPath,'train',dirTrainInfo(i).name);
    trainAnnotStr=fullfile(gpuPath,'trainannot',dirTrainAnnotInfo(i).name);
    fprintf(fileTrainTxt,'%s %s\n',trainStr,trainAnnotStr);
end

%===================
%   Validation
%===================

valFolderPath=valPath;
valAnnotFolderPath=valannoPath;

dirValInfo=dir(valFolderPath);
dirValAnnotInfo=dir(valAnnotFolderPath);
dirValInfo(1)=[];  %delete '.' and '..'
dirValInfo(1)=[];
dirValAnnotInfo(1)=[];  %delete '.' and '..'
dirValAnnotInfo(1)=[];

fileValTxt = fopen('./segnet/val.txt','w');
for i=1:length(dirValInfo)
    valStr=fullfile(gpuPath,'val',dirValInfo(i).name);
    valAnnotStr=fullfile(gpuPath,'valannot',dirValAnnotInfo(i).name);
    fprintf(fileValTxt,'%s %s\n',valStr,valAnnotStr);
end

%===================
%   Test
%===================

testFolderPath=testPath;
testAnnotFolderPath=testannoPath;

dirTestInfo=dir(testFolderPath);
dirTestAnnotInfo=dir(testAnnotFolderPath);
dirTestInfo(1)=[];  %delete '.' and '..'
dirTestInfo(1)=[];
dirTestAnnotInfo(1)=[];  %delete '.' and '..'
dirTestAnnotInfo(1)=[];

fileTestTxt = fopen('./segnet/test.txt','w');
for i=1:length(dirTestInfo)
    testStr=fullfile(gpuPath,'test',dirTestInfo(i).name);
    testAnnotStr=fullfile(gpuPath,'testannot',dirTestAnnotInfo(i).name);
    fprintf(fileTestTxt,'%s %s\n',testStr,testAnnotStr);
end



