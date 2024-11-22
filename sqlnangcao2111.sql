-- EX2

ALTER TABLE products  
ADD CONSTRAINT fk_category  
FOREIGN KEY (categoryId) REFERENCES categories(categoryId);  

ALTER TABLE products  
ADD CONSTRAINT fk_store  
FOREIGN KEY (storeId) REFERENCES stores(storeId);  

ALTER TABLE order_details  
ADD CONSTRAINT fk_order  
FOREIGN KEY (orderId) REFERENCES orders(orderId);  

ALTER TABLE order_details  
ADD CONSTRAINT fk_product_order  
FOREIGN KEY (productId) REFERENCES products(productId);  

ALTER TABLE orders  
ADD CONSTRAINT fk_user  
FOREIGN KEY (userId) REFERENCES users(userId);  

ALTER TABLE carts  
ADD CONSTRAINT fk_user_cart  
FOREIGN KEY (userId) REFERENCES users(userId);  

ALTER TABLE carts  
ADD CONSTRAINT fk_product_cart  
FOREIGN KEY (productId) REFERENCES products(productId);  

ALTER TABLE reviews  
ADD CONSTRAINT fk_user_review  
FOREIGN KEY (userId) REFERENCES users(userId);  

ALTER TABLE reviews  
ADD CONSTRAINT fk_product_review  
FOREIGN KEY (productId) REFERENCES products(productId);  

ALTER TABLE images  
ADD CONSTRAINT fk_product_image  
FOREIGN KEY (productId) REFERENCES products(productId);

-- EX3
-- hiển thị tất cả thông tin bảng products
SELECT * FROM products;

-- Tìm tất cả các đơn hàng (orders) có tổng giá trị (totalPrice) lớn hơn 500,000.
SELECt * from `orders` 
WHERE `totalPrice` > 500000;

-- liệt kê tên và địa chỉ các cửa hàng 
SELECT s.storename AS 'cửa hàng', s.addressStore AS 'địa chỉ' FROM stores AS s;

-- Tìm tất cả người dùng (users) có địa chỉ email kết thúc bằng '@gmail.com'.
SELECT * FROM users  
WHERE email LIKE '%@gmail.com';

-- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5.
SELECT * FROM `reviews`
WHERE rate = 5;

-- Liệt kê tất cả các sản phẩm có số lượng (quantity) dưới 10.
SELECT productName AS 'tên sản phẩm' FROM `products`
WHERE quantity < 10; 

-- Tìm tất cả các sản phẩm thuộc danh mục categoryId = 1.
SELECT * FROM products  
WHERE categoryId = 1;

-- Đếm số lượng người dùng (users) có trong hệ thống.
SELECT COUNT(userId) as 'Số lượng người dùng' from users;

-- Tính tổng giá trị của tất cả các đơn hàng (orders).
SELECT SUM(totalPrice) AS 'tổng giá trị' FROM orders;

-- Tìm sản phẩm có giá cao nhất (price).
SELECT productName as 'sản phẩm có giá cao nhất' FROM products
WHERE price = (
	SELECT MAX(price) FROM products
);

-- Liệt kê tất cả các cửa hàng đang hoạt động (statusStore = 1).
SELECT storeName As 'cửa hàng đang hoạt động' FROM stores
WHERE statusstore = 1;

-- Đếm số lượng sản phẩm theo từng danh mục (categories).
SELECT c.categoryName AS 'danh mục', COUNT(p.productId) AS 'số lượng sản phẩm'  
FROM categories AS c  
LEFT JOIN products AS p ON c.categoryId = p.categoryId  
GROUP BY c.categoryId, c.categoryName;

-- Tìm tất cả các sản phẩm mà chưa từng có đánh giá.
SELECT p.productName AS 'sản phẩm chưa từng có đánh giá'
FROM products p  
LEFT JOIN reviews r ON p.productId = r.productId  
LEFT JOIN order_details od ON p.productId = od.productId  
WHERE r.reviewId IS NULL  
GROUP BY p.productId;

-- Hiển thị tổng số lượng hàng đã bán (quantityOrder) của từng sản phẩm.
SELECT p.productId, p.productName, SUM(od.quantityOrder) AS 'tổng số lượng hàng đã bán'
FROM products p  
LEFT JOIN order_details od ON p.productId = od.productId  
GROUP BY p.productId, p.productName;

-- Tìm các người dùng (users) chưa đặt bất kỳ đơn hàng nào.
SELECT u.userName AS 'tên người dùng chưa đặt bất kí đơn hàng nào' 
FROM users u  
LEFT JOIN orders o ON u.userId = o.userId  
WHERE o.orderId IS NULL;

-- Hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng.
SELECT s.storeName as 'tên cửa hàng', COUNT(o.orderId) as 'tổng số đơn hàng được thực hiện'  
FROM stores s  
LEFT JOIN orders o on s.storeId = o.storeId  
GROUP BY s.storeId;

-- Hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan.
SELECT p.productId, p.productName, COUNT(i.imageId) AS 'số lượng hình ảnh liên quan'  
FROM products p  
LEFT JOIN images i ON p.productId = i.productId  
GROUP BY p.productId;

-- Hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình.
SELECT p.productId, p.productName, COUNT(r.reviewId) AS reviewCount, AVG(r.rate) AS 'đánh giá trung bình'  
FROM products p  
LEFT JOIN reviews r ON p.productId = r.productId  
GROUP BY p.productId;

-- Tìm người dùng có số lượng đánh giá nhiều nhất.
SELECT u.*, COUNT(r.reviewId) AS 'số lượng đánh giá'  
FROM users u  
JOIN reviews r ON u.userId = r.userId  
GROUP BY u.userId  
ORDER BY 'số lượng đánh giá'  DESC  
LIMIT 1; 

-- Hiển thị top 3 sản phẩm bán chạy nhất (dựa trên số lượng đã bán).
SELECT p.productId, p.productName as 'tên sp', SUM(od.quantityOrder) AS 'sl đã bán' 
FROM products p  
JOIN order_details od ON p.productId = od.productId  
GROUP BY p.productId  
ORDER BY 'sl đã bán' DESC  
LIMIT 3;  

-- Tìm sản phẩm bán chạy nhất tại cửa hàng có storeId = 'S001'.
SELECT p.productId, p.productName, SUM(od.quantityOrder) AS 'sl đã bán' 
FROM products p  
JOIN order_details od ON p.productId = od.productId  
JOIN orders o ON od.orderId = o.orderId  
WHERE o.storeId = 'S001'  
GROUP BY p.productId  
ORDER BY 'sl đã bán' DESC  
LIMIT 1; 

-- Hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng).
SELECT p.productName as 'sản phẩm' FROM products p  
WHERE p.price * p.quantity > 1000000;

-- Tìm cửa hàng có tổng doanh thu cao nhất.
SELECT o.orderId, SUM(od.priceOrder * od.quantityOrder) AS 'tổng doanh thu'
FROM orders o  
JOIN order_details od ON o.orderId = od.orderId  
GROUP BY o.orderId  
ORDER BY 'tổng doanh thu' DESC  
LIMIT 1;  

-- Hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu.
SELECT u.userId, u.userName as 'tên người dùng', SUM(od.priceOrder * od.quantityOrder) AS 'tổng tiền chi tiêu'  
FROM users u  
JOIN orders o ON u.userId = o.userId  
JOIN order_details od ON o.orderId = od.orderId  
GROUP BY u.userId;  

-- Tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết.
SELECT DISTINCT od.* 
FROM orders od 
RIGHT JOIN order_details o ON od.orderId = o.orderId 
WHERE o.priceOrder = (
SELECT MAX(priceOrder) FROM order_details
);

-- Tính số lượng sản phẩm trung bình được bán ra trong mỗi đơn hàng.
SELECT AVG(productCount) AS 'sl sản phẩm trung bình'  
FROM (  
    SELECT o.orderId, COUNT(od.productId) AS productCount  
    FROM orders o  
    JOIN order_details od ON o.orderId = od.orderId  
    GROUP BY o.orderId  
)as sp;  

-- Hiển thị tên sản phẩm và số lần sản phẩm đó được thêm vào giỏ hàng.
SELECT p.productName as 'tên sản phẩm', COUNT(c.cartId) AS 'số lần sp được thêm vào giỏ'
FROM products p  
LEFT JOIN carts c ON p.productId = c.productId  
GROUP BY p.productId;  

-- Tìm tất cả các sản phẩm đã bán nhưng không còn tồn kho trong kho hàng.
SELECT DISTINCT p.productName AS 'Tên sản phẩm'
FROM products p  
JOIN order_details od ON p.productId = od.productId  
WHERE p.quantity = 0; 

-- Tìm các đơn hàng được thực hiện bởi người dùng có email là duong@gmail.com'.
SELECT o.orderId, o.totalPrice  
FROM orders o  
JOIN users u ON o.userId = u.userId  
WHERE u.email = 'duong@gmail.com';  
-- Hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu.
SELECT s.storeName as 'tên cửa hàng', COUNT(p.productId) AS 'sl sản phẩm mà họ sở hữu' 
FROM stores s  
LEFT JOIN products p ON s.storeId = p.storeId  
GROUP BY s.storeId;
                                                                        
-- Exercise 04
-- Tạo view (Bảng ảo) để hiển thị dữ liệu theo các yêu cầu sau
-- View hiển thị tên sản phẩm (productName) và giá (price) từ bảng products với giá trị giá (price) lớn hơn 500,000 có tên là expensive_products
CREATE VIEW expensive_products AS  
SELECT productName, price  
FROM products  
WHERE price > 500000;  

