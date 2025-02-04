## World in conflict - A Twitter sentiment analysis
**Data visualizations: Telling stories with R & ggplot**

Course: https://zilinskyjan.github.io/DataViz/<br />
Lectured by [Jan Zilinsky](https://github.com/zilinskyjan), PhD @ Technical University of Munich

Wilkinson, L. (2005). The Grammar of Graphics (2nd ed.). Springer.<br />
https://doi.org/10.1007/0-387-28695-0


#### How we got here

Charts don't need to be ugly. But they don't need to bend the truth either to be attractive. We took this course to develop our abilities in communicating analytical insights more effectively and appropriately in our work and research activities.

With our graphics, we aim to stay truthful to the underlying data, present something functional and insightful that you might not have known yet and be gentle on the eyes.

#### What the data?

Deciding on a data source has, for once, been a more challenging part. Our first trial in geo-locating **Google Maps Timeline** data (drawing heatmaps and the like) turned out less fruitful than we had hoped. Correlating time series tracking data (#quantified self) with information on the weather or spending behavior is notoriously difficult to implement and didn't show enough promise in rendering novel insights to justify going forward.

Next, we stumbled upon data on our very own travel behavior using German rail company "**Deutsche Bahn**". Their booking confirmations deliver adequatly consistent data points on many aspects of a journey and could make us explore relationships between locations, pricing and the individual way of booking that are impossible to gather otherweise. The official API, though extensive, has rather little potential for application on the personal level, so we brainstormed new performance indicators and statistical calculations that might help us better understand and adjust out travel behavior. Unfortunately, the data from HTML emails and PDFs is gathered easiest using an LLM. We have been able to give it a try (see Jupyter notebook) but ultimately decided to go with a case project that does't demand our attention in both R and Python at the same time.  

We decided to decipher a large dataset on **Twitter** postings on **issues of security** that has been gathered recently in our research. Due its time-series form and high number of observations, we will be able to render insights more relevant to the broader public. It may even hold in predicting sentiment of similiar posts today on similiar topics.

###### Collecting

(Which topics exactly were targeted when collecting?)

(How did we collect data)

###### Wrangling

(What did we do to the data)

We aim to understand better the relationships of posts and sentiment, as well as network effects. Calculating margins and relative shares gives us a more nuanced understanding of the distribution on various issues.

###### Hypothesizing

(What did we expect to find)

#### Visualizing
- line chart for time series
- Facets to distinguish issue complexes
- macro, micro, case-perspective
- Data-to-ink ratio
- color

#### Our findings

(What are our results)

#### Learnings

The value of the guiding literature cannot be overstated (The Grammar of Graphics). Being exposed to misleading and unprofessional data visualizations in journalism has become the norm for the critical reader. We learned to
- define a viz's success criteria and understand our audience,
- focus more on the *Why* of a chart,
- make aesthetics a domain of our regular charting work in R,
- make use of the full potential of *ggplot2* and *tidyverse*,
- use Jupyter and GPT4.o to analyse HTML documents and output CSV tables.

Our coding lead to the creation of a side project that I will follow up on: making data from Deutsche Bahn work for me personally. It is the perfect opportunity to finally dive into talking to LLMs like GPT4 via an API and tinkering around with them in Python. Let's not get religious though, Python and R both have their very own appeal and use case, neither is going anywhere too soon...

---
[Jannis Haendke](https://www.linkedin.com/in/haendke/), Sebastián Aguilar (February 2025)<br />
Liked our work? Drop us a message and let's chat about the next data project!
