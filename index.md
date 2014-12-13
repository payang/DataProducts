---
title       : Maternal, Newborn and Child Health
subtitle    : Exploring open data with R, Shiny and Slidify
author      : Patrick Yang
job         : 
framework   : revealjs        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---

## Executive Summary

This project serves a dual purpose.  It constitutes the author's submission for Coursera's course 'Developing Data Products' within the Data Scientist specialisation offered by Faculty from John Hopkins Bloomberg School of Public Health.  It also provides for visual exploration of open data provided by the Canadian *Department of Foreign Affairs, Trade and Development* and the *World Bank*.

--- .class #id 

## About the MNCH project

In 2010, Canada announced the **Muskoka Initiative**. That Initiative seeks to mobilize global action to reduce maternal mortality and improve the health of mothers and children in the world's poorest countries.

Hundreds of thousands of women die each year due to complications consecutive to pregnancy or childbirth. In addition, 6.6 million children died before reaching the age of five in 2012.

Over the period covering 2010 to 2015, $1.1 billion will be added to $1.75 billion already budgeted by the Canadian government to improve the situation of mothers and children.

---

## About the MNCH project (Continued)

### Focus on three paths

- Strengthening health systems
- Reducing the burden of leading diseases
- Improving nutrition

---

## About the MNCH project (Continued)

### Focus on 10 countries
- Afghanistan
- Bangladesh
- Ethiopia
- Haiti
- Malawi
- Mali
- Mozambique
- Nigeria
- Sudan
- Tanzania


--- .class #id 

## Course project

The Shiny package under R is used to manipulate the data and provide a visual output allowing analysis.  The URL to access this Shiny application is https://ypat.shinyapps.io/MNCH.

Funds spent each year under the MNCH heading for each of the 10 countries identified as priorities are totalled.  The ratios indicate the dollar contribution for each element, eg. births means the yearly contribution in dollars divided by the number of live births that year.  Two ratios with ties to the three paths are proposed.

No analysis of the data was conducted since the stated purpose of the project is to use the tools, Shiny and Slidify.

--- .class #id 

## Course project (Continued)

The function tapply was used to obtain totals of MNCH funds spent per country.

  tapply(df.2012.2013[[2]],INDEX=df.2012.2013[[1]],sum)

Other calculations involved:
- Calculating number of births (birth rate * population * adjustment)
- Calculating number of maternal deaths (maternal mortality ratio * live births * adjustment)
- Calculating funds per live birth (funds spent / births)
- Calculating funds per maternal deaths (funds spent / maternal deaths)
