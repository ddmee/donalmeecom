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

Along came Marvin Minsky from MIT, who said that actually, a single layer of these neutrons wasn't capable of learning enough to simulate simple mathematical functions like XOR (a boolean operator). This was widely accepted and there was a loss of interest in neural-nets. However, what was not appreciated by the wider community, was that Minsky said adding another layer to the network was enough to simulate almost any mathematical function.

In the 1980s, MIT group of researchers came along with *Parallel Distributed Processing* (1986). They said that you could create something that could learn almost anything if you had a machine that dealt with:

- processing units;
- state of activation;
- output function;
- pattern of connectivity;
- propagation rule;
- activation rule;
- learning rule; and
- operating in an environment.

Things that meet these requriements, in theory, could do all sorts of work. And this sort of machine is what we have now realised with deep learning. And what we'll be looking at in these notes.

In the 1990s, some institutions were using neural-networks to do things like credit scores. But the networks were rather unweldy and slow. Largely because they were not 'deep'/multi-layered networks. While it is theoretical shown that a network of only two layers of neurons could approximate almost any mathematical relationship/model, in practice, these networks are too big and slow. Other researchers had shown, to get good practical performance, you needed to add more layers of neurons to the network. Thus 'deep' refers to the use of many layers of neurons to boost the networks performance characteristics.

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

Programming, the programmer has traditional used conditionals and loops and variables to set out in absolutely strict detail how the execution of a program is to proceed. How would you write such a program to do the training we have just done? How would you write a program that can recognise dogs from cats?

Such a program seems very difficult to write, using the traditional method.

Athur Samuel (from IBM) circa 1940-1970 came up with an alternative, that he coined 'machine learning'. He decided not to tell the computer the exact steps, instead he would show it lots of examples and let the program figure out how to solve the problem. He wrote:

> "Suppose we arrange for some automatic means of testing the effectiveness of any current weight assignment in terms of actual performane and provide a mechanism for altering the weight assignment so as to maxize the performance. We need not go into the details of such a procedure to see that it could be made entirely automatic and to see that a machine so programmed would 'learn' from it's experience."

'Weights' are variables and weight assignment is a particular choice of values for those variables. What Samuel called 'weights' we now typically called model parameters.

Once we've done the training process, we take away the update/performance feedback loop and we have something like a traditional program that goes from input -> model -> output.

### What is a neural network?

So, the type of thing we build the model from is super important. We want something general enough that it could really learn to recognise anything just by altering the weights (also called parameters to the model). That means whatever we construct the model from has to be super flexible. There actually is at least one such thing. That is a neural network. There is even a mathematical proof called 'universal approximation theorem' that shows this function can solve any problem to any level of accuracy, in theory (the original Marvin Minsky discussion).

So, we want to focus on finding the correct weights for any problem. What do we use to do that? How do we update the weights? There's a thing called _stochastic gradient descent_ that's used.

How do we know whether the model is effective? The performance is just the models accuracy at predicting things. Thus we held back 20% of the training data set to test the models predictions at each time we wanted to test the model before updating the weights.

### Limitations of machine learning

Do you have enough labelled data? You might have a lot of data but if the data is not labelled then how are you going to train your model?

What happens if you show the model data it has never seen before? Like the dog, cat and banana. The model was not trained on bananas, so it's parameters never feed into updating the model, so the models predictions are garbage.

What if the data you have is bias? Say for policing, drug use is equivalent across race but police arrest more ethic minorities for drug offences than whites. If you give your model that data, and ask it for predictions of who will commit crimes, it will not correct the bias in the data.

How can a model interact with it's environment? If you begin with bias data and use that to drive actions that change the environment to be more like the model, then even if the environment was not bias to start with, you can make the environment more bias.

Overall, practitioners need to be wary of the reliability of the training/prediction process and consider how the predictions could affect the environment.

### Looking inside a neural network

"Visualizing and Understanding Convolutional Networks"

### Using image recognition for other things

Continuing from having trained the model to recognise images of dogs and cats... We are not restricted to using image recognition networks to do plain image recognition. If you can convert the data from some other source into something that can be represented as an image, then you might be able to use an image-recogniser network on it.

For example:
- [Conversion of environmental-sounds to images for classification](environmental-sounds-classification)
- Converting time-series data to an image for olive-oil classification
- [Splunk converts user mouse-movements to images to detect fraud](splunk-mouse-image-fraud-detection)
- [Conversion of binaries to images to classify malware](malware-image-binaries-classification)

