## World in conflict - An X (Twitter) sentiment analysis
**Course: Data visualizations - Telling stories with R & ggplot**<br />
Lectured by Jan Zilinsky, PhD @ Technical University of Munich[^1]

Resources:
- Wilkinson, L. (2005). The Grammar of Graphics (2nd ed.). Springer. [https://doi.org/10.1007/0-387-28695-0](https://doi.org/10.1007/0-387-28695-0 "The Grammar of Graphics (2005)")
- Data Visualization with R and ggplot [https://zilinskyjan.github.io/DataViz/](https://zilinskyjan.github.io/DataViz/ "Course content")


### How we got here

Charts don't need to be ugly. But they don't need to bend the truth either to be attractive. Being exposed to unprofessional and, at times, misleading data visualizations in journalism and on social media has become the norm for critical readers. We took this course to develop our abilities in communicating analytical insights more effectively and appropriately in our work and research activities; stay truthful to the underlying data, and present something insightful that might not have obvious before.

### What the data?

Deciding on a data source has, for once, been a more challenging part. Our first trial in geo-locating **Google Timeline data** (drawing heatmaps etc.) using `library(sf)`[^2] turned out less fruitful than we had hoped. Correlating time series tracking data (#quantified self) with information on the weather or spending behavior is notoriously difficult to implement and didn't show enough promise in rendering novel insights to justify going forward. If you're interested doing something similiar yourself, see [Google Takeout](https://takeout.google.com/settings/takeout "Google Takeout") and [this project](https://github.com/kurupted/google-maps-timeline-viewer "google-maps-timeline-viewer").

Next, we stumbled upon data on our very own travel behavior. **Booking confirmations by "Deutsche Bahn"**, a German rail company, deliver adequatly consistent data points on many aspects of a journey and could make us explore relationships between locations, pricing and the individual way of booking that are impossible to gather otherweise. The [official API](https://developers.deutschebahn.com/ "DB API Marketplace"), though extensive, has rather little potential for application on the personal level, so we brainstormed new performance indicators and statistical calculations that might help us better understand and adjust out travel behavior. Unfortunately, making sense of both HTML emails and PDF is easiest using an LLM. While we have been able to give it a try (GPT4o, using Jupyter notebook), we ultimately decided to go with a case project that does't demand our attention in both R and Python at the same time.  

We ultimately went with analyzing a large data set on **X (Twitter) postings on issues of security** that has been gathered recently in our research. Thanks to its time-series form and high number of observations, we will be able to render insights more relevant to the broader public. It may even hold in predicting sentiment of posts on similiar topics.

###### Collecting

We included tweets about inner and international security from January 2023 to November 2024. Find the list of queries [`twikit_query.md`](twikit_query.md "twikit_query.md"). To collect our data, we made use of the [`Twikit`](https://github.com/d60/twikit "Twikit API Scraper") library[^3] in Python as a free alternative to the official X API. We collected all tweets pertaining to our query per month until all data for the aforementioned time period was collected.

###### Wrangling

We preprocessed our data in multiple ways. 
1. First, we anonymized all data obtained, ensuring no personal data remained on our data set. 
2. Second, we removed all hashtags, links, and mentions, as they would interfere with our sentiment analysis. 
3. Lastly, we used the [`multilingual XLM-roBERTa-Base`](https://huggingface.co/cardiffnlp/twitter-xlm-roberta-base-sentiment "XLM-roBERTa-Base on Huggingface") sentiment model[^4][^5] to classify all our or tweets into three categories: positive, neutral, or negative.

We aim to understand better the relationships of posts and sentiment, network effects, and discourse intensity on select issues. Calculating margins and relative shares gives us a more nuanced understanding of the distributions.

###### Hypothesizing

After gathering our data, we expected to find:

1. The discussion on X around security issues to be mostly negative due to the current geopolitical landscape and recent terrorist attacks within Germany.[^6][^7]
2. Considerable spikes in activity and negative tweets after significant events (e.g. Hamas attacks on Israel)[^8] as the data set captures primarily security issues. 
3. Engagement with tweets on security remaining relatively low (discourse shaped most significantly by a small group).

### Our findings

![alt text](/chart1/pvolsentimentline.svg "Post volume, by positive & negative sentiment")

> [!NOTE]
> 

> [!WARNING]
> **This data set is highly selective due to the specific research design. Do not generalize.**
> **Results are <ins>preliminary</ins>. Please do your own calculations before publishing any insights elsewhere.**

**More charts:**
- Macro time-series
  - [Post volume by date](/chart1/chart1.md)
  - [Post volume, by date & Sentiment](/chart1/chart1.md)
- Micro time-series:
  - [Timeline for attacks Israel, Mannheim, Solingen](/chart2/chart2.md)
- Engagement analytics:
  - [Post volume by user & Engagement intensity](/chart3/chart3.md)

### Learnings

The value of the guiding literature and thinking hard about the data-to-ink ratio cannot be overstated ("Grammar" of graphics)[^9]. We learned to
- define a visualization's success criteria,
- focus on the *Why* of a chart,
- make aesthetics a domain of our regular charting work in R,
- make use of the full potential of [`ggplot2`](https://ggplot2.tidyverse.org/ "ggplot2 package")[^10] and [`tidyverse`](https://www.tidyverse.org/ "tidyverse.org")[^11],
- use Jupyter and GPT4o to analyze HTML documents and output CSV tables.

--- 
Jannis Haendke, Sebastián Aguilar (2025)<br />
*Liked our work? Drop us a message & let's chat about the next data project!*

[^1]: Jan Zilinsky, [https://www.janzilinsky.com/](https://www.janzilinsky.com/ "janzilinsky.com")

[^2]: Simple Features for R, [https://r-spatial.github.io/sf/](https://r-spatial.github.io/sf/ "sf package")

[^3]: Twikit, [https://github.com/d60/twikit](https://github.com/d60/twikit "twikit library")

[^4]: Barbieri, F., Anke, L. E., & Camacho-Collados, J. (2021). *XLM-T: Multilingual Language Models in Twitter for Sentiment Analysis and Beyond* (Version 2). arXiv. [https://doi.org/10.48550/ARXIV.2104.12250](https://doi.org/10.48550/ARXIV.2104.12250 "Barbieri et al. 2021")

[^5]: Huggingface model card, [https://huggingface.co/cardiffnlp/twitter-xlm-roberta-base-sentiment](https://huggingface.co/cardiffnlp/twitter-xlm-roberta-base-sentiment "XLM-roBERTa-Base on Huggingface")

[^6]: May 31st 2024 (Mannheim), [https://en.wikipedia.org/wiki/2024_Mannheim_stabbing](https://en.wikipedia.org/wiki/2024_Mannheim_stabbing "Wiki: 2024 Mannheim stabbing")

[^7]: August 23rd 2024 (Solingen), [https://en.wikipedia.org/wiki/2024_Solingen_stabbings](https://en.wikipedia.org/wiki/2024_Solingen_stabbings "Wiki: 2024 Solingen stabbings")

[^8]: October 7th 2023 (Israel) [https://en.wikipedia.org/wiki/7_October_Hamas-led_attack_on_Israel](https://en.wikipedia.org/wiki/7_October_Hamas-led_attack_on_Israel "Wiki: 2023 Hamas-led attack on Israel")

[^9]: Wilkinson, L. (2005). The Grammar of Graphics (2nd ed.). Springer. [https://doi.org/10.1007/0-387-28695-0](https://doi.org/10.1007/0-387-28695-0 "The Grammar of Graphics (2005)")

[^10]: Tidyverse packages for data science, [https://ggplot2.tidyverse.org/](https://ggplot2.tidyverse.org/ "tidyverse packages")

[^11]: ggplot2 declarative graphics [https://www.tidyverse.org/](https://www.tidyverse.org/ "ggplot2 package")
