-- exciser 2
ALTER TABLE `building`
ADD CONSTRAINT `fk_host_id` 
FOREIGN KEY (`host_id`) REFERENCES `host`(`id`);
ALTER TABLE `building`
ADD CONSTRAINT `fk_contractor_id` 
FOREIGN KEY (`contractor_id`) REFERENCES `contractor`(`id`);
ALTER TABLE `work`
ADD CONSTRAINT `fk_building_id`
FOREIGN KEY (building_id) REFERENCES building(id);
ALTER TABLE `work`
ADD CONSTRAINT `fk_worker_id`
FOREIGN KEY (worker_id) REFERENCES worker(id);
ALTER TABLE design
ADD CONSTRAINT `fk_buildingd_id`
FOREIGN KEY(building_id) REFERENCES  building(id);
ALTER TABLE design
ADD CONSTRAINT `fk_architect_id`
FOREIGN KEY(architect_id) REFERENCES  architect(id);
-- exciser 3
-- Hiển thị thông tin công trình có chi phí cao nhất
SELECT * FROM building  
WHERE cost = (SELECT MAX(cost) FROM building);
-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT * FROM building  
WHERE cost > ALL (SELECT cost FROM building WHERE city = 'can tho');
--  Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ
SELECT * FROM building  
WHERE cost > ANY (SELECT cost FROM building WHERE city = 'can tho');
-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT * FROM building  
WHERE id NOT IN (SELECT building_id FROM design);
-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp
SELECT * FROM architect
WHERE (birthday,place) IN (
SELECT birthday,place FROM architect
GROUP BY birthday,place
HAVING count(*)>1
);
-- exciser 4
-- Hiển thị thù lao trung bình của từng kiến trúc sư
SELECT architect_id, AVG(benefit) AS 'thù lao trubg bình' FROM design  
GROUP BY architect_id;

-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố
SELECT city, SUM(cost) AS 'chi phí đầu tư' FROM building  
GROUP BY city;

-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
SELECT b.* FROM building b  
INNER JOIN design d ON b.id = d.building_id  
WHERE d.benefit > 50;

-- Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp
SELECT DISTINCT b.city  
FROM building b  
JOIN design d ON b.id = d.building_id  
JOIN architect a ON d.architect_id = a.id  
WHERE a.place IS NOT NULL;

