clc
clear all

% imgName = "tomo";
imgName = "triangle";

switch imgName
    case "tomo"
        imgRef = imread('tomo.jpg');
        
    case "triangle"
        imgRef = rgb2gray(imread('triangle.jpg'));        
end

imgRef = im2double(imgRef); % normalizing the instensity values to lie between o and 1
imgNoise = imnoise(imgRef, 'gaussia', 0.01); % adding Gaussian noise of mean zero and variance 0.01

nCompList = [10, 20, 30, 40, 50, 60, 70, 80];
figNum = 1;

figure(figNum);
subplot(3, 3, 1);
imshow(imgNoise);
title('Original Image');
drawnow;

[u, s, v] = svd(imgNoise);

for i = 1:length(nCompList)
    w = v(:, 1:nCompList(i));
    T = imgNoise * w;
    imgDenoise = T * w';

    figure(figNum);
    subplot(3, 3, i+1);
    imshow(imgDenoise);
    title(strcat('PCA ', num2str(nCompList(i))));
    drawnow;
end
