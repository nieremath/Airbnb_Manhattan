
-- Select only manhattan airbnb
SELECT *
FROM listings
WHERE neighbourhood_group_cleansed = 'Manhattan';

-- Count number of listing in Manhattan = 8,473
SELECT COUNT(*)
FROM listings l 
WHERE neighbourhood_group_cleansed = 'Manhattan';

-- Count by neighborhood - Harlem has the most airbnb
SELECT neighbourhood_cleansed, COUNT(*)
FROM listings l 
WHERE neighbourhood_group_cleansed = 'Manhattan'
GROUP BY neighbourhood_cleansed
ORDER BY COUNT(*) DESC;

-- Top five most airbnb's neighborhoods in Manhattan
-- Harlem has the most airbnb's with 941
SELECT neighbourhood_cleansed, COUNT(*)
FROM listings l 
WHERE neighbourhood_group_cleansed = 'Manhattan'
GROUP BY neighbourhood_cleansed
ORDER BY COUNT(*) DESC;

-- What types of properties in harlem?
SELECT neighbourhood_cleansed, property_type, COUNT(*)
FROM listings l 
WHERE neighbourhood_cleansed = 'Harlem'
GROUP BY property_type;

-- How many host their entire space = 428
SELECT neighbourhood_cleansed, COUNT(*) as num_of_entire
FROM listings l 
WHERE neighbourhood_cleansed = 'Harlem' 
AND property_type LIKE 'Entire%';

-- How many host a portion of their space? = 509
SELECT neighbourhood_cleansed, COUNT(*) as num_of_entire
FROM listings l 
WHERE neighbourhood_cleansed = 'Harlem' 
AND (property_type LIKE 'Private%' or property_type LIKE 'Shared%');

-- Which neighborhood has the rentals that use the entire space?
-- While Harlem has the most airbnb rentals, majority of their rentals share space.
-- Upper East Side = 570 and Upper West Side = 550, has the most rentals of entire spaces
SELECT neighbourhood_cleansed, COUNT(*)
FROM listings l 
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'
GROUP BY neighbourhood_cleansed
ORDER BY COUNT(*) DESC;

-- Top 5 neighborhoods that host the entire space
SELECT neighbourhood_cleansed, COUNT(*)
FROM listings l 
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'
GROUP BY neighbourhood_cleansed
ORDER BY COUNT(*) DESC;

-- fix the dollar sign in the price
SELECT *, price, CAST(REPLACE(price,'$','') as UNSIGNED) as price_clean 
FROM listings l 

-- Which neighborhoods cost the most to stay in for entire rentals?

-- CTE to clean price
WITH neighborhood_cost as
	(
	SELECT *, price, CAST(REPLACE(price,'$','') as UNSIGNED) as price_clean 
	FROM listings l
	)
SELECT neighbourhood_cleansed, AVG(price_clean) as avg_price
FROM neighborhood_cost 
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'
GROUP BY neighbourhood_cleansed
ORDER BY AVG(price_clean) DESC;

-- Combine avg cost of entire rental and number of rentals

-- CTE to clean price
WITH neighborhood_cost as
	(
	SELECT *, price, CAST(REPLACE(price,'$','') as float) as price_clean 
	FROM listings l
	)
SELECT neighbourhood_cleansed, AVG(price_clean) as avg_price, COUNT(*) as num_of_rentals
FROM neighborhood_cost 
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'
GROUP BY neighbourhood_cleansed
ORDER BY count(*) DESC;

-- average cost of entire rental in manhattan
-- CTE to clean price
WITH neighborhood_cost as
	(
	SELECT *, price, CAST(REPLACE(price,'$','') as float) as price_clean 
	FROM listings l
	)
	SELECT AVG(price_clean) as avg_price, COUNT(*) as num_of_rentals
FROM neighborhood_cost 
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%';


-- Joining comments with listings 
WITH comment_table AS(
	SELECT listing_id, comments 
	FROM reviews r 
)
SELECT *
FROM comment_table
JOIN listings l 
ON comment_table.listing_id = l.id
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'