### Deep learning is not just for classification

Classification places inputs into discrete buckets. But we can also use deep learning to do regression to produce predictions for continuous outputs. For example, segmentation is about dividing a region into recognisable areas. This can be used in computer vision to recognise objects in a scene.

> "Classification and Regression: classification and regression have very specific meanings in machine learning. These are the two main types of model that we will be investigating in this book. A classification model is one which attempts to predict a class, or category. That is, it's predicting from a number of discrete possibilities, such as "dog" or "cat." A regression model is one which attempts to predict one or more numeric quantities, such as a temperature or a location. Sometimes people use the word regression to refer to a particular kind of model called a linear regression model; this is a bad practice"

### Validation and Test sets


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

    It's not clear how for-loops, boolean logic and value stores could be used to tell the difference between an image of a cat and a dog. The difference between a cat and a dog or a chair and an airport, are hard to describe if you had to use those concepts.

11. What did Samuel mean by 'weight assignment'?

    Weight assignment is the process of changing the parameters to a model to alter how the model transforms inputs to outputs. Weights are the variables that affect how to the model converts input to output. A weight assignment is just setting those variables to be some value.

12. What term do we normally use in deep learning for what Samuel called 'weights'?

    Parameters (to the model, itself is also called the architecture).

13. Draw a picture that summarises Samuel's view of a machine learning model.

    Feed input to a flexible mathematical function that can replicate any mathematical relationship. The model begins with some predefined parameters that define how the function of that model transforms input to output. The input is run through the model. For each input through the model, the output is assessed and the result of this is feed into the model again by altering the weights. This processes goes on until we believe the model has learned enough to classify the input so it reliably gets the right classification/prediction for the output.

    ```
    input -> model -> output -> assessment
               ^                    /
               |              /----/
        alter weights <------/
    ```

14. Why is it hard to understand why a deep learning model makes a particular prediction?

    The model is a complicated compounding feedback mechanism that is built on shoving lots of data through the model and then slowly evoling the model until it's weight produce the right output. As this is done at super human speeds, it's tricky to follow the evolution of the model. However, there is research into how we can understand the inner-workings o a trained network https://arxiv.org/pdf/1311.2901.pdf

15. What is the name of the theorum that shows that a neural network can solve any mathematical problem to any level of accuracy?

    Universal approximation theorem.

16. What do you ned in order to train a model?

    Labelled data. Time. Computing hardware. A 'model' architecture. A way to determine the correctness of the output and how that will affect the learning rate of the weights.

17. How could a feedback loop impact the rollout of a predictive policing model?

    Models, like computers, are dumb. They can only predict what they've seen before. If they have seen bias information, they will make bias predictions. Further, if the output of a model is collected as input data, then the bias will be further propagated into the model. A positive feedback loop.

18. Do we always have to use 224x224-pixel images with the cat recognition model?

    Nope.

19. What is the difference between classificaton and regression?

    Regression is predicting continuous data whereas classification is predicting categorical/discrete information.

20. What is a validation set? What is a test set? Why do we need them?

    We cannot consume all the labelled input data to train the model without risking producing a model that is overfit. Producing a well fitted model is an art not a science. It requires a lot of tinkering. We need to prevent some of the input data from being exposed to the model during the training process so we can determine whether the model is overfit and what level of accuracy we think the model has reached (error level). This is the validation set. We use it to evaluate and tkinker with the model during the training phrase. But we don't train the model on the validation set. It measure the performance or loss.

    There is a second, more highly-reserved, data-set called the 'test' set. The test set is used to evaluate whether the hyper-parameters have been overfit. By using a validation set, we tkinter with the model until it performs better on the test-set. But this tkinkering process may make the model design overfit. The test set is held back and is only used to evaluate the model at the very end.

    > "In effect, we define a hierarchy of cuts of our data, based on how fully we want to hide it from training and modeling processes: training data is fully exposed, the validation data is less exposed, and test data is totally hidden. This hierarchy parallels the different kinds of modeling and evaluation processes themselves—the automatic training process with back propagation, the more manual process of trying different hyper-parameters between training sessions, and the assessment of our final result."

21. What will fastai do if you don't provide a validation set?

    Defaults to using holding 20% of the data back as the validation set.

