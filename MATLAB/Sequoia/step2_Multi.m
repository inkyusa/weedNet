clear all;
close all;
nir_wl=790;
red_wl=660;
green_wl=550;
reg_wl=735;

%target1=getFolderInfo('/Users/Inkyu/Research/ETH_Postdoc/Flourish/HyperspectralCamera/dev/data/Sequoia/20170616-2m-plant-n-crop-multi/Crop-Only-2m','crop');
%target2=getFolderInfo('/Users/Inkyu/Research/ETH_Postdoc/Flourish/HyperspectralCamera/dev/data/Sequoia/20170616-2m-plant-n-crop/Only-Weed_2m','weed');

target1=getFolderInfo('/Users/Inkyu/Research/ETH_Postdoc/Flourish/HyperspectralCamera/dev/data/Sequoia/20170616-2m-plant-n-crop/Weed-Plant-2m-First','weed');

gpuPath='/home/enddl22/workspace/SegNet-Tutorial/SequoiaMulti';


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

%[target1.trainInd,target1.valInd,target1.testInd]=dividerand(length(target1.dirImgInfo),0.9,0.0,0.1);
[target1.trainInd,target1.valInd,target1.testInd]=dividerand(length(target1.dirImgInfo),0.01,0.0,0.99);

for i=1:length(target1.trainInd)
   %train image copy
   srcNirImgFileName=[target1.path '/plant/img/' target1.dirImgInfo(target1.trainInd(i)).name];
   [~,name,~]=fileparts(target1.dirImgInfo(target1.trainInd(i)).name);
   dstNirImgFileName=[trainPath '/' name '_' 'nir_' target1.type '.png'];   
   
   %Copy NIR
   copyfile(srcNirImgFileName,dstNirImgFileName);
   %Copy NDVI
   srcNDVIImgFileName=[target1.path '/ndvi/' target1.dirImgInfo(target1.trainInd(i)).name];
   dstNDVIImgFileName=[trainPath '/' name '_' 'ndvi_' target1.type '.png'];
   copyfile(srcNDVIImgFileName,dstNDVIImgFileName);
   
   %Copy RED
   srcRedImgFileName=[target1.path '/sort_regi/' name '/' num2str(red_wl) '.png'];
   dstRedIImgFileName=[trainPath '/' name '_' 'red_' target1.type '.png'];
   copyfile(srcRedImgFileName,dstRedIImgFileName);
   
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

%Validation, Segnet doesn't utilize this. Therefore, split dataset 90%
%train and 10% test.
for i=1:length(target1.valInd)
   %validation image copy
   srcNirImgFileName=[target1.path '/plant/img/' target1.dirImgInfo(target1.valInd(i)).name];
   [~,name,~]=fileparts(target1.dirImgInfo(target1.valInd(i)).name);
   dstNirImgFileName=[valPath '/' name '_' 'nir_' target1.type '.png'];
   copyfile(srcNirImgFileName,dstNirImgFileName);
   %Copy NDVI
   srcNDVIImgFileName=[target1.path '/ndvi/' target1.dirImgInfo(target1.valInd(i)).name];
   dstNDVIImgFileName=[valPath '/' name '_' 'ndvi_' target1.type '.png'];
   copyfile(srcNDVIImgFileName,dstNDVIImgFileName);
   
   %Copy RED
   srcRedImgFileName=[target1.path '/sort_regi/' name '/' num2str(red_wl) '.png'];
   dstRedIImgFileName=[valPath '/' name '_' 'red_' target1.type '.png'];
   copyfile(srcRedImgFileName,dstRedIImgFileName);
   
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

%Testing

