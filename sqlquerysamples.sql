-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
Select * from products;
Select product_name, quantity_per_unit from products;

-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
Select product_id, product_name from products
where discontinued =1;

-- 3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
Select product_id, product_name, discontinued from products
where discontinued =1;

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
Select product_id, product_name, unit_price from products where unit_price<20;

-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
Select product_id, product_name, unit_price from products where unit_price between 15 AND 25;

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
Select product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order;

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.
Select * from products where lower (product_name) like 'a%';

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.
Select * from products where lower (product_name) like '%i';

-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
Select product_name, unit_price, (unit_price * 1.18) AS UnitPriceKDV from products;

-- 10. Fiyatı 30 dan büyük kaç ürün var?
--select unit_price from products where unit_price>30;
Select count (*) unit_price from products where unit_price>30;

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
Select lower (product_name) AS productname , unit_price from products  
Order by unit_price DESC;

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
Select (first_name || ' ' || last_name) AS AdSoyad from employees;

-- 13. Region alanı NULL olan kaç tedarikçim var?
Select Count (*) from suppliers where region is null;

-- 14. a.Null olmayanlar?
Select Count (*) from suppliers where region is not null;

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyük olarak ekrana yazdır.
Select ('TR' || ' '|| UPPER (product_name)) AS TR from products;

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
Select ('TR' || ' '|| product_name) AS TR , unit_price from products where unit_price<20;

-- 17. En pahalı ürünün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
Select  product_name, unit_price from products 
Where unit_price = (Select MAX (unit_price) from products);

-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
Select product_name, unit_price FROM products 
ORDER BY unit_price DESC LIMIT 10;

-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
Select  product_name, unit_price from products
where unit_price > (select AVG (unit_price) FROM products);

-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
--a.Satıştan kazanılan toplam miktar 
Select SUM (unit_price * units_in_stock) as miktar from products;

--b.Satılan ürün miktarı
Select SUM (units_in_stock) as toplam from products;

-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select product_name,discontinued,units_in_stock from products
where units_in_stock >0 And discontinued =1;

SELECT COUNT(*) AS total_count, product_name FROM products
WHERE units_in_stock > 0 AND discontinued = 1
GROUP BY product_name;

-- Devam eden ve durdurulan ürünler
-- select discontinued, count(*) from products
-- group by discontinued;

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
Select products.product_name ,categories.category_name from products
INNER JOIN categories ON categories. category_id = products.category_id
-- SELECT p.category_name, p.product_name, 
-- FROM Products p
-- JOIN Categories c ON p.CategoryID = c.CategoryID;

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT category_id, AVG(unit_price) AS average_price FROM products
GROUP BY category_id;

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
Select  p.product_name, p.unit_price, c.category_name from products p
INNER JOIN categories c ON c. category_id = p.category_id
Where unit_price = (Select MAX (unit_price) from products);

SELECT p.product_name, p.unit_price, c.category_name FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY p.Unit_price DESC LIMIT 1;