-- Count number of times word dirty was used
WITH comment_table AS(
	SELECT listing_id, comments 
	FROM reviews r 
)
SELECT l.neighbourhood_cleansed, COUNT(*)
FROM comment_table
JOIN listings l 
ON comment_table.listing_id = l.id
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'
AND (
comments LIKE '%dirty%' or 
comments LIKE '%disgust%' or 
comments LIKE '%unclean%' OR
comments LIKE '%filth%' OR
comments LIKE '%stain%' OR 
comments LIKE '%dust%' OR
comments LIKE '%avoid%' OR
comments LIKE '%not clean%' OR
comments LIKE '%avoid%' OR
comments LIKE '%mildew%')
GROUP BY l.neighbourhood_cleansed
ORDER BY COUNT(*) DESC


-- look at comments
WITH comment_table AS(
	SELECT listing_id, comments 
	FROM reviews r 
)
SELECT l.neighbourhood_cleansed, comments
FROM comment_table
JOIN listings l 
ON comment_table.listing_id = l.id
WHERE neighbourhood_group_cleansed = 'Manhattan'
AND property_type LIKE 'Entire%'
AND (
comments LIKE '%dirty%' or 
comments LIKE '%disgust%' or 
comments LIKE '%unclean%' OR
comments LIKE '%filth%' OR
comments LIKE '%stain%' OR 
comments LIKE '%dust%' OR
comments LIKE '%avoid%' OR
comments LIKE '%not clean%' OR
comments LIKE '%avoid%' OR
comments LIKE '%mildew%')
ORDER BY l.neighbourhood_cleansed 


-- combine number dirty units with average price
-- does not work
WITH comment_table AS(
	SELECT listing_id, comments 
	FROM reviews r),
dirty_comments as(
	SELECT l.neighbourhood_cleansed, COUNT(*) as num_comments
	FROM comment_table
	JOIN listings l 
	ON comment_table.listing_id = l.id
	WHERE neighbourhood_group_cleansed = 'Manhattan'
	AND property_type LIKE 'Entire%'
	AND (
	comments LIKE '%dirty%' or 
	comments LIKE '%disgust%' or 
	comments LIKE '%unclean%' OR
	comments LIKE '%filth%' OR
	comments LIKE '%stain%' OR 
	comments LIKE '%dust%' OR
	comments LIKE '%avoid%' OR
	comments LIKE '%not clean%' OR
	comments LIKE '%avoid%' OR
	comments LIKE '%mildew%')
	GROUP BY l.neighbourhood_cleansed),
price_table as
	(
	SELECT *, price, CAST(REPLACE(price,'$','') as float) as price_clean 
	FROM listings l
	),
neighbourhood_price as (
	SELECT neighbourhood_cleansed, AVG(price_clean) as avg_price
	FROM price_table
	WHERE neighbourhood_group_cleansed = 'Manhattan'
	AND property_type LIKE 'Entire%'
	GROUP BY neighbourhood_cleansed)	
SELECT dirty_comments.neighbourhood_cleansed, dirty_comments.num_comments, neighbourhood_price.avg_price
FROM dirty_comments
JOIN neighbourhood_price ON dirty_comments.neighbourhood_cleansed = neighbourhood_price.avg_price

-- create spreadsheet with host and review scores
-- CTE to clean price
WITH neighborhood_cost as
	(
	SELECT *, price, CAST(REPLACE(price,'$','') as float) as price_clean 
	FROM listings l
	)
SELECT host_id, host_name, host_response_rate, host_acceptance_rate, host_total_listings_count ,price_clean, review_scores_rating, review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, 
review_scores_communication, review_scores_location, review_scores_value 
FROM neighborhood_cost 
WHERE neighbourhood_group_cleansed = 'Manhattan';

-- Create spreadsheet that only has Manhattan and selected columns for python analysis
SELECT host_id, host_name, neighbourhood_cleansed, property_type, bedrooms, beds, price, review_scores_rating, 
review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, review_scores_communication, review_scores_location, review_scores_value 
FROM listings l 
WHERE neighbourhood_group_cleansed = 'Manhattan';

--- Look at manhattan spreadsheet from python
SELECT * FROM manhattan m 

SELECT distinct property_type 
from manhattan m 

