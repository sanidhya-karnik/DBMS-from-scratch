CREATE TABLE WebActivity (
    session_id VARCHAR(36) PRIMARY KEY,
    created_at TIMESTAMP, -- Use the appropriate data type for timestamps
    source VARCHAR(20), -- Adjust the length as needed
    medium VARCHAR(20), -- Adjust the length as needed
    order_id VARCHAR(36), -- This is a foreign key
    type VARCHAR(20), -- Adjust the length as needed
    city VARCHAR(20) -- Adjust the length as needed
);
 
CREATE TABLE Orders (
    order_id VARCHAR(36) PRIMARY KEY,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    order_type VARCHAR(4), -- Adjust the length as needed
    metal_id VARCHAR(36) NOT NULL,
    metal_quantity DECIMAL(10, 3), -- Adjust the precision and scale as needed
    rate_id VARCHAR(36) NOT NULL,
    price INT,
    distributor_id VARCHAR(36) NOT NULL,
    order_status INT NOT NULL, -- Adjust the length as needed
    cust_id VARCHAR(36) NOT NULL,
    city VARCHAR(255) -- Adjust the length as needed
);
 
CREATE TABLE Enums (
    id VARCHAR(36) PRIMARY KEY,
    table_name VARCHAR(20) NOT NULL, -- Name of the subclass table
    column_name VARCHAR(20) NOT NULL, -- Name of the column in the subclass table
    enum INT NOT NULL, -- This is a foreign key referring to the subclasses' enum values
    value VARCHAR(20) NOT NULL -- The actual enum value
);
 
CREATE TABLE OrderStatus (
    enum INT PRIMARY KEY,
    value VARCHAR(20) NOT NULL
);
 
CREATE TABLE PaymentStatus (
    enum INT PRIMARY KEY,
    value VARCHAR(20) NOT NULL
);
 
CREATE TABLE Customers (
    cust_id VARCHAR(36) PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL, -- Adjust the length as needed
    last_name VARCHAR(20) NOT NULL, -- Adjust the length as needed
    created_at TIMESTAMP, -- Use the appropriate data type for timestamps
    phone VARCHAR(20), -- Adjust the length as needed
    email VARCHAR(50), -- Adjust the length as needed
    date_of_birth DATE, -- Use the appropriate data type for dates
    gender CHAR(1), -- Assuming gender is a single character (e.g., 'M' or 'F')
    govt_id VARCHAR(36), -- Adjust the length as needed
    bank_acc VARCHAR(36), -- Adjust the length as needed
    referred_by VARCHAR(36) -- This is a foreign key
);
 
CREATE TABLE Transactions (
    tx_id VARCHAR(36) PRIMARY KEY,
    created_at TIMESTAMP,
    order_id VARCHAR(36) NOT NULL, -- This is a foreign key
    payment_status INT NOT NULL, -- This is a foreign key
    payment_mode VARCHAR(20), -- Adjust the length as needed
    type VARCHAR(20) -- Adjust the length as needed
);
 
CREATE TABLE Wallets (
    wallet_id VARCHAR(36) PRIMARY KEY,
    metal_id VARCHAR(36), -- Adjust data type as needed
    metal_quantity DECIMAL(10, 3), -- Adjust precision and scale as needed
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    cust_id VARCHAR(36) NOT NULL -- This is a foreign key
);
 
CREATE TABLE Agents (
    agent_id VARCHAR(36) PRIMARY KEY,
    created_at TIMESTAMP,
    first_name VARCHAR(20), -- Adjust the length as needed
    last_name VARCHAR(20), -- Adjust the length as needed
    email VARCHAR(50), -- Adjust the length as needed
    phone VARCHAR(20), -- Adjust the length as needed
    city VARCHAR(20), -- Adjust the length as needed
    referral_code VARCHAR(36) -- Adjust the length as needed
);
 
CREATE TABLE Distributors (
    distributor_id VARCHAR(36) PRIMARY KEY,
    first_name VARCHAR(20), -- Adjust the length as needed
    last_name VARCHAR(20), -- Adjust the length as needed
    phone VARCHAR(20), -- Adjust the length as needed
    email VARCHAR(50), -- Adjust the length as needed
    city VARCHAR(20), -- Adjust the length as needed
    address VARCHAR(255) -- Adjust the length as needed
);
 
CREATE TABLE Metals (
    metal_id VARCHAR(36) PRIMARY KEY,
    metal_name VARCHAR(20) NOT NULL -- Adjust the length as needed
);
 
CREATE TABLE MetalRates (
    rate_id VARCHAR(36) PRIMARY KEY,
    created_at TIMESTAMP,
    metal_id VARCHAR(36) NOT NULL, -- This is a foreign key
    metal_rate DECIMAL(10, 3) -- Adjust precision and scale as needed
);

ALTER TABLE WebActivity
ADD CONSTRAINT FK_WebActivity_Orders FOREIGN KEY (order_id) REFERENCES Orders (order_id);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Metal FOREIGN KEY (metal_id) REFERENCES Metals(metal_id);
 
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Rate FOREIGN KEY (rate_id) REFERENCES MetalRates(rate_id);
 
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Distributor FOREIGN KEY (distributor_id) REFERENCES Distributors(distributor_id);
 
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customer_id FOREIGN KEY (cust_id) REFERENCES Customers(cust_id);
 
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customer_sts FOREIGN KEY (order_status) REFERENCES OrderStatus(enum);
 
ALTER TABLE Customers
ADD CONSTRAINT FK_Customers_Agents FOREIGN KEY (referred_by) REFERENCES Agents(referral_code);
 
ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id);
 
ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_PaymentStatus FOREIGN KEY (payment_status) REFERENCES PaymentStatus(enum);
 
ALTER TABLE Wallets
ADD CONSTRAINT FK_Wallets_Customers FOREIGN KEY (cust_id) REFERENCES Customers(cust_id);
 
ALTER TABLE MetalRates
ADD CONSTRAINT FK_MetalRates_Metals FOREIGN KEY (metal_id) REFERENCES Metals(metal_id);