-- Hiển thị tên công trình, tên chủ nhân và tên chủ thầu của công trình đó
SELECT b.name AS 'tên công trình', h.name AS 'chủ nhân', c.name AS 'tên chủ thầu'  
FROM building b  
INNER JOIN host h ON b.host_id = h.id  
INNER JOIN contractor c ON b.contractor_id = c.id;
-- Hiển thị tên công trình (building), tên kiến trúc sư (architect) và thù lao của kiến trúc sư ở mỗi công trình (design)
SELECT b.name AS 'tên công trình', a.name AS 'kiên trúc sư', d.benefit AS 'thù lao'
FROM building b  
INNER JOIN design d ON b.id = d.building_id  
INNER JOIN architect a ON d.architect_id = a.id;
-- Hãy cho biết tên và địa chỉ công trình (building) do chủ thầu Công ty xây dựng số 6 thi công (contractor)
SELECT b.name AS 'tên công trình', b.address AS 'địa chỉ'
FROM building b  
WHERE b.contractor_id = (SELECT id FROM contractor WHERE name = 'cty xd so 6');
-- Tìm tên và địa chỉ liên lạc của các chủ thầu (contractor) thi công công trình ở Cần Thơ (building) do kiến trúc sư Lê Kim Dung thiết kế (architect, design)
SELECT DISTINCT c.name AS 'tên chủ thầu', c.address 'địa chỉ liên lạc' 
FROM building b  
INNER JOIN design d ON b.id = d.building_id  
INNER JOIN contractor c ON b.contractor_id = c.id  
INNER JOIN architect a ON d.architect_id = a.id  
WHERE b.city = 'can tho' AND a.name = 'le kim dung';
-- Hãy cho biết nơi tốt nghiệp của các kiến trúc sư (architect) đã thiết kế (design) công trình Khách Sạn Quốc Tế ở Cần Thơ (building)
SELECT DISTINCT a.place  
FROM architect a  
INNER JOIN design d ON a.id = d.architect_id  
INNER JOIN building b ON d.building_id = b.id  
WHERE b.name = 'Kkhach san quoc te' AND b.city = 'can tho';
-- Cho biết họ tên, năm sinh, năm vào nghề của các công nhân có chuyên môn hàn hoặc điện (worker) đã tham gia các công trình (work) mà chủ thầu Lê Văn Sơn (contractor) đã trúng thầu (building)
SELECT wr.name AS 'họ tên', wr.birthday AS 'năm sinh' , wr.year AS 'năm vào nghề' From worker AS wr
INNER JOIN work as w ON wr.id=w.worker_id
INNER JOIN building as b ON b.id =w.building_id
WHERE wr.skill IN ('han','dien');
-- Những công nhân nào (worker) đã bắt đầu tham gia công trình Khách sạn Quốc Tế ở Cần Thơ (building) trong giai đoạn từ ngày 15/12/1994 đến 31/12/1994 (work) số ngày tương ứng là bao nhiêu
SELECT wr.name AS 'tên công nhân', b.name AS 'tên công trình', w.date AS 'Ngayd tham gia' From worker AS wr
INNER JOIN work as w ON wr.id=w.worker_id
INNER JOIN building as b ON b.id =w.building_id
WHERE b.name LIKE 'khach san quoc te' AND w.date BETWEEN '19941215' AND '19941231';
-- Cho biết họ tên và năm sinh của các kiến trúc sư đã tốt nghiệp ở TP Hồ Chí Minh (architect) và đã thiết kế ít nhất một công trình (design) có kinh phí đầu tư trên 400 triệu đồng (building)
SELECT DISTINCT a.name AS 'họ tên', a.birthday AS 'năm sinh' 
FROM architect a  
INNER JOIN design d ON a.id = d.architect_id  
INNER JOIN building b ON d.building_id = b.id  
WHERE a.place = 'tp hcm' AND b.cost > 400;
-- Cho biết tên công trình có kinh phí cao nhất
SELECT name 
FROM building 
WHERE cost = (
	SELECT MAX(cost) FROM building
);
-- Cho biết tên các kiến trúc sư (architect) vừa thiết kế các công trình (design) do Phòng dịch vụ sở xây dựng (contractor) thi công vừa thiết kế các công trình do chủ thầu Lê Văn Sơn thi công
SELECT a.name AS 'tên kiến trúc sư' , c.name AS 'thầu' From architect as a
INNER JOIN design as d ON d.architect_id=a.id
INNER JOIN building AS b ON b.id =d.building_id
INNER JOIN contractor AS c ON c.id=b.contractor_id
WHERE c.name IN ('phong dich vu so xd','le van son');

-- Cho biết họ tên các công nhân (worker) có tham gia (work) các công trình ở Cần Thơ (building) nhưng không có tham gia công trình ở Vĩnh Long
SELECT wr.name AS 'tên công nhân', b.name AS 'tên công trình' , b.city AS 'Thành Phố' From worker AS wr
INNER JOIN work as w ON wr.id=w.worker_id
INNER JOIN building as b ON b.id =w.building_id
WHERE  wr.name NOT IN(
	SELECT wr.name From building AS b 
    INNER JOIN work as w ON b.id=w.building_id 
    INNER JOIN worker as wr ON wr.id= w.worker_id
    WHERE b.city ='vinh long') AND b.city ='can tho';
-- Cho biết tên của các chủ thầu đã thi công các công trình có kinh phí lớn hơn tất cả các công trình do chủ thầu phòng Dịch vụ Sở xây dựng thi công
SELECT DISTINCT c.name AS 'tên chủ thầu'
FROM contractor c  
INNER JOIN building b ON c.id = b.contractor_id  
WHERE b.cost > ALL (SELECT cost FROM building WHERE contractor_id = (SELECT id FROM contractor WHERE name = 'phong dich vu so xd'));
-- Cho biết họ tên các kiến trúc sư có thù lao thiết kế một công trình nào đó dưới giá trị trung bình thù lao thiết kế cho một công trình
SELECT DISTINCT a.name AS 'họ tên kiến trúc sư'
FROM architect a  
INNER JOIN design d ON a.id = d.architect_id  
WHERE d.benefit < (SELECT AVG(benefit) FROM design);
-- Tìm tên và địa chỉ những chủ thầu đã trúng thầu công trình có kinh phí thấp nhất
SELECT c.name AS 'tên', b.address AS 'địa chỉ'  
FROM contractor c  
INNER JOIN building b ON c.id = b.contractor_id  
WHERE b.cost = (SELECT MIN(cost) FROM building);
-- Tìm họ tên và chuyên môn của các công nhân (worker) tham gia (work) các công trình do kiến trúc sư Le Thanh Tung thiet ke (architect) (design)
SELECT wr.name AS 'họ tên', wr.skill AS 'chuyên môn' FROM worker AS wr
INNER JOIN work AS w ON w.worker_id =wr.id
INNER JOIN building AS b ON b.id=w.building_id
INNER JOIN design AS d ON d.building_id=b.id
INNER JOIN architect AS a ON a.id=d.architect_id
WHERE a.name='le thanh tung';
-- Tìm các cặp tên của chủ thầu có trúng thầu các công trình tại cùng một thành phố
SELECT DISTINCT c.name, contractor_id, b.city AS 'thành phố'
FROM building b
INNER JOIN (SELECT city, count(DISTINCT contractor_id) count FROM building GROUP BY city HAVING count > 1) m
ON b.city = m.city
INNER JOIN contractor c ON b.contractor_id = c.id;
-- Tìm tổng kinh phí của tất cả các công trình theo từng chủ thầu
SELECT SUM(cost) AS 'tổng kinh phí' ,b.host_id AS 'công trình'
FROM building AS b
GROUP BY host_id;
-- Cho biết họ tên các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT a.name AS 'tên kiến trúc sư',SUM(d.benefit) AS 'tổng thù lao'
FROM design AS d
INNER JOIN architect as a ON a.id=d.architect_id
GROUP BY architect_id
HAVING SUM(d.benefit)>25;
-- Cho biết số lượng các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT COUNT(DISTINCT a.id) AS 'số kiến trúc sư'  
FROM architect a  
INNER JOIN design d ON a.id = d.architect_id  
GROUP BY a.id  
HAVING SUM(d.benefit) > 25;

