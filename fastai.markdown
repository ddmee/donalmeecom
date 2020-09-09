---
layout: page
title: Fast AI
permalink: /fastai/
---

# Fast AI

## Practical deep-learning for coders

- At [course-fast-ai]. Using Google Cloud platform.
- There is a full book called [*'Deep Learning for Coders with fastai and PyTorch'*]([deep-learning-for-coders-book-amazon]). It's actually available for free at [fast-book-git] in jupyter notebook form. Please buy a copy of the book if you enjoyed the course. 


### Compute

Recommended to use a cloud service for running jupyter notebooks, easier setup, reasonable cost etc. I decided to use Google Cloud Platform [google-cloud-console], because I already have an account. I haven't logged into it for about a year, and it's amazing to see how much progress Google have made to improve the UIX in that year. Well done Google.

Once you follow [these instructions](google-cloud-setup-instructions) to get an appropriate notebook available in Google cloud, you can [view your running instances](https://console.cloud.google.com/ai-platform/notebooks/list/instances).

Make sure to stop your running instance once you've finished for the day. Otherwise, you will get billed for time you weren't using.

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


## Referefences

- [course-fast-ai]
- [course-fast-ai-videos-lesson-1]
- [fast-book-git]
- [deep-learning-for-coders-book-amazon]
- [google-cloud-console]
- [google-cloud-setup-instructions]
- [google-cloud-notebook-instances]

[course-fast-ai]: https://course.fast.ai/
[course-fast-ai-videos-lesson-1]: https://course.fast.ai/videos/?lesson=1
[fast-book-git]: https://github.com/fastai/fastbook
[fast-book-jupyter-notebook-101]: https://github.com/fastai/fastbook/blob/master/app_jupyter.ipynb
[deep-learning-for-coders-book-amazon]: https://www.amazon.co.uk/Deep-Learning-Coders-fastai-PyTorch/dp/1492045527
[google-cloud-console]: https://console.cloud.google.com/
[google-cloud-setup-instructions]: https://course.fast.ai/start_gcp
[google-cloud-notebook-instances]: https://console.cloud.google.com/ai-platform/notebooks/list/instances
[jupyter-lab-docs]: https://jupyterlab.readthedocs.io