clc
clear all

imgName = "tomo";
% imgName = "triangle";

switch imgName
    case "tomo"
        imgRef = imread('tomo.jpg');
        
    case "triangle"
        imgRef = rgb2gray(imread('triangle.jpg'));        
end

imgRef = im2double(imgRef); % normalizing the instensity values to lie between o and 1
imgNoise = imnoise(imgRef, 'gaussia', 0.01); % adding Gaussian noise of mean zero and variance 0.01

nCompList = [10, 20, 30, 40, 50, 60];
figNoiseNum = 1;
figPca = 2;

figure(figNoiseNum);
imshow(imgNoise);
title('Original Image');
drawnow;

figure(figPca)
subplot(3, 2, 1);

for i = 1:length(nCompList)
    imgTempNoise = imgNoise;
    [u, s, v] = svd(imgTempNoise);
    
    w = v(:, 1:nCompList(i));
    T = imgTempNoise * w;
    imgDenoise = T * w';
    imgTempNoise = imgDenoise;
    
    figure(figPca);
    subplot(3, 2, i);
    imshow(imgDenoise);
    title(strcat('PCA ', num2str(nCompList(i))));
    drawnow;
end
