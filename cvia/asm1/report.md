# Assignment 1 - Computer Vision Concepts Implementation (8890 CVIA PG)
---
> ## Author: Data Man
> ## Date: 13/05/2022

## Task 1: Classic Machine Learning Approach
In this task, the project choices classic HOG (Histogram of Oriented Gradient) features to identify the birds. The classifier selected is SVM (Support Vector Machine). In the first part, a random sample image was loaded and HOG features with cell size of 64 by 64, 16 by 16, and 4 by 4 were extracted for evaluation. In this test run, the target input image size was 128 by 128. It is clear that the cell size of [64 64] did not result in much information, while [4 4] encoded over 30,000. This will require computational power of multiple higher orders of magnitude. However, this project will evaluate all three of them in later sessions for comparison.

## Task 2: Deep Learning Approach
A simple CNN (convolutional neural network) for deep learning classification was employed in this project. For this task, the input images are most coloured, so any grayscale images were concatenated into three layers of same gray pixel plains. There are seven convolutional layers with feature maps of 8, 16, 32, 64, 128, 256, 512, respectively. In the following max pooling layers, the size of rectangular regions were all [2, 2] to remove redundant information. In this test run, the output consist of 20 classes for the smaller dataset.

## Whole Image as Input
### Experiment 1
In this test runs on 20 classes dataset, with full images, the accuracy sits around 11%. It is clear that the cell size of [64 64] shows worst performance because it only encoded 36 features. However, it is interesting the features size of over 30,000 did not result in better accuracy. This may comes from more noise picked up by the feature extraction. So the extra computational power invested is not worth it in this case.

### Experiment 2
Although it is running on the same full image datastores, this simple CNN model shows much better result compare to HOG-based ML above. If the network were further tuned, the performance may even improve. With a well designed network the performance could improve significantly.

## Target Area Image as Input
### Experiment 3
With cropped images, the overall performance of this HOG-based ML model did improved, and the one with largest feature size gave the best performance among the three tests. This could comes from less noise presented in the image frame, so the features extracted did help the model. But this approach still worse than CNN with full image input above.

### Experiment 4
The performance of this CNN network with cropped image inputs did improve but not much. Most of the images in this dataset are already quite clear and the target is the only major object in the frame, so a crop may not reduce the distraction. However, the deformation introduced by resizing may affect the performance of the model. The resolution is not very high in the first place, so the shape change could make some images very hard to process.

## Cross-Validation Experiment
### Experiment 5
The results from 5 runs varied from 42% to nearly 60%, which means the network is not very stable with this smaller dataset. The average accuracy from this five fold cross-validation is even higher than experiment 4. This shows the importance of cross-validation because the same model could fit well for certain part of the dataset while worse for others. It is the bias of the model. To eliminate this bias, a cross-validation is essential. On the other hand, a large enough and balanced dataset is also critically important for the training.

## Conclusion
It is clear that the CNN models perform much better than HOG-based classic ML model. Although the feature selected is simple and not well refined. On the other hand, image preprocess for better feature extraction was not conducted. And the performance is not stable across multiple runs and two datasets. It runs worse, even unusable, with the full dataset in terms of simple accuracy).
For the CNN approach in this project, it is also a simple network but it is already good enough to outperform the classic ML with around 50% of accuracy compare to around 10%. Due to lack of time and experience, the parameters of the network was not well tuned, it is not the optimal result this model could have become.
This report show results from the smaller 20 classes dataset. In the test runs with the full dataset, the overall accuracy decreased for both of them but it comes from 200 classes. The input with cropped images with only the target in it does not improve the performance significantly. The reason could be that the target birds are already quite large in the frame, so the crop did not increase the SNR very much. Another issue which could affect the performance is the resizing will introduce deformation.