-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
Select  p.product_name,  c.category_name, s.company_name from products p
JOIN categories c ON c. category_id = p.category_id 
JOIN suppliers s ON s.supplier_id = p.supplier_id
Where units_on_order = (Select MAX (units_on_order) from products);
/**************************************************************************************************************/
--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi 
--ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name, s.company_name, s.phone from products p
inner join suppliers s on p.supplier_id = s.supplier_id 
where p.units_in_stock = 0;
--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select o.ship_address as "Sipariş adresi", (e.first_name || ' ' || e.last_name) as "çalışanın adı"  from orders o
inner join employees e on e.employee_id = o.employee_id
where order_date between '01.03.1998' and '31.03.1998'
order by order_date;
--28. 1997 yılı şubat ayında kaç siparişim var?
select sum(od.quantity) as "97 şubat toplam satış miktarı" from orders o
inner join order_details od on o.order_id = od.order_id
where date_part('year',order_date) = 1997 and date_part('month',order_date) = 2;
--29. London şehrinden 1998 yılında kaç siparişim var?
select o.ship_city, sum(od.quantity) as "98 toplam satış miktarı" from orders o
inner join order_details od on o.order_id = od.order_id
where date_part('year',order_date) = 1998 and o.ship_city = 'London'
group by o.ship_city;
--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name, c.phone, o.order_date from orders o
inner join customers c on c.customer_id = o.customer_id
where date_part('year',order_date) = 1997 
group by c.contact_name, c.phone, o.order_date;
--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders where freight > 40;
--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select o.ship_city, c.contact_name, o.freight from orders o
inner join customers c on c.customer_id = o.customer_id
where o.freight >= 40
order by o.freight;
--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select o.order_date, o.ship_city, upper(e.first_name||e.last_name) as müşteri from orders o
inner join employees e on e.employee_id = o.employee_id
where date_part('year',order_date) = 1997;
--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select o.order_date, c.contact_name, regexp_replace(c.phone, '[^0-9]','','g') as telefon from orders o
inner join customers c on c.customer_id = o.customer_id
where date_part('year',order_date) = 1997
group by o.order_date, c.contact_name, telefon;
--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date, c.contact_name, e.first_name, e.last_name from orders o
inner join customers c on c.customer_id = o.customer_id
inner join employees e on e.employee_id = o.employee_id;
--36. Geciken siparişlerim?
select o.order_id, o.required_date, o.shipped_date from orders o
where o.shipped_date > o.required_date;
--37. Geciken siparişlerimin tarihi, müşterisinin adı
select c.contact_name, o.order_id, o.order_date, o.required_date, o.shipped_date from orders o
inner join customers c on c.customer_id = o.customer_id
where o.shipped_date > o.required_date;
--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity from order_details od
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
where od.order_id = 10248;
--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.contact_name from order_details od
inner join products p on p.product_id = od.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
where od.order_id = 10248;
--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity, o.order_id from order_details od
inner join products p on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id = 3 and date_part('year', o.order_date) = 1997
group by p.product_name, od.quantity, o.order_id
order by p.product_name;
--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, (e.first_name || ' ' || e.last_name) as çalışanım, od.quantity, o.order_date from order_details od
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where date_part('year', o.order_date) = 1997 and od.quantity = (select max(od.quantity) from order_details od)
group by e.employee_id, od.quantity, o.order_date, çalışanım;
--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, (e.first_name || ' ' || e.last_name) as çalışanım, od.quantity, o.order_date from order_details od
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where date_part('year', o.order_date) = 1997 and od.quantity = (select max(od.quantity) from order_details od)
group by e.employee_id, od.quantity, o.order_date, çalışanım;
--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on c.category_id = p.category_id
where p.unit_price = (select max(unit_price) from products);
--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, 
--sipariş ID. Sıralama sipariş tarihine göre
select (e.first_name || ' ' || e.last_name) as personel_adi, o.order_date, o.order_id from orders o
inner join employees e on e.employee_id = o.employee_id
order by o.order_date;
--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select o.order_id, avg(od.quantity * od.unit_price) as ortalama_fiyat from order_details od
inner join orders o on o.order_id = od.order_id
group by o.order_id
order by o.order_id desc limit 5;
--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity*od.unit_price) as "toplam satış miktarı", o.order_date
from products p
inner join categories c on c.category_id = p.category_id
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where date_part('month', o.order_date) =1
group by p.product_name, c.category_name, o.order_date
order by o.order_date;
--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select p.product_name, od.quantity from products p
inner join order_details od on p.product_id = od.product_id
where od.quantity > (select avg(od.quantity) from order_details od) --23.8...
group by p.product_name, od.quantity
order by od.quantity;
--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name, s.contact_name from products p join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id 
where p.product_id = (select od.product_id as sales_count from order_details od
group by od.product_id order by sales_count desc limit 1);
--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS customer_count
FROM customers;
--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id as "3 idli çalışan", sum(od.quantity*od.unit_price) from order_details od
inner join products p on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id = 3 and date_part('year', order_date) = (select max(date_part('year', order_date)) from orders)
group by e.employee_id;
--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE od.order_id = 10248;
--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.contact_name
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE od.order_id = 10248;
--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, od.quantity
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
  AND EXTRACT(YEAR FROM o.order_date) = 1997;
