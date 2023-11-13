USE `rdcbrand`;

CREATE TABLE `orders` (
    `row_id` int  NOT NULL ,
    `ret_id` int  NOT NULL ,
    `invoice_date` date  NOT NULL ,
    `location_id` int  NOT NULL ,
    `product` varchar(200)  NOT NULL ,
    `price_per_unit` decimal(5,2)  NOT NULL ,
    `units_sold` int  NOT NULL ,
    `total_sales` decimal(8,2)  NOT NULL ,
    `operating_profit` decimal(8,2)  NOT NULL ,
    PRIMARY KEY (
        `row_id`
    )
);

CREATE TABLE `retailers` (
    `ret_id` int  NOT NULL ,
    `retailer` varchar(100)  NOT NULL ,
    `retailer_id` int  NOT NULL ,
    `sales_method` boolean  NOT NULL ,
    PRIMARY KEY (
        `ret_id`
    )
);

CREATE TABLE `location` (
    `location_id` int  NOT NULL ,
    `region` varchar(50)  NOT NULL ,
    `state` varchar(50)  NOT NULL ,
    `city` varchar(100)  NOT NULL ,
    PRIMARY KEY (
        `location_id`
    )
);

ALTER TABLE `retailers` ADD CONSTRAINT `fk_retailers_ret_id` FOREIGN KEY(`ret_id`)
REFERENCES `orders` (`row_id`);

ALTER TABLE `location` ADD CONSTRAINT `fk_location_location_id` FOREIGN KEY(`location_id`)
REFERENCES `orders` (`row_id`);

#Find Units Sold and the average number of units sold.
SELECT `Units Sold`, (SELECT AVG(`Units Sold`) FROM rdc_orders) AS average
FROM rdc_orders;

#Find the Locations that sell more units than the average of all units sold.
SELECT * 
FROM rdc_locations AS a JOIN rdc_orders AS b ON (a.`Row ID`=b.`Row ID`)
WHERE `Units Sold` >= ((SELECT AVG(`Units Sold`) FROM rdc_orders));

#Find the most lucrative product sold.
SELECT DISTINCT a.`Product`, SUM(b.`Units Sold`)
FROM rdc_orders AS a JOIN rdc_orders AS b ON (a.`Row ID`=b.`Row ID`)
GROUP BY a.`Product`;

#Find the most popular sales method.
SELECT a.`Sales Method`, SUM(b.`Units Sold`)
FROM rdc_retailers AS a JOIN rdc_orders AS b ON (a.`Row ID`=b.`Row ID`)
GROUP BY a.`Sales Method`;

#Find the top 2 regions that sell the most units.
SELECT b.`Region`, SUM(a.`Units Sold`)
FROM `rdc_orders` AS a JOIN `rdc_locations` AS b ON (a.`Row ID`=b.`Row ID`)
GROUP by `Region`
LIMIT 2