22. Can we always use a random sample for a validation set? Why or why not?

    No, some data, like time-series data, holding a random 20% of the data back still effectively shows the model in the training process the entire view of the data. For time series we would want to hold back certain segments of time from the model, like the last 20% of the data should be held back. To then allow the model to predict what the 'future' 20% of the data is to look like.

23. What is overfitting? Provide an example.

    You want to train a model to recognise humans. You run you model over and over again on the pictures of 10 people until it, instead of recognising people generally, only recognises those 10 people. 

24. What is a metric? How does it differ from 'loss'?

    Both a metric and a loss are a measure of the performance of a models predictions. But the metric is a number designed to describe performance in a way intelligible for a human. Whereas the loss is a number designed to help 'train' or alter the models parameters. I.e. it's a number that stochastic gradient descent can process.

25. How can pretrained models help?

    Pretrained models can be re-used for new situations, reducing the amount of training data a new model needs and speeding up the training time. For example, in image classifications, a pre-trained model being applied to a new situation can useful share many layers of the model. The early layers of the model tend to be similar across similar problems, whereas the later layers are more specialised to the particular task. Re-using a pretrained model for a new task in a different domain is called 'transfer' learning.

26. What is the 'head' of a model?

    The 'head' of the model is the last layer in the neural network. When we re-use a pretrained model, is it common to throw away the last layer or 'head' of the model. As the last layer is perhaps the most specialised part of the model. Replacing the 'head' of the model in transfer-learning is part of the 'fine-tuning' process to adapt the network to the new problem.

27. What kinds of features do the early layers of a CNN find? How about the later layers?



28. Are image models only useful for photos?

    No. Noted above, provided you can transform your data into images in a representative way, image models could potentially be useful.

29. What is an 'architecture'?

    Architecture is another name for the model. It describes what how the neural-network or central processing behaviour of the model is defined.

30. What is segmentation?

    Segmentation is cutting up a region into different parts.

31. What is y_range used for? When do we need it?

    The y_range is used in fastai for continous data to describe the range of the data.

32. What are 'hyperparameters'?

    Hyper-parameters are things that control how the parameters or model is updated. The learning rate, network architecture, data augmentation strategies. They are the essentially design choices on how the learning process is created.

33. What's the best way to avoid failures when using AI in an organisation?

    To eliminate all the humans first.


## Malicious use of AI

[Malicious AI Report][malicious-ai-report], said to be pretty comprehensive. Looks at the ways AI could be abused.

## Statistical significance of relationships

Use of randomness, if you don't have enough data, random values can look like they display a relationship. Example of a covid-19 paper around R value (tranmission/reproduction rate) and humidity and temperature. Paper written ('high temperature and high humidity reduce the tranmission of covid-19' https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3551767). Shows there is a small relationship (apparently) between R and humidity and temperature. However, the relationship they've shown is no so large as an effect as what we would expect to see if the values were produced randomly. How do we know if the relationship we've correlated is large enough that we wouldn't expect it to occur from randomly generated values? There is the p-value measure which can tell us how likely it is the relationship can be produced by random. We start with the null hypothesis the relationship is random. Then look at whether the p-value is significant. However, the p-value measure, while widely used in medicine and lots of fields, is problematic. See the note from the American Statistical Assocation 'Statement on Statistical Significance and P-Values'. Notes how p-values are really problematic. Also worth looking at the work of Frank Harrell, Biostatistic Professor, 'Null Significance testing never worked' and "null hypothesis testing and p-values have done significant harm to science". But then in the paper, the authors did a multi-variate regression that included city size and population density and GDP, and because of that, they were able to state that the relationship or temperature/humidity and R value was statistical significant. (Had a small p-value). This is interesting. But p-values don't really tell you anything about the practical importance of the result. How do we decide that? Well, in this papers case, the relationship showed that a 30 degree (fahrenheit) increase could mean that the same city would go from an R value of less that 1 to an R value over 2. This is thus a practically signficant result. It makes a big difference to the effect if the papers modelling is correct.

Issues with p-values:
- Scientific method: Statistical errors: https://www.nature.com/news/scientific-method-statistical-errors-1.14700
- The ASA Statement on p-Values: Context, Process, and Purpose https://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108

The p-value measures the likelihood to relationship was produced by random. However, it does not measure how large the effect is. Plus it does not tell you whether the hypothesis is real. The p-value was invented by Ronald Fisher, one of the fathers of modern statitics. He did not intend for it to be used in any sort of definitive way. He suggested it is used by researchers to decide whether it's worth having a second-look at the data their studying. But in practice, in a lot of fields, p-values < 0.05 have become the bar for publication. The simple application of p-values is naive. Greater sophisication is needed to reliably apply statistics.

