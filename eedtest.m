clc
clear all

img = imread('tomo.jpg'); % nIter = 60
% img = rgb2gray(imread('triangle.jpg')); %nIter = 120

img = im2double(img); % normalizing the instensity values to lie between o and 1

imgNoise = imnoise(img,'gaussia',0.01); % adding Gaussian noise of mean zero and variance 0.01
timeStep = 0.2; % timestep size used in numerical approximation
nIter = 120; % number of iterations 

b = eedfinal(imgNoise, timeStep, nIter, 1, 0.2); 
