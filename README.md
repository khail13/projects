The experimentation process of creating the most accurate classification model began with creating a convolutional neural network with a Convolutional Layer to learn 32 filters using a 3x3 kernel and a ReLU activation function. This was followed by a Max-Pooling Layer with a 2x2 pool size and a ReLU activation function. The Units were Flattened.

To increase the accuracy, the second iteration added a Hidden Layer with 128 Units and a ReLU activation function.

The Final iteration added a Dropout with a rate of 0.3 in order to prevent Overfitting and to promote Generalization.

This model results in an accuracy of about 96%.