-- Tìm tổng số công nhân đã than gia ở mỗi công trình
SELECT b.name AS 'Tên công trình', COUNT(wr.worker_id) AS 'tổng số công nhân'  
FROM building b  
LEFT JOIN work wr ON b.id = wr.building_id  
GROUP BY b.id;
-- Tìm tên và địa chỉ công trình có tổng số công nhân tham gia nhiều nhất
SELECT b.name AS 'tên công trình', b.address AS 'địa chỉ công trình'  
FROM building b  
INNER JOIN work wr ON b.id = wr.building_id  
GROUP BY b.id  
ORDER BY COUNT(wr.worker_id) DESC  
LIMIT 1;
-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình của từng thành phố tương ứng
SELECT b.city AS 'thành phố', AVG(b.cost) AS 'kinh phí trung bình'  
FROM building b  
GROUP BY b.city;
-- Cho biết họ tên các công nhân có tổng số ngày tham gia vào các công trình lớn hơn tổng số ngày tham gia của công nhân Nguyễn Hồng Vân
SELECT w.name AS 'tenn công nhân'FROM worker AS w
INNER JOIN work AS wk ON w.id = wk.worker_id
GROUP BY w.name
HAVING SUM(wk.total) > (
    SELECT SUM(wk.total)
    FROM worker AS w
    INNER JOIN work AS wk ON w.id = wk.worker_id
    WHERE w.name = 'nguyen hong van'
);
-- Cho biết tổng số công trình mà mỗi chủ thầu đã thi công tại mỗi thành phố
SELECT c.name 'chủ thầu', b.city AS 'thành phố', COUNT(b.id) AS 'tổng số công trình'
FROM contractor AS c
INNER JOIN building AS b ON c.id = b.contractor_id
GROUP BY c.name, b.city;

-- Cho biết họ tên công nhân có tham gia ở tất cả các công trình
SELECT w.name AS 'tên công nhân' FROM worker AS w
INNER JOIN work AS wk ON w.id = wk.worker_id
GROUP BY w.id, w.name
HAVING COUNT(DISTINCT wk.building_id) = (
    SELECT COUNT(DISTINCT b.id) FROM building AS b
);
-- Exercise 06:
-- tạo bảng 
-- bảng nhân viên
CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY,
    TenNV VARCHAR(100),
    Tuoi INT,
    MucLuong DECIMAL(10, 2)
);
-- bảng bộ phận
CREATE TABLE BoPhan (
    MaBP INT PRIMARY KEY,
    TenBP VARCHAR(100) UNIQUE
);
-- bảng quan hệ
CREATE TABLE NhanVien_BoPhan (
    MaNV INT,
    MaBP INT,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaBP) REFERENCES BoPhan(MaBP),
    PRIMARY KEY (MaNV, MaBP)
);
-- thêm data 
INSERT INTO NhanVien (MaNV, TenNV, Tuoi, MucLuong) VALUES
(1, 'Lê Huy Sơn', 30, 60000),
(2, 'Trần Thị Nụ', 27, 45000),
(3, 'Bùi Xuân Huấn', 35, 52000),
(4, 'Nguyễn Nguyễn Nguyễn', 40, 75000),
(5, 'Võ Tắc Thiên', 28, 30000);