for i=1:length(target1.testInd)
   %test image copy
   srcNirImgFileName=[target1.path '/plant/img/' target1.dirImgInfo(target1.testInd(i)).name];
   [~,name,~]=fileparts(target1.dirImgInfo(target1.testInd(i)).name);
   dstNirImgFileName=[testPath '/' name '_' 'nir_' target1.type '.png'];
   %Copy NIR
   copyfile(srcNirImgFileName,dstNirImgFileName);
   %Copy NDVI
   srcNDVIImgFileName=[target1.path '/ndvi/' target1.dirImgInfo(target1.testInd(i)).name];
   dstNDVIImgFileName=[testPath '/' name '_' 'ndvi_' target1.type '.png'];
   copyfile(srcNDVIImgFileName,dstNDVIImgFileName);
   
   %Copy RED
   srcRedImgFileName=[target1.path '/sort_regi/' name '/' num2str(red_wl) '.png'];
   dstRedIImgFileName=[testPath '/' name '_' 'red_' target1.type '.png'];
   copyfile(srcRedImgFileName,dstRedIImgFileName);
   
   
   
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
    [target2.trainInd,target2.valInd,target2.testInd]=dividerand(length(target2.dirImgInfo),0.9,0,0.1);
    for i=1:length(target2.trainInd)
       %train image copy
       srcNirImgFileName=[target2.path '/plant/img/' target2.dirImgInfo(target2.trainInd(i)).name];
       [~,name,~]=fileparts(target2.dirImgInfo(target2.trainInd(i)).name);
       dstNirImgFileName=[trainPath '/' name '_' 'nir_' target2.type '.png'];   

       %Copy NIR
       copyfile(srcNirImgFileName,dstNirImgFileName);
       %Copy NDVI
       srcNDVIImgFileName=[target2.path '/ndvi/' target2.dirImgInfo(target2.trainInd(i)).name];
       dstNDVIImgFileName=[trainPath '/' name '_' 'ndvi_' target2.type '.png'];
       copyfile(srcNDVIImgFileName,dstNDVIImgFileName);

       %Copy RED
       srcRedImgFileName=[target2.path '/sort_regi/' name '/' num2str(red_wl) '.png'];
       dstRedIImgFileName=[trainPath '/' name '_' 'red_' target2.type '.png'];
       copyfile(srcRedImgFileName,dstRedIImgFileName);

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

    %Validation, Segnet doesn't utilize this. Therefore, split dataset 90%
    %train and 10% test.
    for i=1:length(target2.valInd)
       %validation image copy
       srcNirImgFileName=[target2.path '/plant/img/' target2.dirImgInfo(target2.valInd(i)).name];
       [~,name,~]=fileparts(target2.dirImgInfo(target2.valInd(i)).name);
       dstNirImgFileName=[valPath '/' name '_' 'nir_' target2.type '.png'];
       copyfile(srcNirImgFileName,dstNirImgFileName);
       %Copy NDVI
       srcNDVIImgFileName=[target2.path '/ndvi/' target2.dirImgInfo(target2.valInd(i)).name];
       dstNDVIImgFileName=[valPath '/' name '_' 'ndvi_' target2.type '.png'];
       copyfile(srcNDVIImgFileName,dstNDVIImgFileName);

       %Copy RED
       srcRedImgFileName=[target2.path '/sort_regi/' name '/' num2str(red_wl) '.png'];
       dstRedIImgFileName=[valPath '/' name '_' 'red_' target2.type '.png'];
       copyfile(srcRedImgFileName,dstRedIImgFileName);

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

    %Testing

    for i=1:length(target2.testInd)
       %test image copy
       srcNirImgFileName=[target2.path '/plant/img/' target2.dirImgInfo(target2.testInd(i)).name];
       [~,name,~]=fileparts(target2.dirImgInfo(target2.testInd(i)).name);
       dstNirImgFileName=[testPath '/' name '_' 'nir_' target2.type '.png'];
       %Copy NIR
       copyfile(srcNirImgFileName,dstNirImgFileName);
       %Copy NDVI
       srcNDVIImgFileName=[target2.path '/ndvi/' target2.dirImgInfo(target2.testInd(i)).name];
       dstNDVIImgFileName=[testPath '/' name '_' 'ndvi_' target2.type '.png'];
       copyfile(srcNDVIImgFileName,dstNDVIImgFileName);

       %Copy RED
       srcRedImgFileName=[target2.path '/sort_regi/' name '/' num2str(red_wl) '.png'];
       dstRedIImgFileName=[testPath '/' name '_' 'red_' target2.type '.png'];
       copyfile(srcRedImgFileName,dstRedIImgFileName);



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

fileTrainNirTxt = fopen('./segnet/trainNir.txt','w');
fileTrainNDVITxt = fopen('./segnet/trainNDVI.txt','w');
fileTrainRedTxt = fopen('./segnet/trainRed.txt','w');