#### ASA Statement on P-values

https://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108

It says the p-value describes "how incompatible the data are with a specified statistical model". I.e. the p-value is a measure of how strange it is to see the data given the null-hypothesis is correct. But this means the p-value is not a "measure [of] the probability that the studied hypothesis is true, or the probability that the data were produced by random chance alone". The last part of this statement, I don't quite understand. I thought the p-value is primarily a measure of how likely it is the data is random (provided your models of the distribution is correct. Though I guess know whether your distribution model is correct is ... hard to know). "
Scientific conclusions and business or policy decisions should not be based only on whether a p-value passes a specific threshold". Yeah, this is basically saying the measure isn't everything and study design and all other sorts of factors are important to understand the situation. "Proper inference requires full reporting and transparency". I.e. it's not valid to run 100s of experiments and only report the ones that meet your p-value thresholds, as your basically dredging the data until you get a reading you want. The term 'p-hacking' is used for this sort of behaviour. "A p-value, or statistical significance, does not measure the size of an effect or the importance of a result". Yeah, the p-value doesn't say anything about what the relationship between the independent and dependent variables. 

The wikipedia page on [P-Values](https://en.wikipedia.org/wiki/P-value) is pretty good.



## Chapter 2 Questionaire

1. What is a p value?

Wiki says it best: a p-value "is the probability of obtaining test results at least as extreme as the results actually observed, under the assumption that the null hypothesis is correct"

2. What is a prior?

3. Provide an example of where the bear classification model might work poorly in production, due to structural or style differences in the training data.

4. Where do text models currently have a major deficiency?

They are good at producing text that non-experts may believe, but subject-matter experts quickly notice that the text doesn't make substantive sense. Deep learning has been pretty terrible at chat bots.

5. What are possible negative societal implications of text generation models?

Obviously there are a lot of potentially malicious uses for text generation. There is a paper - Malicious Uses of AI - that discuss some.

6. In situations where a model might make mistakes, and those mistakes could be harmful, what is a good alternative to automating a process?

You can put a human in the loop to double-check the automated assessment. Whether that is effective in practice is obviously dependent on other factors. I also think that baysian models can potentially be more useful in these sorts of scenarios, at least I've heard this opined, in that they can give more accurate assessments whether they understand the problem or not.

Obviously if the model might make a mistake and it can be catasphorically bad, then you ought never to build such a fully automated system. Like a fully automated system that could trigger nuclear war and then MAD would be folly. Similar you can also work to do a lot of validation that the automated system does not make mistakes at too great a rate, in practice. This is probably what's going to be happening in Teslas self-driving car stuff. Plus then you could also look to design other safety systems to reduce or avoid damage from the mistake. Etc etc.

7. What kind of tabular data is deep learning particularly good at?

Good for high cardinality data, that is data with lots and lots of discrete levels, say zip codes or product ids.

8. What's a key downside of directly using a deep learning model for recommendation systems?

Well it probably depends how you implement your deep learning model. But, in this chapter, the authors talked about recommendation systems that ended up just predicting items that the user already had purchased or similar items that the user knew about and had already discounted. With recommendation syste

There's surely a whole lot of other issues. For instance, whether it's possible for sellers to game the recommendation system so that they can get their items recommended more often. Whether the recommendation systems ever recommend that a user does not buy more stuff because they've already bought more things that they ought to buy. Whether a recommendation system can be used to 'individualise' reviews or ratings of items to reflect what this particular user would mostly likely rate the item. I.e. whether the recommendation is transparent that it's trying to predict ratings based on the users characteristics rather than reporting, without alteration, the reviews or ratings of other users.

9. What are the steps of the Drivetrain Approach?

What is the goal
What levers are there that can affect the system
What data can be collected
What are the outcomes
What modelling can we do that will let us drive how we use the levers to move the outcome towards the goal.

10. How do the steps of the Drivetrain Approach map to a recommendation system?



11. Create an image recognition model using data you curate, and deploy it on the web.



12. What is DataLoaders?



13. What four things do we need to tell fastai to create DataLoaders?



14. What does the splitter parameter to DataBlock do?



15. How do we ensure a random split always gives the same validation set?

The random seed value should be set.

16. What letters are often used to signify the independent and dependent variables?

I think Y is the dependent variable. X is the independent variable.

17. What's the difference between the crop, pad, and squish resize approaches? When might you choose one over the others?

These are all ways to manipulate an image so they are consistently sized (normalising the data?). Crop takes an image and just crops it to be a certain size. (Not sure what happens if the image is below crop size.) Pad adds stuff like a black band to fill out any missing image size. A squish transforms or shrinks the image to meet the size specified.

18. What is data augmentation? Why is it needed?

It can make your model more robust. Data augmentation is whether you alter the data going into the model in anyway, as a strategy to boast the performance of the model. When you collect your data to train the model with, you are collecting a sample from the whole population. But your model is then only trained on the sample. In fact, you want your model to perform well on the whole population. Data argumentation provides a way to boost your sample so that it is more reflective of the population. At least, that's what you hope to do with data argumentation.

19. What is the difference between item_tfms and batch_tfms?

These are fast-ai parameter to the learner. item_tfms = item transforms. These are transforms done on an individual item. batch_tfms = batch transforms. These transform are done on a bunch of items going into the network.

20. What is a confusion matrix?

A confusion matrix sets out the data that the model is predicting correctly or incorrectly. It's a two-by-two matrix. Each category is on both axis. One axis is the predictions and the other axis is the correct classification. It gives a way to plot the performance of the model.

| Actual | Prediction               |
|        |  Tiger |  Bear  | Walrus |
|Tiger   |    10  |    2   |    0   |
|Bear    |     0  |    13  |    0   |
|Walrus  |     1  |    0   |    7   |


21. What does export save?

Export saves a pickle object of the model, to disk, that you can then later reload.

22. What is it called when we use a model for getting predictions, instead of training?

Interference

23. What are IPython widgets?

Ipython widgets are GUI elements that ipython support, that you can render inside a notebook. Jupypter started as ipython and then jupyter was spun off as a seperate project that just contain stuff for notebooks. https://en.wikipedia.org/wiki/IPython

24. When might you want to use CPU for deployment? When might GPU be better?

Renting CPUs is typically less expensive that GPU in today's cloud market. When the model is trained, to actually run a single inference on it, does not require lots of simultaneous calculations that GPUs are so good at. So you really don't need a GPU to gets interferences efficiently from the model. GPUs may help if your service is recieving enough requests that you can batch the inferencing up. But obviously there's some latency issues to deal with around batch timing constraints, so a user isn't waiting too long to get a response if there are not enough simultaneous requests.

25. What are the downsides of deploying your app to a server, instead of to a client (or edge) device such as a phone or PC?

Deploying to a server requires network connections and incurs a network latency cost. There's also more potential for denial of service issues either by malicious activity, bugs or not enough server scaling to meet demand.

26. What are three examples of problems that could occur when rolling out a bear warning system in practice?


27. What is "out-of-domain data"?

That's data that you run inferences on that your model hasn't seen before. Like for example, the teddy-bear versus real bear detection, then we throw a banana at it. That's out of domain data, it's never seen it. The banana may be obviously out of domain, but there may be more subtle out-of-domain, like perhaps a teddy-bear that only has one ear, or rather than a bear, we show it a cub, or perhaps the bear is behind a bush, etc.

28. What is "domain shift"?

Domain shift is when the population changes. So lets say, we've trained the model on a representative and good non-bias sample of the population in year one. We then run inferences on it for three years, and everything is going well. But in the fourth year, the population begins to change - there is a domain shift - and now the model is making predictions on old data, and we'd need to retrain it.

29. What are the three steps in the deployment process?

Train the model.
Save the model.
Make inferences from the model.


https://www.oreilly.com/radar/drivetrain-approach-data-products/

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
- [malicious-ai-report]
- [environmental-sounds-classification]
- [splunk-mouse-image-fraud-detection]
- [malware-image-binaries-classification]

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
[malicious-ai-report]: https://maliciousaireport.com/
[environmental-sounds-classification]: https://medium.com/@etown/great-results-on-audio-classification-with-fastai-library-ccaf906c5f52
[splunk-mouse-image-fraud-detection]: https://www.splunk.com/en_us/blog/security/deep-learning-with-splunk-and-tensorflow-for-security-catching-the-fraudster-in-neural-networks-with-behavioral-biometrics.html
[malware-image-binaries-classification]: https://ieeexplore.ieee.org/abstract/document/8328749
