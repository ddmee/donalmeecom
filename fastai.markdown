---
layout: page
title: Fast AI
permalink: /fastai/
---

# Fast AI

{:.no_toc}

* TOC
{:toc}


## Practical deep-learning for coders

- At [course-fast-ai]. Using Google Cloud platform.
- There is a full book called [*'Deep Learning for Coders with fastai and PyTorch'*]([deep-learning-for-coders-book-amazon]). It's actually available for free at [fast-book-git] in jupyter notebook form. Please buy a copy of the book if you enjoyed the course. 


### Compute

Recommended to use a cloud service for running jupyter notebooks, easier setup, reasonable cost etc. I decided to use Google Cloud Platform [google-cloud-console], because I already have an account. I haven't logged into it for about a year, and it's amazing to see how much progress Google have made to improve the UIX in that year. Well done Google.

Once you follow [these instructions](google-cloud-setup-instructions) to get an appropriate notebook available in Google cloud, you can [view your running instances](https://console.cloud.google.com/ai-platform/notebooks/list/instances).

Make sure to stop your running instance once you've finished for the day. Otherwise, you will get billed for time you weren't using.

[Fast AI Book Chapter 1](fast-book-chapter-1)
[Fast AI Lesson 1](course-fast-ai-videos-lesson-1)

### Background

A mathematical model of a neuron was created in 1940s by Warren McCulloch and Walter Pitts. Frank Rosenblatt, in Cornell, made some changes to the neuron model and had the idea to connecting them together to form a 'perceptron' machine. This machine was meant to be able to 'learn' without human programming.

Along came Marvin Minsky from MIT, who said that actually, a single layer of these neutrons wasn't capable of learning enough to simulate simple mathematical functions like XOR (a boolean operator). This was widely accepted and there was a loss of interest in neural-nets. However, what was not appreciated by the wider community, was that Minsky said adding another layer to the network was enough to simulate also any mathematical function.

In the 1980s, MIT group of researchers came along with *Parallel Distributed Processing* (1986). They said that you could create something that could learn almost anything if you had a machine that dealt with:

- processing units;
- state of activation;
- output function;
- pattern of connectivity;
- propagation rule;
- activation rule;
- learning rule; and
- operating in an environment.

Things that meet these requriements in theory could all sorts of work.

In the 1990s, some institutions were using neural-networks to do things like credit scores. But the networks were rather unweldy and slow. Largely because they were not 'deep' networks. While it is theoretical shown that a network of only two layers of neurons could approximate almost any mathematical relationship/model, in practice, these networks were too big and slow. Other researchers had shown, to get good practical performance, you needed to add more layers of neurons to the network. Thus 'deep' refers to the use of many layers of neurons to boost the networks performance characteristics.

Now with faster hardware, algorithms and data, we are at the point were we can realise Rosenblatt's ambition.

### Software stack

Software stack in use in the course: python -> pytorch -> fastai.

Jupyter notebooks is a REPL that lets you execute code as well as output other things like markdown and graphics. So it's a bit different to most development environments coders are used to.

- Here is the actual documentation for the web-gui version of [jupyter labs](jupyter-labs-docs).
- Fast AI book has a [jupyter notebook 101](fast-book-jupyter-notebook-101).

There are two modes in Jupyter, 'edit mode' and 'command mode'. Edit mode allows you to edit an individual cell. Hit `control-/` to add a comment. And hit `shift-enter` to execute the cell. You are in editing mode when a flashing-cursor is present in a cell.

Command mode is the other mode. It is not for editing individual cells, but lets you move around the notebook and do other things. There are quite a lot of short-cuts available.

In the web-gui, you can input `control-shift-c` to open the command palette.

An important thing to remember is that when you execute a cell that runs code, that updates the state of the REPL. So lets say you set a variable to be the value 4. That means the REPL state has been updated and if you are to re-run any cell command that uses that variable, the starting value is going to be 4. When a cell is run and output is created, that output is the value of the expression at the time the cell was run. So if you later update the state or value, unless the cell is re-run, the cells output is not altered.


### Train your first model

Code for training the first model from the book. This first model is an image classifier that can tell the difference between a photographs of cats and dogs.

{% highlight python %}
import fastbook
fastbook.setup_book()
from fastbook import *
from fastai.vision.all import *

path = untar_data(URLS.PETS)/'images'

def is_cat(x):
    """Function that declares whether data is a cat.
    Data set PETS is rather funny. The creators denote whether the image
    is a cat if the filename is upper-case.
    """
    return x[0].isupper()

'''
Docs for ImageDataLoaders at https://docs.fast.ai/vision.data#ImageDataLoaders
from_name_func() is a factory method. The valid_pct says keep 20% of the training
set as valid sets. item_tfms shrinks images to 224x224 pixels.
'''
dls = ImageDataLoaders.from_name_func(
    path=path, fnames=get_image_files(path), label_func=is_cat, valid_pct=0.2, seed=42, item_tfms=Resize(224))

'''cnn is convolutional style learner, that determines the architecture of the
network. resnet34 is a pretrained model.
'''
learn = cnn_learner(dls, resnet34)

'''Once the model is trained we can ask it to classify images. Using PILImage
object. Not sure why. Presumably it's how the learn object wants to be feed
images. predict method spits out a prediction.
https://docs.fast.ai/learner#Learner.predict
'''
cat_img = PILImage.create('images/cat.jpg')
dog_img = PILImage.create('images/dog.jpg')
banana_img = PILImage.create('images/banana.jpg')
is_cat, , probs = learn.predict(cat_img)
print(f"Is this a cat?: {is_cat}.")
print(f"Probability it's a cat: {probs[1].item():.6f}")
{% endhighlight %}

Note limitations: throw a banana at it, prediction is '99%'' sure it's a cat. Similarly, try throwing a cartoon of a cat or dog at it, again it's wrong.

### What is machine learning?

Programming, the programmer has traditional used conditionals and loops and variables to set out in absolutely strict detail how the execution of a program is to proceed. How would you write such a program to do the training we have just done? How would you write a program that way that can recognise dogs from cats?

Such a program seems very difficult to write.

Athur Samuel (from IBM) circa 1940-1970 came up with an alternative, that he coined 'machine learning'. He decided not to tell the computer the exact steps, instead he would show it lots of examples and let the program figure out how to solve the problem. He wrote:

> "Suppose we arrange for some automatic means of testing the effectiveness of any current weight assignment in terms of actual performane and provide a mecanism for altering the weight assignment so as to maxize the performance. We need not go into the details of such a procedure to see that it could be made entirely automatic and to see that a machine so programmed would 'learn' from it's experience."

'Weights' are variables and weight assignment is a particular choice of values for those variables. What Samuel called 'weights' we now typically called model parameters.

Once we've done the training process, we take away the update/performance feedback loop and we have something like a traditional program that goes from input -> model -> output.

## What is a neural network?

So, the type of thing we build the model from is super important. We want something general enough that it could really learn to recognise anything just by altering the weights (also called parameters to the model). That means whatever we construct the model from has to be super flexible. There actually is at least one such thing. That is a neural network. There is even a mathematical proof called 'universal approximation theorem' that shows this function can solve any problem to any level of accuracy, in theory (the original Marvin Minsky discussion).

So, we want to focus on finding the correct weights for any problem. What do we use to do that? How do we update the weights? There's a thing called _stochastic gradient descent_ that's used.

How do we know whether the model is effective? The performance is just the models accuracy at predicting things. Thus we held back 20% of the training data set to test the models predictions at each time we wanted to test the model before updating the weights.

## Limitations of machine learning

Do you have enough labelled data? You might have a lot of data but if the data is not labelled then how are you going to train your model?

What happens if you show the model data it has never seen before? Like the dog, cat and banana. The model was not trained on bananas, so it's parameters never feed into updating the model, so the models predictions are garbage.

What is the data you have is bias? Say for policing, drug use is equivalent across race but police arrest more ethic minorities for drug offences than whites. If you give your model that data, and ask it for predictions of who will commit crimes, it will not correct the bias in the data.

How can a model interact with it's environment? If you begin with bias data and use that to drive actions that change the environment to be more like the model, then even if the environment was not bias to start with, you can make the environment more bias.

## Fast AI

The documentation for the fastai library is at [fast-ai-docs](fast-ai-docs).

## Chapter 1 Questionnaire

1. Do you need lots of math/ data/ expensive computers/ a phd to use deep learning?

    No.

2. Name fives area deep learning is now the best in the world.

    Lots of areas apparently. Speech recognition, face recognition, anomaly detection in radiology images, handling objects in robotics, finance/logistic forecasting, image generation, playing games.

3. What was the name of the first device that was based on the principle of the artifical neuron?

    The Mark I Perceptron by Rosenblatt. It was a physical machine that had been wired together to try to build a neural network.

4. Based on the book of the same name, what are the requirements for parallel distributed processing (PDP)?

    - A set of processing units
    - A state of activation
    - An output function for each unit
    - A pattern of connectivity among units
    - A propogation rule for propagating patterns of activities through the network of connectivities
    - An activation rule for combining the inputs impingining on a unit with the current state of that unit to produce an output for the unit
    - A learning rule whereby patterns of connectivity are modified by experience.
    - An environment within which the system must operate.

5. What were the two theoretical misunderstandings that held back the field of neural networks?

    Minksy showed that a single layer of neural networks could not replicate simple functions like an XOR. This is true. But as soon as a second layer of neurons are added, the network can model any mathematical relationship.

    The second error was not using enough layers of neural networks. While 2 is theoretically enough, in practice, adding many more layers produces much better results.

6. What is a GPU?

    A graphics processing unit. It's a specialised chip that handles computations needed to compute graphical renderings. It seems the same basic computations are used in deep learning.

7. Open a notebook...

    Skip.

8. Skip 8 as well.

9. Skip 9.

10. Why is it hard to use a traditional computer program to recognise images in a photo?

    It's not clear how for-loops, boolean logic and value stores could be used to tell the different between an image of a cat and a dog. The difference between a cat and a dog or a stool and an airport, are hard to describe if you had to use those concepts.

11. What did Samuel mean by 'weight assignment'?

    Weight assignment is the process of changing the parameters to a model to alter how the model transforms inputs to outputs. Weights are the variables that affect how to the model converts input to output. A weight assignment is just setting those variables to be some value.

12. What term do we normally use in deep learning for what Samuel called 'weights'?

    Parameters (to the model, itself is also called the architecture).

13. Draw a picture that summaziers Samuel's view of a machine learning model.

    Feed input to a flexible mathematical function that can replicate any mathematical relationship. The model begins with some predefined parameters that define how the function of that model transforms input to output. The input is run through the model. For each input through the model, the output is assessed and the result of this is feed into the model again by altering the weights. This processes goes on until we believe the model has learned enough to classify the input so it reliably gets the right classification/prediction for the output.

    ```
    input -> model -> output -> assessment
               ^                    /
               |              /----/
        alter weights <------/
    ```

14. Why is it hard to understand why a deep learning model makes a particular prediction?

    The model is a complicated compounding feedback mechanism that is built on shoving lots of data through the model and then slowly evoling the model until it's weight produce the right output. This makes it practically impossible for anyone to follow the evolution of the model, as it has to be done at super human speeds.

15. What is the name of the theorum that shows that a neural netowkr can solve any mathematical problem to any level of accuracy?

    Universal approximation theorem.

16. What do you ned in order to train a model?

    Labelled data. Time. Computing hardware. A 'model' architecture. A way to determine the correctness of the output and how that will affect the learning rate of the weights.

17. How could a feedback loop impact the rollout of a predictive policing model?

    Models, like computers, are dumb. They can only predict what they've seen before. If they have seen bias information, they will make bias predictions. Further, if the output of a model is collected as input data, then the bias will be further propagated into the model. A positive feedback loop.

18. Do we always have to use 224x224-pixel images with the cat recognition model?

    Nope.

19. What is the difference between classificaton and regression?

20. What is a validation set? What is a test set? Why do we need them?

    We cannot consume all the labelled input data to train the model without risking producing a model that is overfit. Producing a feel fitted model is an art not a science. It requires a lot of tinkering. We need to prevent some of the input data from being exposed to the model during the training process so we can determine whether the model is overfit and what level of accuracy we think the model has reached (error level).

21. What will fastai do if you don't provide a validation set?

22. Can we always use a random sample for a validation set? Why or why not?

23. What is overfitting? Provide an example.

    You want to train a model to recognise humans. You run you model over and over again on the pictures of 10 people until it, instead of recognising people generally, only recognises those 10 people. 

24. What is a metric? How does it differ from 'loss'?

25. How can pretrained models help?

26. What is the 'head' of a model?

27. What kinds of features do the early layers of a CNN find? How about the later layers?

28. Are image models only useful for photos?

29. What is an 'architecture'?

30. What is segmentation?

31. What is y_range used for? When do we need it?

32. What are 'hyperparameters'?

33. What's the best way to avoid failures when using AI in an organisation?

    To eliminate all the humans first.

## Referefences

- [course-fast-ai]
- [course-fast-ai-videos-lesson-1]
- [fast-book-git]
- [fast-ai-docs]
- [fast-book-jupyter-notebook-101]
- [deep-learning-for-coders-book-amazon]
- [google-cloud-console]
- [google-cloud-setup-instructions]
- [google-cloud-notebook-instances]

[course-fast-ai]: https://course.fast.ai/
[course-fast-ai-videos-lesson-1]: https://course.fast.ai/videos/?lesson=1
[fast-book-git]: https://github.com/fastai/fastbook
[fast-book-chapter-1]: https://github.com/fastai/fastbook/blob/master/01_intro.ipynb
[fast-ai-docs]: https://docs.fast.ai/
[fast-book-jupyter-notebook-101]: https://github.com/fastai/fastbook/blob/master/app_jupyter.ipynb
[deep-learning-for-coders-book-amazon]: https://www.amazon.co.uk/Deep-Learning-Coders-fastai-PyTorch/dp/1492045527
[google-cloud-console]: https://console.cloud.google.com/
[google-cloud-setup-instructions]: https://course.fast.ai/start_gcp
[google-cloud-notebook-instances]: https://console.cloud.google.com/ai-platform/notebooks/list/instances
[jupyter-lab-docs]: https://jupyterlab.readthedocs.io