INSERT INTO BoPhan (MaBP, TenBP) VALUES
(1, 'Kế toán'),
(2, 'Nhân sự'),
(3, 'Kỹ thuật'),
(4, 'Marketing'),
(5, 'Bán hàng');

bophanINSERT INTO NhanVien_BoPhan (MaNV, MaBP) VALUES
(1, 1), 
(1, 2),
(2, 2),
(3, 3),
(3, 4),
(4, 1),
(5, 5);
-- Viết câu lệnh SQL để liệt kê tất cả các nhân viên trong bộ phận có tên là "Kế toán". Kết quả cần hiển thị mã nhân viên và tên nhân viên.
SELECT NV.MaNV, NV.TenNV FROM NhanVien NV
INNER JOIN NhanVien_BoPhan NVP ON NV.MaNV = NVP.MaNV
INNER JOIN BoPhan BP ON NVP.MaBP = BP.MaBP
WHERE BP.TenBP = 'Kế toán';

-- Viết câu lệnh SQL để tìm các nhân viên có mức lương lớn hơn 50,000. Kết quả trả về cần bao gồm mã nhân viên, tên nhân viên và mức lương.
SELECT MaNV, TenNV, MucLuong
FROM NhanVien
WHERE MucLuong > 50000;

-- Viết câu lệnh SQL để hiển thị tất cả các bộ phận và số lượng nhân viên trong từng bộ phận. Kết quả trả về cần bao gồm tên bộ phận và số lượng nhân viên.
SELECT BP.TenBP AS 'tên bộ phận', COUNT(NVP.MaNV) AS 'số lượng nhân viên'
FROM BoPhan BP
LEFT JOIN NhanVien_BoPhan NVP ON BP.MaBP = NVP.MaBP
GROUP BY BP.TenBP;

-- Viết câu lệnh SQL để tìm ra các thành viên có mức lương cao nhất theo từng bộ phận. Kết quả trả về là một danh sách theo bất cứ thứ tự nào. Nếu có nhiều nhân viên bằng lương nhau nhưng cũng là mức lương cao nhất thì hiển thị tất cả những nhân viên đó ra.
SELECT NV.MaNV AS 'mã nhân viên', NV.TenNV AS 'tên nhân viên', BP.TenBP AS 'tên bộ phận', NV.MucLuong AS 'lương'
FROM NhanVien NV
INNER JOIN NhanVien_BoPhan NVP ON NV.MaNV = NVP.MaNV
INNER JOIN BoPhan BP ON NVP.MaBP = BP.MaBP
INNER JOIN (
    -- Truy vấn con để tìm mức lương cao nhất cho từng bộ phận
    SELECT NVP.MaBP, MAX(NV.MucLuong) AS MaxLuong
    FROM NhanVien NV
    INNER JOIN NhanVien_BoPhan NVP ON NV.MaNV = NVP.MaNV
    GROUP BY NVP.MaBP
) AS MaxLuongBoPhan ON NVP.MaBP = MaxLuongBoPhan.MaBP AND NV.MucLuong = MaxLuongBoPhan.MaxLuong;


-- Viết câu lệnh SQL để tìm các bộ phận có tổng mức lương của nhân viên vượt quá 100,000 (hoặc một mức tùy chọn khác). Kết quả trả về bao gồm tên bộ phận và tổng mức lương của bộ phận đó.
SELECT BP.TenBP AS 'tên bộ phận', SUM(NV.MucLuong) AS 'tổng lương'
FROM NhanVien NV
INNER JOIN NhanVien_BoPhan NVP ON NV.MaNV = NVP.MaNV
INNER JOIN BoPhan BP ON NVP.MaBP = BP.MaBP
GROUP BY BP.TenBP
HAVING SUM(NV.MucLuong) > 100000;

-- Viết câu lệnh SQL để liệt kê tất cả các nhân viên làm việc trong hơn 2 bộ phận khác nhau. Kết quả cần hiển thị mã nhân viên, tên nhân viên và số lượng bộ phận mà họ tham gia.
SELECT NV.MaNV AS 'mã nhân viên', NV.TenNV AS 'tên nhân viên', COUNT(NVP.MaBP) AS 'số lượng bộ phận'
FROM NhanVien NV
INNER JOIN NhanVien_BoPhan NVP ON NV.MaNV = NVP.MaNV
GROUP BY NV.MaNV, NV.TenNV
HAVING COUNT(NVP.MaBP) > 2;













