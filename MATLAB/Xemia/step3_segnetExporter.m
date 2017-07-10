clear all;
close all;
path(path, '../funcs');
targetPath='../../data/Xemia/Test';
wavelengthsRowMajor = [615, 623, 608, 790, 686,...
            816, 828, 803, 791, 700,...
            765, 778, 752, 739, 714,...
            653, 662, 645, 636, 678,...
            867, 864, 857, 845, 670];
%myWaveLength=[670;678;752;778;790;857];
myWaveLength=wavelengthsRowMajor';
target1=getFolderInfo(targetPath,'crop'); %arg2= 'crop' or 'weed;'
gpuPath='/home/yourFolder/SegNet-Tutorial/Xemia';


outputFolder='./segnet';

trainPath=[outputFolder '/train'];
trainImgPath = [outputFolder '/train/img'];
trainTxtPath = [outputFolder '/train/txt'];
trainannoPath=[outputFolder  '/train/annot'];

valPath=[outputFolder  '/val'];
valImgPath = [outputFolder '/val/img'];
valTxtPath = [outputFolder '/val/txt'];
valannoPath=[outputFolder  '/val/valannot'];

testPath=[outputFolder  '/test'];
testImgPath = [outputFolder '/test/img'];
testTxtPath = [outputFolder '/test/txt'];
testannoPath=[outputFolder  '/test/annot'];

mkdir(outputFolder);
mkdir(trainPath);
mkdir(trainImgPath);
mkdir(trainTxtPath);
mkdir(trainannoPath);

mkdir(valPath);
mkdir(valannoPath);

mkdir(testPath);
mkdir(testImgPath);
mkdir(testTxtPath);
mkdir(testannoPath);


%======================
%   Target1
%======================

%[target1.trainInd,target1.valInd,target1.testInd]=dividerand(length(target1.dirImgInfo),0.9,0.0,0.1);
[target1.trainInd,target1.valInd,target1.testInd]=dividerand(length(target1.dirImgInfo),0.8,0.0,0.2);

for i=1:length(target1.trainInd)
   %train image copy
   
   [~,name,~]=fileparts(target1.dirImgInfo(target1.trainInd(i)).name);
   
   for j=1:length(myWaveLength)
       srcImgFileName=[target1.path '/sort_regi/' name '/' num2str(myWaveLength(j)) '.png'];
       dstImgFileName=[trainPath '/img/' name '/' name '_' num2str(myWaveLength(j)) '_' target1.type '.png'];
       %Folder check.
       if exist([trainPath '/img' name],'dir');
        copyfile(srcImgFileName,dstImgFileName);
       else
           mkdir([trainPath '/img/' name]);
           copyfile(srcImgFileName,dstImgFileName);
       end
   end
   
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
   [~,name,~]=fileparts(target1.dirImgInfo(target1.valInd(i)).name);
   
   for j=1:length(myWaveLength)
       srcImgFileName=[target1.path '/sort_regi/' name '/' num2str(myWaveLength(j)) '.png'];
       dstImgFileName=[valPath '/img/' name '/' name '_' num2str(myWaveLength(j)) '_' target1.type '.png'];
       %Folder check.
       if exist([valPath '/img' name],'dir');
        copyfile(srcImgFileName,dstImgFileName);
       else
           mkdir([valPath '/img/' name]);
           copyfile(srcImgFileName,dstImgFileName);
       end
   end
   
   srcSegFileName=[target1.path '/plant/seg/' target1.dirImgInfo(target1.valInd(i)).name];
   imgPlant=imread(srcSegFileName);
   imgSz=size(imgPlant);
   %train annot generation
   imgGt=zeros(imgSz); %!!!!! Soil label=0 !!!!!!
   if strcmp(target1.type,'crop') imgGt(find(imgPlant))=1; end% !!!!!Plant label=1 !!!!!!
   if strcmp(target1.type,'weed') imgGt(find(imgPlant))=2; end% !!!!! Weed label=2 !!!!!!
   dstSegFileName=[valannoPath '/' name '_' target1.type '.png'];
   imwrite(uint8(imgGt),dstSegFileName);
   
end

%Testing

for i=1:length(target1.testInd)
   [~,name,~]=fileparts(target1.dirImgInfo(target1.testInd(i)).name);
   
   for j=1:length(myWaveLength)
       srcImgFileName=[target1.path '/sort_regi/' name '/' num2str(myWaveLength(j)) '.png'];
       dstImgFileName=[testPath '/img/' name '/' name '_' num2str(myWaveLength(j)) '_' target1.type '.png'];
       %Folder check.
       if exist([testPath '/img' name],'dir');
        copyfile(srcImgFileName,dstImgFileName);
       else
           mkdir([testPath '/img/' name]);
           copyfile(srcImgFileName,dstImgFileName);
       end
   end
   
   srcSegFileName=[target1.path '/plant/seg/' target1.dirImgInfo(target1.testInd(i)).name];
   imgPlant=imread(srcSegFileName);
   imgSz=size(imgPlant);
   %train annot generation
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