--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name from orders o 
join employees e on o.employee_id = e.employee_id
where o.order_id =
(select o.order_id from orders o join order_details od on o.order_id = od.order_id
join employees e on e.employee_id = o.employee_id
where EXTRACT(YEAR from o.order_date ) = 1997
group by o.order_id
order by sum(quantity*unit_price) desc 
limit 1);
--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.employee_id = (
  SELECT o.employee_id
  FROM orders o
  JOIN order_details od ON o.order_id = od.order_id
  WHERE EXTRACT(YEAR FROM o.order_date) = 1997
  GROUP BY o.employee_id
  ORDER BY SUM(od.quantity * od.unit_price) DESC
  LIMIT 1
);
--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;
--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name, o.order_date, o.order_id
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
ORDER BY o.order_date;
--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, AVG(od.unit_price * od.quantity) AS average_price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;
--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS total_sales
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
GROUP BY p.product_name, c.category_name;
--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT o.order_id, od.unit_price * od.quantity AS total_sales
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
WHERE od.unit_price * od.quantity > (
  SELECT AVG(od2.unit_price * od2.quantity) 
  FROM order_details od2
);
--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, s.contact_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name, c.category_name, s.contact_name
ORDER BY SUM(od.quantity) DESC
LIMIT 1;
--62. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS customer_count
FROM customers;
--63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC;
--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id as "3 idli çalışan", sum(od.quantity*od.unit_price) from order_details od
inner join products p on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id = 3 and date_part('year', order_date) = (select max(date_part('year', order_date)) from orders)
group by e.employee_id;
--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.unit_price * od.quantity) AS total_revenue, o.order_date
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
WHERE od.product_id = 10 and o.order_date >= (select max(order_date) - INTERVAL '3 months' from orders)
group by o.order_date;
--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id, e.first_name ||' '|| e.last_name, count(o.order_id)  from orders o join employees e on e.employee_id = o.employee_id
join order_details od on od.order_id = o.order_id
group by o.employee_id, e.employee_id;
--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.customer_id, c.contact_name from orders o right join customers c on c.customer_id = o.customer_id where order_id is null;
--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select c.company_name,c.contact_name,c.city,c.country,c.address  from customers c where c.country = 'Brazil';
--69. Brezilya’da olmayan müşteriler
SELECT *
FROM customers
WHERE country != 'Brazil';
--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');
--71. Faks numarasını bilmediğim müşteriler
SELECT *
FROM customers
WHERE fax IS NULL;
--72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT *
FROM customers
WHERE city IN ('London', 'Paris');
--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT *
FROM customers
WHERE city LIKE 'México D.F.' and contact_title ilike 'owner';
--74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price
FROM products
WHERE lower(product_name) LIKE 'c%';
--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name, last_name, birth_date
FROM employees
WHERE upper(first_name) LIKE 'A%';
--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name
FROM customers
WHERE upper(company_name) LIKE '%RESTAURANT%';
--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 100;
--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';
--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');
--80. Faks numarasını bilmediğim müşteriler
SELECT *
FROM customers
WHERE fax IS NULL;
--81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT *
FROM customers
ORDER BY country;
--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC;
--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC, units_in_stock;
--84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS product_count
FROM products
WHERE category_id = 1;
--85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT country) AS country_count
FROM customers;
/***********************************************************************************************************/

--EXISTS - NOT EXISTS => Mevcut mu ?
--Herhangi bir kaydın varlığını kontrol ediyoruz

Select company_name from suppliers s
where exists (Select product_name from products p
             where p.supplier_id = s.supplier_id
             AND unit_price <20);

Select company_name from suppliers s
where not exists (Select product_name from products p
             where p.supplier_id = s.supplier_id
             AND unit_price = 20);

--İki tarih arasında sipariş almış olan çalışanlar
Select * from employees e
where exists (Select * from orders o
             where e.employee_id = o.employee_id
             AND o.order_date Between '3/5/1998' AND '4/5/1998');


--ALL 
--Mantıksal operator
--Tüm alt sorgudaki değerleri koşulu sağlıyorsa eğer bizim true => verilere ulaşabiliyoruz 
--AND 
Select * from products
where product_id = ALL(Select distinct product_id from order_details
                      where quantity =10);

--ANY
--Alt sorgu değerlerinden herhangi biri koşulu sağlıyorsa bizim için true 
--OR
Select * from products
where product_id = ANY(Select product_id from order_details
                      where quantity >99);
				
--*****************************************************************
--86. Kaç farklı ülkeye ihracat yapıyorum? a.Bu ülkeler hangileri..?
select distinct ship_country from orders;
SELECT DISTINCT country AS country_count
FROM customers;
--87. En Pahalı 5 ürün
select unit_price from products order by unit_price desc limit 5;
--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select count(*) from customers c
inner join orders o on c.customer_id = o.customer_id 
where c.customer_id = 'ALFKI';
--89. Ürünlerimin toplam maliyeti
select sum(unit_price*units_in_stock) from products;
--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM(od.unit_price * od.quantity) AS total_revenue, o.order_date
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
group by o.order_date;
--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products;
--92. En Pahalı Ürünün Adı
select product_name from products order by unit_price desc limit 1;
--93. En az kazandıran sipariş
SELECT (od.unit_price * od.quantity) AS revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
group by revenue
order by revenue limit 1; 
--94. Müşterilerimin içinde en uzun isimli müşteri
select contact_name, length(contact_name) as "isim uzunluğu" 
from customers order by "isim uzunluğu" desc limit 1;

