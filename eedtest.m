clc
clear all

% img = imread('tomo.jpg'); nIter=40; sigma=1; km=0.001;
img = rgb2gray(imread('triangle.jpg')); nIter=40; sigma=0.8; km=0.001;
% img = imread('cameraman.tif'); nIter=30; sigma=0.8; km=0.001;

img = im2double(img); % normalizing the instensity values to lie between o and 1

% imgNoise = imnoise(img,'gaussian',0.01); % adding Gaussian noise of mean zero and variance 0.01
% imgNoise = imnoise(img, 'gaussian', 0.01);
% imgNoise = imnoise(img, 'poisson');
% imgNoise = imnoise(img, 'speckle');
imgNoise = imnoise(img, 'salt & pepper');

timeStep = 0.2; % timestep size used in numerical approximation

% imgFiltered = eedfinal(imgNoise, timeStep, nIter, 1, sigma, 4, km, 3.3148);
% imgFiltered = eed2(imgNoise, timeStep, nIter, 1, 0.2);
% eedfinal(u, timeStep, nIter, verbose, sigma, m, km, cm)
