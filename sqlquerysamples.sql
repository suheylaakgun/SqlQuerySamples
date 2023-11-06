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