select contact_name, length(contact_name)  from customers
where length(contact_name) = (select max(length(contact_name)) from customers);
--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name, last_name, (date_part('year', current_date) - date_part('year', birth_date)) Age from employees;
--96. Hangi üründen toplam kaç adet alınmış..?
select p.product_name, od.quantity from products p
inner join order_details od on p.product_id = od.product_id
group by p.product_name, od.quantity;
--97. Hangi siparişte toplam ne kadar kazanmışım..?
SELECT od.order_id, (od.unit_price * od.quantity) AS revenue FROM order_details od
JOIN orders o ON od.order_id = o.order_id
group by od.order_id, revenue
order by revenue;
--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_name, count(*) from products p
inner join categories c on c.category_id = p.category_id
group by c.category_name;
--99. 1000 Adetten fazla satılan ürünler?
select p.product_name, od.quantity from orders o 
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
where od.quantity > 1000
group by p.product_name, od.quantity;
-- 100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.customer_id, c.contact_name, o.customer_id from customers c
left join orders o on o.customer_id = c.customer_id
where o.customer_id is null;
-- 101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.contact_name, p.product_name from suppliers s
inner join products p on p.supplier_id = s.supplier_id
group by s.contact_name, p.product_name;
--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id, s.company_name, o.order_date from orders o
inner join shippers s on s.shipper_id = o.ship_via;
--103. Hangi siparişi hangi müşteri verir..?
select o.order_id, c.contact_name from orders o
inner join customers c on c.customer_id = o.customer_id;
--104. Hangi çalışan, toplam kaç sipariş almış..?
select e.employee_id, count(o.*) from orders o
inner join employees e on e.employee_id = o.employee_id
group by e.employee_id;
-- 105. En fazla siparişi kim almış..?
select c.contact_name, max(od.quantity) from customers c
inner join orders o on o.customer_id = c.customer_id
inner join order_details od on od.order_id = o.order_id
group by c.contact_name
order by  max(od.quantity) desc limit 1;
-- 106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id, e.first_name || ' ' || e.last_name as "Worker", c.contact_name from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on e.employee_id = o.employee_id
group by o.order_id, e.first_name, e.last_name, c.contact_name;
-- 107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_name, c.category_name, s.contact_name as "suppliers" from products p 
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id
group by p.product_name, c.category_name, s.contact_name;
--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id, c.contact_name, e.employee_id, o.order_date, s.company_name, p.product_name, od.quantity, od.unit_price, cat.category_name, sup.supplier_id 
from orders o 
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
inner join categories cat on cat.category_id = p.category_id
inner join customers c on c.customer_id = o.customer_id
inner join suppliers sup on sup.supplier_id = p.supplier_id
inner join shippers s on s.shipper_id = o.ship_via
inner join employees e on e.employee_id = o.employee_id;
--109. Altında ürün bulunmayan kategoriler
Select * from categories 
where not exists (Select category_id from products ); 
--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select * from customers
where contact_title like '%Manager%';
--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select * from customers
where customer_id like 'FR___'; 
--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select * from customers
where phone like '(171)%'; 
--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select * from products
where quantity_per_unit like '%boxes%';
--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name, phone from customers
where contact_title like '%Manager%' and country in ('France', 'Germany');
--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select * from products 
order by unit_price desc limit 10;
--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select * from customers
order by country, city;
--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name, last_name, (date_part('year', current_date) - date_part('year', birth_date)) Age from employees;
--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select * from orders
where (order_date + 35) < shipped_date;
--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name from categories
where category_id = (select category_id from products order by unit_price desc limit 1);
--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select product_name from products
where category_id in (select category_id from categories where category_name like '%on%');
--121. Konbu adlı üründen kaç adet satılmıştır.
select sum(quantity) from order_details
where product_id = (select product_id from products where product_name = 'Konbu');
--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select product_name from products where supplier_id in (select supplier_id from suppliers where country = 'Japan');
--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight), min(freight), avg(freight) from orders where date_part('year', order_date) = 1997;
--124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers where fax is not null;
--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select * from orders where order_date between '1996-07-16' and '1996-07-30'
