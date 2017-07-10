function [ specImage ] = readSpecImage( bag, iImage,topic)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%% Create selections for images and exposure times
imgBag = select(bag, 'Topic', topic);
%exposureBag = select(bag, 'Topic', '/ximea_asl/exposure_time');

%% read image and exposure messages
imgMsg = readMessages(imgBag, iImage);
%exposureMsg = readMessages(exposureBag, iImage);
rawImg = readImage(imgMsg{1});

%% store as a SpectralImage object
specImage = SpectralImage(rawImg);
%specImage.exposureTime = double(exposureMsg{1}.Data)/1000 ;

end

