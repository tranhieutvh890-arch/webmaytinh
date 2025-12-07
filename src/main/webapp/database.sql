/*
SQLyog Community v13.1.9 (64 bit)
MySQL - 9.5.0 : Database - laptop4study
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`laptop4study` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `laptop4study`;

/*Table structure for table `anhsanpham` */

DROP TABLE IF EXISTS `anhsanpham`;

CREATE TABLE `anhsanpham` (
  `MaAnh` int NOT NULL AUTO_INCREMENT,
  `MaSanPham` int NOT NULL,
  `DuongDanAnh` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LaAnhChinh` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MaAnh`),
  KEY `FK_AnhSanPham` (`MaSanPham`),
  CONSTRAINT `FK_AnhSanPham` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `anhsanpham` */

/*Table structure for table `danhmuc` */

DROP TABLE IF EXISTS `danhmuc`;

CREATE TABLE `danhmuc` (
  `MaDanhMuc` int NOT NULL AUTO_INCREMENT,
  `TenDanhMuc` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DuongDan` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MaDanhMucCha` int DEFAULT NULL,
  PRIMARY KEY (`MaDanhMuc`),
  KEY `FK_DanhMuc_Cha` (`MaDanhMucCha`),
  CONSTRAINT `FK_DanhMuc_Cha` FOREIGN KEY (`MaDanhMucCha`) REFERENCES `danhmuc` (`MaDanhMuc`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `danhmuc` */

insert  into `danhmuc`(`MaDanhMuc`,`TenDanhMuc`,`DuongDan`,`MaDanhMucCha`) values 
(1,'Laptop','laptop',NULL),
(2,'May tinh ban','pc',NULL),
(3,'Tablet','tablet',NULL),
(4,'Linh kien','linhkien',NULL),
(5,'Man hinh','manhinh',NULL),
(6,'May cu','maycu',NULL),
(7,'Phu kien','phukien',NULL);

/*Table structure for table `dichvu` */

DROP TABLE IF EXISTS `dichvu`;

CREATE TABLE `dichvu` (
  `MaDichVu` int NOT NULL AUTO_INCREMENT,
  `TenDichVu` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MoTa` text COLLATE utf8mb4_unicode_ci,
  `GiaTu` decimal(18,2) DEFAULT NULL,
  `GiaDen` decimal(18,2) DEFAULT NULL,
  `TrangThai` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`MaDichVu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `dichvu` */

/*Table structure for table `donhang` */

DROP TABLE IF EXISTS `donhang`;

CREATE TABLE `donhang` (
  `MaDonHang` int NOT NULL AUTO_INCREMENT,
  `MaNguoiDung` int NOT NULL,
  `NgayDat` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CHO_XU_LY',
  `TenNguoiNhan` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SoDienThoaiNhan` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DiaChiNhan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GhiChu` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TongTien` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`MaDonHang`),
  KEY `FK_DonHang_NguoiDung` (`MaNguoiDung`),
  CONSTRAINT `FK_DonHang_NguoiDung` FOREIGN KEY (`MaNguoiDung`) REFERENCES `nguoidung` (`MaNguoiDung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `donhang` */

/*Table structure for table `donhangchitiet` */

DROP TABLE IF EXISTS `donhangchitiet`;

CREATE TABLE `donhangchitiet` (
  `MaChiTiet` int NOT NULL AUTO_INCREMENT,
  `MaDonHang` int NOT NULL,
  `MaSanPham` int NOT NULL,
  `SoLuong` int NOT NULL,
  `DonGia` decimal(18,2) NOT NULL,
  PRIMARY KEY (`MaChiTiet`),
  KEY `FK_DHCT_DonHang` (`MaDonHang`),
  KEY `FK_DHCT_SanPham` (`MaSanPham`),
  CONSTRAINT `FK_DHCT_DonHang` FOREIGN KEY (`MaDonHang`) REFERENCES `donhang` (`MaDonHang`),
  CONSTRAINT `FK_DHCT_SanPham` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `donhangchitiet` */

/*Table structure for table `giohang` */

DROP TABLE IF EXISTS `giohang`;

CREATE TABLE `giohang` (
  `MaGioHang` int NOT NULL AUTO_INCREMENT,
  `MaNguoiDung` int NOT NULL,
  `MaSanPham` int NOT NULL,
  `SoLuong` int NOT NULL DEFAULT '1',
  `NgayTao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaGioHang`),
  UNIQUE KEY `UQ_GioHang` (`MaNguoiDung`,`MaSanPham`),
  KEY `FK_GioHang_SanPham` (`MaSanPham`),
  CONSTRAINT `FK_GioHang_NguoiDung` FOREIGN KEY (`MaNguoiDung`) REFERENCES `nguoidung` (`MaNguoiDung`),
  CONSTRAINT `FK_GioHang_SanPham` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `giohang` */

/*Table structure for table `lienhe` */

DROP TABLE IF EXISTS `lienhe`;

CREATE TABLE `lienhe` (
  `MaLienHe` int NOT NULL AUTO_INCREMENT,
  `HoTen` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SoDienThoai` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TieuDe` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NoiDung` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayGui` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DaXuLy` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MaLienHe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `lienhe` */

/*Table structure for table `nguoidung` */

DROP TABLE IF EXISTS `nguoidung`;

CREATE TABLE `nguoidung` (
  `MaNguoiDung` int NOT NULL AUTO_INCREMENT,
  `TenDangNhap` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MatKhau` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `HoTen` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SoDienThoai` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MaQuyen` int NOT NULL,
  `NgayTao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`MaNguoiDung`),
  UNIQUE KEY `UQ_NguoiDung_TenDangNhap` (`TenDangNhap`),
  KEY `FK_NguoiDung_Quyen` (`MaQuyen`),
  CONSTRAINT `FK_NguoiDung_Quyen` FOREIGN KEY (`MaQuyen`) REFERENCES `quyen` (`MaQuyen`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `nguoidung` */

insert  into `nguoidung`(`MaNguoiDung`,`TenDangNhap`,`MatKhau`,`HoTen`,`Email`,`SoDienThoai`,`MaQuyen`,`NgayTao`,`TrangThai`) values 
(1,'admin','123456','Quan tri vien','admin@localhost','123456789',1,'2025-12-07 10:12:06',1);

/*Table structure for table `quyen` */

DROP TABLE IF EXISTS `quyen`;

CREATE TABLE `quyen` (
  `MaQuyen` int NOT NULL AUTO_INCREMENT,
  `TenQuyen` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaQuyen`),
  UNIQUE KEY `UQ_Quyen_TenQuyen` (`TenQuyen`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `quyen` */

insert  into `quyen`(`MaQuyen`,`TenQuyen`) values 
(1,'ADMIN'),
(2,'CUSTOMER');

/*Table structure for table `sanpham` */

DROP TABLE IF EXISTS `sanpham`;

CREATE TABLE `sanpham` (
  `MaSanPham` int NOT NULL AUTO_INCREMENT,
  `MaDanhMuc` int NOT NULL,
  `MaThuongHieu` int DEFAULT NULL,
  `TenSanPham` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MoTaNgan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MoTaChiTiet` text COLLATE utf8mb4_unicode_ci,
  `Gia` decimal(18,2) NOT NULL,
  `GiaCu` decimal(18,2) DEFAULT NULL,
  `SoLuongTon` int NOT NULL DEFAULT '0',
  `BaoHanhThang` int DEFAULT NULL,
  `SanPhamCu` tinyint(1) NOT NULL DEFAULT '0',
  `AnhDaiDien` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NgayTao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT NULL,
  `TrangThai` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`MaSanPham`),
  KEY `FK_SanPham_DanhMuc` (`MaDanhMuc`),
  KEY `FK_SanPham_ThuongHieu` (`MaThuongHieu`),
  CONSTRAINT `FK_SanPham_DanhMuc` FOREIGN KEY (`MaDanhMuc`) REFERENCES `danhmuc` (`MaDanhMuc`),
  CONSTRAINT `FK_SanPham_ThuongHieu` FOREIGN KEY (`MaThuongHieu`) REFERENCES `thuonghieu` (`MaThuongHieu`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `sanpham` */

insert  into `sanpham`(`MaSanPham`,`MaDanhMuc`,`MaThuongHieu`,`TenSanPham`,`MoTaNgan`,`MoTaChiTiet`,`Gia`,`GiaCu`,`SoLuongTon`,`BaoHanhThang`,`SanPhamCu`,`AnhDaiDien`,`NgayTao`,`NgayCapNhat`,`TrangThai`) values 
(1,1,1,'Laptop ASUS VivoBook 14 A1','Laptop van phong mong nhe','CPU i5, RAM 8GB, SSD 512GB, man 14 inch FHD',14990000.00,16990000.00,15,24,0,'/static/images/sp01_1.jpg','2025-12-07 10:12:06',NULL,1),
(5,1,3,'Laptop DELL Inspiron 3520','Laptop van phong Dell','i5, 8GB, SSD 512GB',16990000.00,18990000.00,18,24,0,'/static/images/sp05_1.jpg','2025-12-07 10:12:06',NULL,1),
(6,1,3,'Laptop DELL G15 5520','Laptop gaming Dell','i7, 16GB, SSD 512GB, RTX 3060',32990000.00,35990000.00,5,24,0,'/static/images/sp06_1.jpg','2025-12-07 10:12:06',NULL,1),
(7,1,4,'Laptop HP 15s du2121TU','Laptop hoc tap van phong','i3, 4GB, SSD 256GB',8990000.00,10490000.00,25,12,0,'/static/images/sp07_1.jpg','2025-12-07 10:12:06',NULL,1),
(8,1,5,'Laptop Lenovo IdeaPad 3 15ITL6','Laptop gia tot','i5, 8GB, SSD 512GB',13990000.00,15990000.00,17,24,0,'/static/images/sp08_1.jpg','2025-12-07 10:12:06',NULL,1),
(9,2,3,'PC Dell Vostro Small 3681','PC van phong nho gon','i3, RAM 4GB, HDD 1TB',8990000.00,9990000.00,12,24,0,'/static/images/sp09_1.jpg','2025-12-07 10:12:06',NULL,1),
(10,2,3,'PC Dell OptiPlex 7090','PC doanh nghiep on dinh','i5, 8GB, SSD 256GB',15990000.00,17990000.00,10,36,0,'/static/images/sp10_1.jpg','2025-12-07 10:12:06',NULL,1),
(11,2,1,'PC ASUS ExpertCenter D500MA','PC van phong ASUS','i5, 8GB, SSD 256GB, HDD 1TB',16990000.00,18990000.00,9,36,0,'/static/images/sp11_1.jpg','2025-12-07 10:12:06',NULL,1),
(12,2,2,'PC Gaming ACER Predator Orion','PC gaming','i7, 16GB, SSD 512GB, RTX 3060',35990000.00,38990000.00,4,24,0,'/static/images/sp12_1.jpg','2025-12-07 10:12:06',NULL,1),
(13,2,5,'PC Lenovo IdeaCentre 3','PC gia re','Pentium, RAM 4GB, HDD 1TB',6990000.00,7990000.00,14,12,0,'/static/images/sp13_1.jpg','2025-12-07 10:12:06',NULL,1),
(14,2,4,'PC HP ProDesk 400 G7','PC doanh nghiep HP','i5, 8GB, SSD 256GB',15990000.00,17990000.00,7,36,0,'/static/images/sp14_1.jpg','2025-12-07 10:12:06',NULL,1),
(15,2,6,'PC Apple Mac mini M1','PC nho gon','Chip M1, RAM 8GB, SSD 256GB',19990000.00,21990000.00,6,12,0,'/static/images/sp15_1.jpg','2025-12-07 10:12:06',NULL,1),
(16,2,1,'PC Gaming ASUS ROG Strix','PC gaming cao cap','i7, 32GB, SSD 1TB, RTX 4070',49990000.00,52990000.00,3,24,0,'/static/images/sp16_1.jpg','2025-12-07 10:12:06',NULL,1),
(17,3,6,'iPad 9 10.2 WiFi','Tablet Apple gia tot','Manh 10.2 inch, chip A13',9490000.00,9990000.00,20,12,0,'/static/images/sp17_1.jpg','2025-12-07 10:12:06',NULL,1),
(18,3,6,'iPad Air 5','Tablet hien dai','Chip M1, man 10.9 inch',16990000.00,17990000.00,12,12,0,'/static/images/sp18_1.jpg','2025-12-07 10:12:06',NULL,1),
(19,3,2,'Tablet Acer Iconia Tab M10','Tablet Android','RAM 4GB, ROM 64GB',4990000.00,5490000.00,18,12,0,'/static/images/sp19_1.jpg','2025-12-07 10:12:06',NULL,1),
(20,3,5,'Lenovo Tab M10 HD','Tablet gia re','RAM 3GB, man 10 inch',3990000.00,4490000.00,22,12,0,'/static/images/sp20_1.jpg','2025-12-07 10:12:06',NULL,1),
(21,3,4,'HP Chromebook x2','Tablet 2 in 1','ChromeOS, ban phim thao roi',8990000.00,9990000.00,8,12,0,'/static/images/sp21_1.jpg','2025-12-07 10:12:06',NULL,1),
(22,3,1,'ASUS ZenPad 10','Tablet gia re','Manh 10 inch pin lon',3590000.00,3990000.00,16,12,0,'/static/images/sp22_1.jpg','2025-12-07 10:12:06',NULL,1),
(23,4,1,'Mainboard ASUS PRIME B560M','Mainboard Intel','DDR4, M.2, 10/11 Gen',2490000.00,2790000.00,25,12,0,'/static/images/sp23_1.jpg','2025-12-07 10:12:06',NULL,1),
(24,4,1,'VGA ASUS Dual RTX 3060','VGA gaming','RTX 3060 12GB',9990000.00,10990000.00,6,24,0,'/static/images/sp24_1.jpg','2025-12-07 10:12:06',NULL,1),
(25,4,3,'PSU Dell 400W','Nguon van phong','400W, 80Plus White',890000.00,990000.00,30,12,0,'/static/images/sp25_1.jpg','2025-12-07 10:12:06',NULL,1),
(26,4,2,'RAM Acer 8GB DDR4','RAM PC','8GB bus 3200',790000.00,890000.00,40,36,0,'/static/images/sp26_1.jpg','2025-12-07 10:12:06',NULL,1),
(27,4,5,'RAM Lenovo 16GB DDR4','RAM laptop','16GB bus 2666',1590000.00,1790000.00,18,36,0,'/static/images/sp27_1.jpg','2025-12-07 10:12:06',NULL,1),
(28,4,4,'SSD HP EX900 M.2 512GB','SSD toc do cao','NVMe, 512GB',1690000.00,1890000.00,22,36,0,'/static/images/sp28_1.jpg','2025-12-07 10:12:06',NULL,1),
(29,4,2,'Case Acer Gaming RGB','Case co den RGB','Mid tower, 3 fan RGB',1290000.00,1490000.00,14,12,0,'/static/images/sp29_1.jpg','2025-12-07 10:12:06',NULL,1),
(30,4,1,'Tan nhiet nuoc ASUS AIO','Tan nhiet CPU','AIO 240 RGB',2590000.00,2890000.00,9,36,0,'/static/images/sp30_1.jpg','2025-12-07 10:12:06',NULL,1),
(31,5,1,'Man hinh ASUS 24 75Hz','Man hinh van phong','24 inch, 75Hz, FHD',3290000.00,3590000.00,20,24,0,'/static/images/sp31_1.jpg','2025-12-07 10:12:06',NULL,1),
(32,5,2,'Man hinh ACER Nitro 27 144Hz','Man hinh gaming','27 inch, 144Hz',5990000.00,6490000.00,10,24,0,'/static/images/sp32_1.jpg','2025-12-07 10:12:06',NULL,1),
(33,5,3,'Dell UltraSharp 24','Man hinh do hoa','IPS, 2K, chuan mau',7490000.00,7990000.00,8,36,0,'/static/images/sp33_1.jpg','2025-12-07 10:12:06',NULL,1),
(34,5,4,'HP 22F 21.5 inch','Man hinh mong nhe','FHD, thiet ke mong',2590000.00,2890000.00,18,24,0,'/static/images/sp34_1.jpg','2025-12-07 10:12:06',NULL,1),
(35,5,5,'Lenovo Gaming 24 165Hz','Man hinh gaming','165Hz, 1ms',5690000.00,5990000.00,7,24,0,'/static/images/sp35_1.jpg','2025-12-07 10:12:06',NULL,1),
(36,5,6,'Apple Studio Display','Man hinh cao cap','5K Retina',39990000.00,41990000.00,2,12,0,'/static/images/sp36_1.jpg','2025-12-07 10:12:06',NULL,1),
(37,5,3,'Dell 19.5 inch','Man hinh gia re','HD+, ben bi',1990000.00,2190000.00,25,24,0,'/static/images/sp37_1.jpg','2025-12-07 10:12:06',NULL,1),
(38,5,2,'ACER 32 cong','Man hinh cong','32 inch cong FHD',5790000.00,6090000.00,6,24,0,'/static/images/sp38_1.jpg','2025-12-07 10:12:06',NULL,1),
(39,6,3,'Laptop Dell Latitude cu','Laptop cu','i5, RAM 8GB, SSD',6900000.00,0.00,5,6,1,'/static/images/sp39_1.jpg','2025-12-07 10:12:06',NULL,1),
(40,6,1,'Laptop ASUS X441 cu','Laptop cu sinh vien','i3, RAM 4GB, HDD',4500000.00,0.00,7,6,1,'/static/images/sp40_1.jpg','2025-12-07 10:12:06',NULL,1),
(41,6,5,'Laptop ThinkPad cu','Laptop cu ben bi','i5, SSD 240GB',6200000.00,0.00,6,6,1,'/static/images/sp41_1.jpg','2025-12-07 10:12:06',NULL,1),
(42,6,4,'PC HP cu','May tinh cu','i3, 4GB, HDD',3500000.00,0.00,4,6,1,'/static/images/sp42_1.jpg','2025-12-07 10:12:06',NULL,1),
(43,6,2,'PC Gaming cu GTX1050','PC cu gia re','i5, GTX1050',8500000.00,0.00,3,6,1,'/static/images/sp43_1.jpg','2025-12-07 10:12:06',NULL,1),
(44,6,3,'Man hinh Dell cu 24','Man hinh cu','24 inch FHD',2200000.00,0.00,8,6,1,'/static/images/sp44_1.jpg','2025-12-07 10:12:06',NULL,1),
(45,7,1,'Chuot ASUS RGB','Chuot gaming','Cam bien 6400 DPI',590000.00,690000.00,40,12,0,'/static/images/sp45_1.jpg','2025-12-07 10:12:06',NULL,1),
(46,7,3,'Ban phim Dell USB','Ban phim van phong','Co day, go em',250000.00,300000.00,60,12,0,'/static/images/sp46_1.jpg','2025-12-07 10:12:06',NULL,1),
(47,7,6,'Apple Magic Keyboard','Ban phim khong day','Bluetooth, pin lau',2990000.00,3290000.00,10,12,0,'/static/images/sp47_1.jpg','2025-12-07 10:12:06',NULL,1),
(48,7,5,'Tui chong soc Lenovo','Tui laptop','15.6 inch, chong nuoc',390000.00,450000.00,50,12,0,'/static/images/sp48_1.jpg','2025-12-07 10:12:06',NULL,1),
(49,7,4,'Tai nghe HP over-ear','Tai nghe co mic','Am thanh ro',490000.00,550000.00,35,12,0,'/static/images/sp49_1.jpg','2025-12-07 10:12:06',NULL,1),
(50,1,2,'De tan nhiet Acer','Phu kien laptop','2 fan, LED xanh',290000.00,350000.00,45,12,0,'/static/images/sp50_1.jpg','2025-12-07 10:12:06','2025-12-07 10:42:09',1);

/*Table structure for table `thuonghieu` */

DROP TABLE IF EXISTS `thuonghieu`;

CREATE TABLE `thuonghieu` (
  `MaThuongHieu` int NOT NULL AUTO_INCREMENT,
  `TenThuongHieu` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaThuongHieu`),
  UNIQUE KEY `UQ_ThuongHieu_TenThuongHieu` (`TenThuongHieu`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `thuonghieu` */

insert  into `thuonghieu`(`MaThuongHieu`,`TenThuongHieu`) values 
(2,'ACER'),
(6,'APPLE'),
(1,'ASUS'),
(3,'DELL'),
(4,'HP'),
(5,'LENOVO');

/* Trigger structure for table `donhangchitiet` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `trg_GiamSoLuongTon` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `trg_GiamSoLuongTon` AFTER INSERT ON `donhangchitiet` FOR EACH ROW BEGIN
    UPDATE SanPham
    SET SoLuongTon = SoLuongTon - NEW.SoLuong
    WHERE MaSanPham = NEW.MaSanPham;
END */$$


DELIMITER ;

/* Trigger structure for table `donhangchitiet` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `trg_TangSoLuongTon` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `trg_TangSoLuongTon` AFTER DELETE ON `donhangchitiet` FOR EACH ROW BEGIN
    UPDATE SanPham
    SET SoLuongTon = SoLuongTon + OLD.SoLuong
    WHERE MaSanPham = OLD.MaSanPham;
END */$$


DELIMITER ;

/* Procedure structure for procedure `sp_SuaSanPham` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_SuaSanPham` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_SuaSanPham`(
    IN p_MaSanPham    INT,
    IN p_MaDanhMuc    INT,
    IN p_MaThuongHieu INT,
    IN p_TenSanPham   VARCHAR(200),
    IN p_MoTaNgan     VARCHAR(255),
    IN p_MoTaChiTiet  TEXT,
    IN p_Gia          DECIMAL(18,2),
    IN p_GiaCu        DECIMAL(18,2),
    IN p_SoLuongTon   INT,
    IN p_BaoHanhThang INT,
    IN p_SanPhamCu    TINYINT(1),
    IN p_AnhDaiDien   VARCHAR(255)
)
BEGIN
    UPDATE SanPham SET
        MaDanhMuc    = p_MaDanhMuc,
        MaThuongHieu = p_MaThuongHieu,
        TenSanPham   = p_TenSanPham,
        MoTaNgan     = p_MoTaNgan,
        MoTaChiTiet  = p_MoTaChiTiet,
        Gia          = p_Gia,
        GiaCu        = p_GiaCu,
        SoLuongTon   = p_SoLuongTon,
        BaoHanhThang = p_BaoHanhThang,
        SanPhamCu    = p_SanPhamCu,
        AnhDaiDien   = p_AnhDaiDien,
        NgayCapNhat  = NOW()   -- ✅ thay SYSDATETIME() bằng NOW()
    WHERE MaSanPham = p_MaSanPham;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_ThemSanPham` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_ThemSanPham` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ThemSanPham`(
    IN p_MaDanhMuc    INT,
    IN p_MaThuongHieu INT,
    IN p_TenSanPham   VARCHAR(200),
    IN p_MoTaNgan     VARCHAR(255),
    IN p_MoTaChiTiet  TEXT,
    IN p_Gia          DECIMAL(18,2),
    IN p_GiaCu        DECIMAL(18,2),
    IN p_SoLuongTon   INT,
    IN p_BaoHanhThang INT,
    IN p_SanPhamCu    TINYINT(1),
    IN p_AnhDaiDien   VARCHAR(255)
)
BEGIN
    INSERT INTO SanPham
    (MaDanhMuc, MaThuongHieu, TenSanPham, MoTaNgan, MoTaChiTiet,
     Gia, GiaCu, SoLuongTon, BaoHanhThang, SanPhamCu, AnhDaiDien, NgayTao, TrangThai)
    VALUES
    (p_MaDanhMuc, p_MaThuongHieu, p_TenSanPham, p_MoTaNgan, p_MoTaChiTiet,
     p_Gia, p_GiaCu, p_SoLuongTon, p_BaoHanhThang, p_SanPhamCu, p_AnhDaiDien, NOW(), 1);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_XoaSanPham` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_XoaSanPham` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_XoaSanPham`(
    IN p_MaSanPham INT
)
BEGIN
    DELETE FROM SanPham WHERE MaSanPham = p_MaSanPham;
END */$$
DELIMITER ;

/*Table structure for table `vw_chitietsanpham` */

DROP TABLE IF EXISTS `vw_chitietsanpham`;

/*!50001 DROP VIEW IF EXISTS `vw_chitietsanpham` */;
/*!50001 DROP TABLE IF EXISTS `vw_chitietsanpham` */;

/*!50001 CREATE TABLE  `vw_chitietsanpham`(
 `MaSanPham` int ,
 `MaDanhMuc` int ,
 `MaThuongHieu` int ,
 `TenSanPham` varchar(200) ,
 `MoTaNgan` varchar(255) ,
 `MoTaChiTiet` text ,
 `Gia` decimal(18,2) ,
 `GiaCu` decimal(18,2) ,
 `SoLuongTon` int ,
 `BaoHanhThang` int ,
 `SanPhamCu` tinyint(1) ,
 `AnhDaiDien` varchar(255) ,
 `NgayTao` datetime ,
 `NgayCapNhat` datetime ,
 `TrangThai` tinyint(1) ,
 `TenDanhMuc` varchar(100) ,
 `TenThuongHieu` varchar(100) 
)*/;

/*Table structure for table `vw_sanphamdaydu` */

DROP TABLE IF EXISTS `vw_sanphamdaydu`;

/*!50001 DROP VIEW IF EXISTS `vw_sanphamdaydu` */;
/*!50001 DROP TABLE IF EXISTS `vw_sanphamdaydu` */;

/*!50001 CREATE TABLE  `vw_sanphamdaydu`(
 `MaSanPham` int ,
 `MaDanhMuc` int ,
 `MaThuongHieu` int ,
 `TenSanPham` varchar(200) ,
 `MoTaNgan` varchar(255) ,
 `MoTaChiTiet` text ,
 `Gia` decimal(18,2) ,
 `GiaCu` decimal(18,2) ,
 `SoLuongTon` int ,
 `BaoHanhThang` int ,
 `SanPhamCu` tinyint(1) ,
 `AnhDaiDien` varchar(255) ,
 `NgayTao` datetime ,
 `NgayCapNhat` datetime ,
 `TrangThai` tinyint(1) ,
 `TenDanhMuc` varchar(100) ,
 `TenThuongHieu` varchar(100) 
)*/;

/*View structure for view vw_chitietsanpham */

/*!50001 DROP TABLE IF EXISTS `vw_chitietsanpham` */;
/*!50001 DROP VIEW IF EXISTS `vw_chitietsanpham` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_chitietsanpham` AS select `sp`.`MaSanPham` AS `MaSanPham`,`sp`.`MaDanhMuc` AS `MaDanhMuc`,`sp`.`MaThuongHieu` AS `MaThuongHieu`,`sp`.`TenSanPham` AS `TenSanPham`,`sp`.`MoTaNgan` AS `MoTaNgan`,`sp`.`MoTaChiTiet` AS `MoTaChiTiet`,`sp`.`Gia` AS `Gia`,`sp`.`GiaCu` AS `GiaCu`,`sp`.`SoLuongTon` AS `SoLuongTon`,`sp`.`BaoHanhThang` AS `BaoHanhThang`,`sp`.`SanPhamCu` AS `SanPhamCu`,`sp`.`AnhDaiDien` AS `AnhDaiDien`,`sp`.`NgayTao` AS `NgayTao`,`sp`.`NgayCapNhat` AS `NgayCapNhat`,`sp`.`TrangThai` AS `TrangThai`,`dm`.`TenDanhMuc` AS `TenDanhMuc`,`th`.`TenThuongHieu` AS `TenThuongHieu` from ((`sanpham` `sp` left join `danhmuc` `dm` on((`sp`.`MaDanhMuc` = `dm`.`MaDanhMuc`))) left join `thuonghieu` `th` on((`sp`.`MaThuongHieu` = `th`.`MaThuongHieu`))) */;

/*View structure for view vw_sanphamdaydu */

/*!50001 DROP TABLE IF EXISTS `vw_sanphamdaydu` */;
/*!50001 DROP VIEW IF EXISTS `vw_sanphamdaydu` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_sanphamdaydu` AS select `sp`.`MaSanPham` AS `MaSanPham`,`sp`.`MaDanhMuc` AS `MaDanhMuc`,`sp`.`MaThuongHieu` AS `MaThuongHieu`,`sp`.`TenSanPham` AS `TenSanPham`,`sp`.`MoTaNgan` AS `MoTaNgan`,`sp`.`MoTaChiTiet` AS `MoTaChiTiet`,`sp`.`Gia` AS `Gia`,`sp`.`GiaCu` AS `GiaCu`,`sp`.`SoLuongTon` AS `SoLuongTon`,`sp`.`BaoHanhThang` AS `BaoHanhThang`,`sp`.`SanPhamCu` AS `SanPhamCu`,`sp`.`AnhDaiDien` AS `AnhDaiDien`,`sp`.`NgayTao` AS `NgayTao`,`sp`.`NgayCapNhat` AS `NgayCapNhat`,`sp`.`TrangThai` AS `TrangThai`,`dm`.`TenDanhMuc` AS `TenDanhMuc`,`th`.`TenThuongHieu` AS `TenThuongHieu` from ((`sanpham` `sp` left join `danhmuc` `dm` on((`sp`.`MaDanhMuc` = `dm`.`MaDanhMuc`))) left join `thuonghieu` `th` on((`sp`.`MaThuongHieu` = `th`.`MaThuongHieu`))) where (`sp`.`TrangThai` = 1) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
