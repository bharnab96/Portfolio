use  sales_analysis
select * from sales;
select * from products;

EXEC sp_rename 'dbo.products$', 'products';
EXEC sp_rename 'dbo.Sales$', 'sales';

EXEC sp_help 'sales';

-----------------------------------------------------------------------------------------------------------------------


   
-- Total Sales by Region and Year
 select 
s.Region,
SUM(s.totalsales) as total_sales,
year(s.saledate) as year,
SUM(s.profit)as total_profit,
round(AVG(s.profit/nullif(s.totalsales,0)*100),2) as profit_margin,
COUNT(*) as transaction_count

 from sales s 
 group by s.Region,year(saledate)
 order by s.Region,year(saledate) desc;
 


-- Product Performance by Category

select
p.Category,
p.ProductName,
round(SUM(s.TotalSales),2) as total_sales,
round(SUM(s.Profit),2) as total_profit,
round(avg(Profit/nullif(totalsales,0)*100),2) as profit_margin,
COUNT(distinct s.Region) as regions_covered,
COUNT(*) as transaction_count

 from sales s join products p
 on s.ProductID=p.ProductID
 group by p.Category,p.ProductName
 order by p.Category,total_sales desc;
 



 -- Sales Growth % by Region and Year (Year-over-Year)





WITH agg AS (
  SELECT
    region,
    YEAR(SaleDate) AS sales_year,
    SUM(totalsales) AS yearly_sales
  FROM sales
  GROUP BY region, YEAR(SaleDate)
)
SELECT
  a.region,
  a.sales_year,
  a.yearly_sales AS current_year_sales,
  b.yearly_sales AS previous_year_sales,
  CASE
    WHEN b.yearly_sales IS NULL OR b.yearly_sales = 0 THEN NULL
    ELSE ROUND( ( (a.yearly_sales - b.yearly_sales) / b.yearly_sales ) * 100, 2 )
  END AS growth_percent
FROM agg a
LEFT JOIN agg b
  ON a.region = b.region
 AND a.sales_year = b.sales_year + 1
ORDER BY a.region, a.sales_year;






--Use GROUP BY + SUM/AVG to calculate total sales, profit margin, and growth % by region, year, and product.







  







select * from sales




select * from sales;

--Use GROUP BY + SUM/AVG to calculate total sales, profit margin, and growth % by region, year, and product.


  with  agg as(
select Region,
year(saledate) as sales_year,
SUM(totalsales) as yearly_sales,
SUM(Profit) as yearly_profit,
case when SUM(TotalSales)=0 then 0
else round((SUM(profit)/SUM(TotalSales))*100,2)
end as profit_margin_percent
 from  sales group by Region,year(saledate)
 )
 select 
 a.Region, 
 a.sales_year,
 a.yearly_sales as current_year_sales,
 b.yearly_sales as previous_year_sales,
 case when b.yearly_sales IS null OR b.yearly_sales=0 then null
 else round(((a.yearly_sales-b.yearly_sales)/b.yearly_sales)*100,2)
 end as growth_percent,
a.yearly_profit as current_year_profit,
b.yearly_profit as previous_year_profit,
a.profit_margin_percent as current_profit_margin,
b.profit_margin_percent as previous_profit_margin,
case when b.profit_margin_percent IS null then null
else round(a.profit_margin_percent-b.profit_margin_percent,2)
end as profit_margin_change
 
  from agg a left join agg b on a.Region=b.Region
  and a.sales_year=b.sales_year+1
order by a.Region,a.sales_year
 
 
 
 
 select * from products;
 select * from sales;

 
 
 CREATE VIEW sales_profit_view AS
SELECT 
    s.region,
    year(s.SaleDate) as sales_year,
    sum(s.TotalSales) AS total_sales,
    s.profit AS current_profit,
    p.TotalSales AS previous_sales,
    p.profit AS previous_profit,
    case when p.TotalSales IS null then null
    else round(((s.TotalSales-p.TotalSales)/p.TotalSales)*100,2) 
    end AS sales_growth_percent,
    round((s.profit - p.profit) * 100.0 / NULLIF(p.profit,0),2) AS profit_growth_percent,
    round((s.profit * 100.0 / NULLIF(s.totalsales,0)),2) AS current_profit_margin,
    round((p.profit * 100.0 / NULLIF(p.totalsales,0)),2)
     AS previous_profit_margin
FROM sales s
LEFT JOIN sales p
    ON s.region = p.region
    AND year(s.saledate) = year(p.SaleDate) + 1
    group by s.Region,year(s.saledate),
  s.TotalSales,
    s.profit,
    p.TotalSales ,
    p.profit;
    
    
  
  
    ;   -- previous year match

 
select * from sales_profit_view;
 
DROP VIEW sales_profit_view;