-- Truy vấn dữ liệu từ view vừa tạo expensive_products
SELECT * FROM expensive_products;

-- Làm thế nào để cập nhật giá trị của view? Ví dụ, cập nhật giá (price) thành 600,000 cho sản phẩm có tên Product A trong view expensive_products.
UPDATE expensive_products
SET price = 600000
WHERE productName = 'Product A';

-- Làm thế nào để xóa view expensive_products?
DROP VIEW expensive_products;

--  Tạo một view hiển thị tên sản phẩm (productName), tên danh mục (categoryName) bằng cách kết hợp bảng products và categories.
CREATE VIEW ProductCategoryView AS  
SELECT p.productName, c.categoryName  
FROM products p  
INNER JOIN categories c ON p.categoryId = c.categoryId;


-- Exercise 05
-- Làm thế nào để tạo một index trên cột productName của bảng products?
CREATE INDEX idx_productName ON products (productName);

-- Hiển thị danh sách các index trong cơ sở dữ liệu?
SHOW INDEX FROM products;

-- Trình bày cách xóa index idx_productName đã tạo trước đó?
DROP INDEX idx_productName ON products;

-- Tạo một procedure tên getProductByPrice để lấy danh sách sản phẩm với giá lớn hơn một giá trị đầu vào (priceInput)?
DELIMITER $$
CREATE PROCEDURE getProductByPrice(IN priceInput DECIMAL(10,2))  
BEGIN  
SELECT * FROM products WHERE price > priceInput; 
END$$;
DELIMITER ;
-- Làm thế nào để gọi procedure getProductByPrice với đầu vào là 500000?
CALL getProductByPrice(500000);

-- Tạo một procedure getOrderDetails trả về thông tin chi tiết đơn hàng với đầu vào là orderId?
DELIMITER $$
CREATE PROCEDURE getOrderDetails(IN orderIdInput VARCHAR(255))  
BEGIN  
SELECT * FROM order_details WHERE orderId = orderIdInput;  
END$$;
DELIMITER ;

CALL getOrderDetails('562e0c48-b07b-4192-a623-0082e5e000f1');
-- Làm thế nào để xóa procedure getOrderDetails?
DROP PROCEDURE getOrderDetails;

-- Tạo một procedure tên addNewProduct để thêm mới một sản phẩm vào bảng products. Các tham số gồm productName, price, description, và quantity.
DELIMITER $$
CREATE PROCEDURE addNewProduct(
    IN productName VARCHAR(255),  
    IN price DECIMAL(10, 2),  
    IN description TEXT,  
    IN quantity INT  
)  
BEGIN  
    INSERT INTO products (productName, price, description, quantity) 
    VALUES (productName, price, description, quantity);  
END$$
DELIMITER ;

CALL addNewProduct('chuot khong day', 200, 'chuot khong day gia co', 10);

-- Tạo một procedure tên deleteProductById để xóa sản phẩm khỏi bảng products dựa trên tham số productId.
DELIMITER $$
CREATE PROCEDURE deleteProductById(IN productId INT  )  
BEGIN  
DELETE FROM products  
WHERE productId = productId;  
END$$;
DELIMITER ;

-- Tạo một procedure tên searchProductByName để tìm kiếm sản phẩm theo tên (tìm kiếm gần đúng) từ bảng products.
DELIMITER $$
CREATE PROCEDURE searchProductByName(IN searchTerm VARCHAR(255))  
BEGIN  
SELECT * FROM products  
WHERE productName LIKE CONCAT('%', searchTerm, '%');  
END$$;
DELIMITER ;

CALL searchProductByName('chuot');
-- Tạo một procedure tên filterProductsByPriceRange để lấy danh sách sản phẩm có giá trong khoảng từ minPrice đến maxPrice.
DELIMITER $$
CREATE PROCEDURE filterProductsByPriceRange(IN minPrice DECIMAL(10, 2), IN maxPrice DECIMAL(10, 2))  
BEGIN  
SELECT * FROM products  
WHERE price BETWEEN minPrice AND maxPrice;  
END$$;
DELIMITER ;

CALL filterProductsByPriceRange(10,120);
-- Tạo một procedure tên paginateProducts để phân trang danh sách sản phẩm, với hai tham số pageNumber và pageSize.
DELIMITER $$
CREATE PROCEDURE paginateProducts(
 IN pageSize INT,
 IN pageNumber INT
 )
BEGIN
	DECLARE offset_value INT;
    SET offset_value = pageSize*(pageNumber-1);
	SELECT * FROM products
	LIMIT pageSize
	OFFSET offset_value;
END $$
DELIMITER ;

CALL paginateProducts(2,1);