dirTrainImgInfo=dir(trainImgPath);
dirTrainAnnotInfo=dir(trainAnnotFolderPath);
dirTrainImgInfo(1:2)=[]; %delete '.' and '..'
dirTrainAnnotInfo(1:2)=[];

fileTrainTxt=cell(length(myWaveLength));
for k=1:length(myWaveLength)
    fileName=['./segnet/train/txt/' 'train' num2str(myWaveLength(k)) '.txt'];
    fileTrainTxt{k}=fopen(fileName,'w');
end

for i=1:length(dirTrainImgInfo)
    dirInfo=dir([trainImgPath '/' dirTrainImgInfo(i).name '/*.png']);
    for j=1:length(dirInfo)
        if j==1
            train670Str=fullfile(gpuPath,'train/img',dirTrainImgInfo(i).name, dirInfo(j).name);
            trainAnnotStr=fullfile(gpuPath,'train/annot',dirTrainAnnotInfo(i).name);
            fprintf(fileTrainTxt{j},'%s %s\n',train670Str,trainAnnotStr);
        else
            trainImgStr=fullfile(gpuPath,'train/img',dirTrainImgInfo(i).name,dirInfo(j).name);
            fprintf(fileTrainTxt{j},'%s\n',trainImgStr);
        end
    end
end

%===================
%   Validation
%===================

valFolderPath=valPath;
valAnnotFolderPath=valannoPath;

dirValImgInfo=dir(valImgPath);
dirValAnnotInfo=dir(valAnnotFolderPath);
if length(dirValImgInfo)>=2
    dirValImgInfo(1)=[];  %delete '.' and '..'
    dirValImgInfo(1)=[];
    dirValAnnotInfo(1)=[];  %delete '.' and '..'
    dirValAnnotInfo(1)=[];
    fileValTxt=cell(length(myWaveLength));
    for k=1:length(myWaveLength)
        fileName=['./segnet/val/txt/' 'val' num2str(myWaveLength(k)) '.txt'];
        fileValTxt{k}=fopen(fileName,'w');
    end

    for i=1:length(dirValImgInfo)
        dirInfo=dir([valImgPath '/' dirValImgInfo(i).name '/*.png']);
        for j=1:length(dirInfo)
            if j==1
                val670Str=fullfile(gpuPath,'val/img',dirValImgInfo(i).name, dirInfo(j).name);
                valAnnotStr=fullfile(gpuPath,'val/annot',dirValAnnotInfo(i).name);
                fprintf(fileValTxt{j},'%s %s\n',val670Str,valAnnotStr);
            else
                valImgStr=fullfile(gpuPath,'val/img',dirValImgInfo(i).name,dirInfo(j).name);
                fprintf(fileValTxt{j},'%s\n',valImgStr);
            end
        end
    end
end
%===================
%   Test
%===================

testFolderPath=testPath;
testAnnotFolderPath=testannoPath;

dirTestImgInfo=dir(testImgPath);
dirTestAnnotInfo=dir(testAnnotFolderPath);
if length(dirTestImgInfo)>=2
    dirTestImgInfo(1)=[];  %delete '.' and '..'
    dirTestImgInfo(1)=[];
    dirTestAnnotInfo(1)=[];  %delete '.' and '..'
    dirTestAnnotInfo(1)=[];

    fileTestTxt=cell(length(myWaveLength));
    for k=1:length(myWaveLength)
        fileName=['./segnet/test/txt/' 'test' num2str(myWaveLength(k)) '.txt'];
        fileTestTxt{k}=fopen(fileName,'w');
    end

    for i=1:length(dirTestImgInfo)
        dirInfo=dir([testImgPath '/' dirTestImgInfo(i).name '/*.png']);
        for j=1:length(dirInfo)
            if j==1
                test670Str=fullfile(gpuPath,'test/img',dirTestImgInfo(i).name, dirInfo(j).name);
                testAnnotStr=fullfile(gpuPath,'test/annot',dirTestAnnotInfo(i).name);
                fprintf(fileTestTxt{j},'%s %s\n',test670Str,testAnnotStr);
            else
                testImgStr=fullfile(gpuPath,'test/img',dirTestImgInfo(i).name,dirInfo(j).name);
                fprintf(fileTestTxt{j},'%s\n',testImgStr);
            end
        end
    end
end
