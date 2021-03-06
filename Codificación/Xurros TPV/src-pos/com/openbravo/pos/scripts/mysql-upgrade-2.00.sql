--    Openbravo POS is a point of sales application designed for touch screens.
--    Copyright (C) 2007-2008 Openbravo, S.L.
--    http://sourceforge.net/projects/openbravopos
--
--    This file is modified as part of fastfood branch of Openbravo POS. 2008
--    These modifications are copyright Open Sistemas de Información Internet, S.L.
--    http://www.opensistemas.com
--    e-mail: imasd@opensistemas.com
--
--    This program is free software; you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation; either version 2 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program; if not, write to the Free Software
--    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

-- Database upgrade script for MYSQL
-- v2.00 - v2.10 fastfood

ALTER TABLE PEOPLE ADD COLUMN CARD VARCHAR(255);  
CREATE INDEX PEOPLE_CARD_INX ON PEOPLE(CARD);

ALTER TABLE CUSTOMERS ADD COLUMN TAXID VARCHAR(255);  
ALTER TABLE CUSTOMERS ADD COLUMN CARD VARCHAR(255);  
ALTER TABLE CUSTOMERS ADD COLUMN MAXDEBT DOUBLE DEFAULT 0 NOT NULL;
ALTER TABLE CUSTOMERS ADD COLUMN CURDATE DATETIME;
ALTER TABLE CUSTOMERS ADD COLUMN CURDEBT DOUBLE;
CREATE INDEX CUSTOMERS_TAXID_INX ON CUSTOMERS(TAXID);
CREATE INDEX CUSTOMERS_CARD_INX ON CUSTOMERS(CARD);

ALTER TABLE PRODUCTS ADD COLUMN ATTRIBUTES MEDIUMBLOB;

ALTER TABLE TICKETS ADD COLUMN CUSTOMER VARCHAR(255);
ALTER TABLE TICKETS ADD CONSTRAINT TICKETS_CUSTOMERS_FK FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID);
CREATE INDEX TICKETS_TICKETID ON TICKETS(TICKETID);

ALTER TABLE TICKETLINES ADD COLUMN ATTRIBUTES MEDIUMBLOB;

ALTER TABLE RECEIPTS ADD COLUMN DATENEW DATETIME;
CREATE INDEX RECEIPTS_INX_1 ON RECEIPTS(DATENEW);
UPDATE RECEIPTS SET DATENEW = (SELECT DATENEW FROM TICKETS WHERE TICKETS.ID = RECEIPTS.ID);
ALTER TABLE RECEIPTS MODIFY COLUMN DATENEW DATETIME NOT NULL;

DROP INDEX TICKETS_INX_1 ON TICKETS;
ALTER TABLE TICKETS DROP COLUMN DATENEW;

INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('14', 'Menu.Root', 0, $FILE{/com/openbravo/pos/templates/Menu.Root.txt});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('15', 'Printer.CustomerPaid', 0, $FILE{/com/openbravo/pos/templates/Printer.CustomerPaid.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('16', 'Printer.CustomerPaid2', 0, $FILE{/com/openbravo/pos/templates/Printer.CustomerPaid2.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('17', 'payment.cash', 0, $FILE{/com/openbravo/pos/templates/payment.cash.txt});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('18', 'banknote.1000pesos', 1, $FILE{/com/openbravo/pos/templates/banknote.1000pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('19', 'banknote.2000pesos', 1, $FILE{/com/openbravo/pos/templates/banknote.2000pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('20', 'banknote.5000pesos', 1, $FILE{/com/openbravo/pos/templates/banknote.5000pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('21', 'banknote.10000pesos', 1, $FILE{/com/openbravo/pos/templates/banknote.10000pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('22', 'banknote.20000pesos', 1, $FILE{/com/openbravo/pos/templates/banknote.20000pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('23', 'coin.10pesos', 1, $FILE{/com/openbravo/pos/templates/coin.10pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('24', 'coin.50pesos', 1, $FILE{/com/openbravo/pos/templates/coin.50pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('25', 'coin.100pesos', 1, $FILE{/com/openbravo/pos/templates/coin.100pesos.jpg});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('26', 'coin.500pesos', 1, $FILE{/com/openbravo/pos/templates/coin.500pesos.jpg});

DELETE FROM SHAREDTICKETS;

UPDATE APPLICATIONS SET NAME = $APP_NAME{}, VERSION = '2.10' WHERE ID = $APP_ID{};

ALTER TABLE CUSTOMERS ADD COLUMN CARD VARCHAR(255);
ALTER TABLE CUSTOMERS ADD COLUMN CURDATE DATETIME;
ALTER TABLE CUSTOMERS ADD COLUMN CURDEBT DOUBLE;

INSERT INTO CATEGORIES(ID, NAME, PARENTID, IMAGE) VALUES ('0', 'Composiciones', null, null);
INSERT INTO CATEGORIES(ID, NAME, PARENTID, IMAGE) VALUES ('-1', 'BOM', null, null);

INSERT INTO TAXES(ID, NAME, RATE) VALUES ('-1', 'NOTAX', 0.0);

CREATE TABLE PRODUCTS_MAT (
    PRODUCT VARCHAR(255) NOT NULL,
    MATERIAL VARCHAR(255) NOT NULL,
    AMOUNT DOUBLE NOT NULL,
    PRIMARY KEY (PRODUCT, MATERIAL),
    CONSTRAINT PROD_MAT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT PROD_MAT_FK_2 FOREIGN KEY (MATERIAL) REFERENCES PRODUCTS(ID) 
);

CREATE TABLE SUBGROUPS (
    ID VARCHAR(255) NOT NULL,
    COMPOSITION VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    IMAGE MEDIUMBLOB,
    PRIMARY KEY(ID),
    CONSTRAINT SUBGROUPS_FK_1 FOREIGN KEY (COMPOSITION) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE SUBGROUPS_PROD (
    SUBGROUP VARCHAR(255) NOT NULL,
    PRODUCT VARCHAR(255) NOT NULL,
    PRIMARY KEY (SUBGROUP, PRODUCT),
    CONSTRAINT SUBGROUPS_PROD_FK_1 FOREIGN KEY (SUBGROUP) REFERENCES SUBGROUPS(ID) ON DELETE CASCADE,
    CONSTRAINT SUBGROUPS_PROD_FK_2 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE DISCOUNTS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    QUANTITY DOUBLE NOT NULL,
    PERCENTAGE BIT NOT NULL,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX DISCOUNTS_NAME_INX ON DISCOUNTS(NAME);

CREATE TABLE TARIFFAREAS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    TARIFFORDER INTEGER DEFAULT 0,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX TARIFFAREAS_NAME_INX ON TARIFFAREAS(NAME);

CREATE TABLE TARIFFAREAS_PROD (
    TARIFFID VARCHAR(255) NOT NULL,
    PRODUCTID VARCHAR(255) NOT NULL,
    PRICESELL DOUBLE NOT NULL,
    PRIMARY KEY (TARIFFID, PRODUCTID),
    CONSTRAINT TARIFFAREAS_PROD_FK_1 FOREIGN KEY (TARIFFID) REFERENCES TARIFFAREAS(ID) ON DELETE CASCADE,
    CONSTRAINT TARIFFAREAS_PROD_FK_2 FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE UNITS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    SYMBOL VARCHAR(255) NOT NULL,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX UNITS_NMAE_INX ON UNITS(NAME);

CREATE TABLE MATERIALS_UNITS (
    MATERIAL VARCHAR(255) NOT NULL,
    UNIT VARCHAR(255) NOT NULL,
    AMOUNT DOUBLE NOT NULL,
    PRICEBUY DOUBLE NOT NULL,
    PRIMARY KEY(MATERIAL, UNIT),
    CONSTRAINT MAT_UNIT_FK_1 FOREIGN KEY (MATERIAL) REFERENCES PRODUCTS(ID),
    CONSTRAINT MAT_UNIT_FK_2 FOREIGN KEY (UNIT) REFERENCES UNITS(ID)
);

ALTER TABLE RECEIPTS ADD COLUMN DATENEW DATETIME NOT NULL;

ALTER TABLE TICKETS ADD COLUMN DISCOUNTNAME VARCHAR(255);
ALTER TABLE TICKETS ADD COLUMN DISCOUNTVALUE VARCHAR(255);
ALTER TABLE TICKETS ADD COLUMN TARIFFAREA VARCHAR(255) DEFAULT NULL;
ALTER TABLE TICKETS ADD CONSTRAINT TICKETS_TARIFFAREA FOREIGN KEY (TARIFFAREA) REFERENCES TARIFFAREAS(ID);

ALTER TABLE TICKETLINES ADD COLUMN ISDISCOUNT BIT;

