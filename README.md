# Multispectral dataset 
Please head to [dataset](https://github.com/inkyusa/weedNet/tree/master/data/Sequoia) for the multispectral images (NIR, Red, and NDVI with their labels).


***
Due to several requests for raw multi-spectral images (4ch), we unofficially made this available [raw dataset](https://drive.google.com/open?id=1moUzw39CEp3kXBzRfFcHEOEi4D4WRmZM) (1.8GB) and you can checkout [this branch](https://github.com/inkyusa/weedNet/tree/rgb-samples) for sample RGB images. Please note that these datasets do not have the corresponding labels and we couldn't guarantee the maintenance of them due to limited resources. Thank you for your understandings and hope this helps.
***

### Training weedNet
If you want to know more about how to train a network (using a caffe framework) with this dataset, here we have [an experimental repo](https://github.com/inkyusa/weedNet-devel) that allows you to do this (courtesy by Marija Popovic).

### Publications
If our work helps your works in an academic/research context, please cite the following publication(s):
* I. Sa, Z. Chen, M. Popovic, R. Khanna, F. Liebisch, J. Nieto and R. Siegwart, **"weedNet: Dense Semantic Weed Classification Using Multispectral Images and MAV for Smart Farming"**, 2018, [IEEE Robotics and Automation Letters](http://ieeexplore.ieee.org/document/8115245/) or ([arxiv pdf](https://arxiv.org/abs/1709.03329))

```bibtex
@ARTICLE{8115245, 
author={I. Sa and Z. Chen and M. Popović and R. Khanna and F. Liebisch and J. Nieto and R. Siegwart}, 
journal={IEEE Robotics and Automation Letters}, 
title={weedNet: Dense Semantic Weed Classification Using Multispectral Images and MAV for Smart Farming}, 
year={2018}, 
volume={3}, 
number={1}, 
pages={588-595}, 
keywords={agriculture;agrochemicals;autonomous aerial vehicles;control engineering computing;convolution;crops;feature extraction;image classification;learning (artificial intelligence);neural nets;vegetation;MAV;SegNet;convolutional neural network;crop health;crop management;curve classification metrics;dense semantic classes;dense semantic weed classification;encoder-decoder;input image channels;multispectral images;selective weed treatment;vegetation index;weed detection;Agriculture;Cameras;Image segmentation;Robots;Semantics;Training;Vegetation mapping;Aerial systems;agricultural automation;applications;robotics in agriculture and forestry}, 
doi={10.1109/LRA.2017.2774979}, 
ISSN={}, 
month={Jan},}
```


[![Click to see a demonstration video](http://drive.google.com/uc?export=view&id=0B-0CTsFowMRVX3ZyQl8wVjd4blU)](https://youtu.be/9aHgtxzU3DM)