nirIdx=[];
ndviIdx=[];
redIdx=[];
for i=1:length(dirTrainInfo)
    if(strfind(dirTrainInfo(i).name,'nir'))
        nirIdx=[nirIdx;i];
    elseif (strfind(dirTrainInfo(i).name,'ndvi'))
        ndviIdx=[ndviIdx;i];
    elseif (strfind(dirTrainInfo(i).name,'red'))
        redIdx=[redIdx;i];
    end
end

for i=1:length(nirIdx)
    trainNirStr=fullfile(gpuPath,'train',dirTrainInfo(nirIdx(i)).name);
    trainAnnotStr=fullfile(gpuPath,'trainannot',dirTrainAnnotInfo(i).name);
    fprintf(fileTrainNirTxt,'%s %s\n',trainNirStr,trainAnnotStr);
end

for i=1:length(ndviIdx)
    trainNDVIStr=fullfile(gpuPath,'train',dirTrainInfo(ndviIdx(i)).name);
    fprintf(fileTrainNDVITxt,'%s\n',trainNDVIStr);
end

for i=1:length(redIdx)
    trainRedStr=fullfile(gpuPath,'train',dirTrainInfo(redIdx(i)).name);
    fprintf(fileTrainRedTxt,'%s\n',trainRedStr);
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

fileValNirTxt = fopen('./segnet/valNir.txt','w');
fileValNDVITxt = fopen('./segnet/valNDVI.txt','w');
fileValRedTxt = fopen('./segnet/valRed.txt','w');

nirIdx=[];
ndviIdx=[];
redIdx=[];
for i=1:length(dirValInfo)
    if(strfind(dirValInfo(i).name,'nir'))
        nirIdx=[nirIdx;i];
    elseif (strfind(dirValInfo(i).name,'ndvi'))
        ndviIdx=[ndviIdx;i];
    elseif (strfind(dirValInfo(i).name,'red'))
        redIdx=[redIdx;i];
    end
end


for i=1:length(nirIdx)
    valNirStr=fullfile(gpuPath,'val',dirValInfo(nirIdx(i)).name);
    valAnnotStr=fullfile(gpuPath,'valannot',dirValAnnotInfo(i).name);
    fprintf(fileValNirTxt,'%s %s\n',valNirStr,valAnnotStr);
end

for i=1:length(ndviIdx)
    valNDVIStr=fullfile(gpuPath,'val',dirValInfo(ndviIdx(i)).name);
    fprintf(fileValNDVITxt,'%s\n',valNDVIStr);
end

for i=1:length(redIdx)
    valRedStr=fullfile(gpuPath,'val',dirValInfo(redIdx(i)).name);
    fprintf(fileValRedTxt,'%s\n',valRedStr);
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

fileTestNirTxt = fopen('./segnet/testNir.txt','w');
fileTestNDVITxt = fopen('./segnet/testNDVI.txt','w');
fileTestRedTxt = fopen('./segnet/testRed.txt','w');

nirIdx=[];
ndviIdx=[];
redIdx=[];
for i=1:length(dirTestInfo)
    if(strfind(dirTestInfo(i).name,'nir'))
        nirIdx=[nirIdx;i];
    elseif (strfind(dirTestInfo(i).name,'ndvi'))
        ndviIdx=[ndviIdx;i];
    elseif (strfind(dirTestInfo(i).name,'red'))
        redIdx=[redIdx;i];
    end
end


for i=1:length(nirIdx)
    testNirStr=fullfile(gpuPath,'test',dirTestInfo(nirIdx(i)).name);
    testAnnotStr=fullfile(gpuPath,'testannot',dirTestAnnotInfo(i).name);
    fprintf(fileTestNirTxt,'%s %s\n',testNirStr,testAnnotStr);
end

for i=1:length(ndviIdx)
    testNDVIStr=fullfile(gpuPath,'test',dirTestInfo(ndviIdx(i)).name);
    fprintf(fileTestNDVITxt,'%s\n',testNDVIStr);
end

for i=1:length(redIdx)
    testRedStr=fullfile(gpuPath,'test',dirTestInfo(redIdx(i)).name);
    fprintf(fileTestRedTxt,'%s\n',testRedStr);
end



