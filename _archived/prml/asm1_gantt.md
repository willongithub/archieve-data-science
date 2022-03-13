Gantt code for Mermaid.js
```
    gantt
    title Roadmap
    dateFormat  DD-MM-YYYY
    todayMarker off
    
    section Extract features
    Trending_Score  :p1, 11-09-2021, 1d
    Title_Score     :p2, after p1, 1d
    Critic_Score    :p3, after p2, 3d
    Public_Score    :p4, after p3, 1d
    Sentiment_Score :crit, p5, after p4, 1d
    section Tune model
    Build Model     :crit, t1, after p5, 1d
    Tune Param      :crit, t2, after t1, 3d
    section Evaluate result
    Evaluate        :crit, e1, after t2, 2d
    Wrap-Up         :e2, after e1, 1d

```