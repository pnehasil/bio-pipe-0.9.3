CREATE TABLE `cnv` (
  `pac` varchar(50) NOT NULL,
  `chr` varchar(10) NOT NULL,
  `start` int(11) NOT NULL,
  `end` int(11) NOT NULL,
  `kor` varchar(100) NOT NULL,
  `exon` varchar(100) NOT NULL,
  `gen` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
