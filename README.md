# Airbnb_Manhattan
## How can we improve the Airbnb experience in Manhattan?
### By Melody Niere

## Introduction
Airbnb is an online marketplace focused on short term rentals. The platform allows for host to connect with guest looking for unique and affordable accomdations. 
This project gives suggestions on how airbnb can improve in Manhattan based on review scores. 

## [Slide Deck](https://docs.google.com/presentation/d/e/2PACX-1vQhBzsIAokWvRJG2le110wwaAwOAwS1JtcrA1qSVcAmHj1nElPCt67ONoMwk3Bh0Lz_JC2GaA4UP6mR/pub?start=false&loop=false&delayms=3000&slide=id.p)

## Dataset
Data is from [InsideAirbnb](http://insideairbnb.com/get-the-data/) 
This include over 35,000+ rows and 70+ columns of data

## Tools
SQL was used for data exploration and for querying text reviews using terms associated with dirty conditions. See example SQL below:
<br> ![dirty comments](https://user-images.githubusercontent.com/105595931/208982770-4661d6bb-c5e6-49e8-b5b9-165675f202bb.JPG)

<br>Python was used to extracted the necessary rows and columns and create a dataframe. Dataframe was then exported to a CSV. In addition, Python was used to calculate the correlation between review categories and overall review scores. 
<br>Tableau was used for visualizations. 

## Findings
1. In NYC, Manhattan has the most Airbnb units. 
![tableau](https://user-images.githubusercontent.com/105595931/208982750-7238960e-b2eb-4c0f-aee0-671cec4a562f.JPG)

2. Value, Accuracy and Cleanliness is most correlated with the overall guest score.
![correlation](https://user-images.githubusercontent.com/105595931/208982718-77415dd9-0b3f-421a-975a-75ed12ddd084.JPG)

3. There are over 600 Airbnb units that state they are located in NYC but are actually located in New Jersey.
![Capture](https://user-images.githubusercontent.com/105595931/208982623-ec9da174-63e7-41f6-86df-154ed2d94549.JPG)

4. Found Airbnb host who have over 20 units and were below the average cleanliness score
