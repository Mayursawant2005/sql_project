create database librarydb;
use librarydb;
drop database librarydb;
-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);  

-- Table: tbl_book

CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);


-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
); 


-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

-- Table: tbl_book_copies
-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);
-- Table: tbl_book_loans
-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);
drop table tbl_book_loans;
use tbl_book_loans;
				


select * from tbl_publisher;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_book_copies;
select * from tbl_book_loans;
-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT bc.book_copies_No_Of_Copies AS TotalCopies
FROM tbl_book b
JOIN tbl_book_copies bc 
    ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
  AND lb.library_branch_BranchName = 'Sharpstown'; 


SELECT * FROM tbl_book WHERE book_Title LIKE '%The Lost Tribe%';

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT lb.library_branch_BranchName AS BranchName,
       bc.book_copies_No_Of_Copies AS NoOfCopies
FROM tbl_book_copies bc
JOIN tbl_book b 
    ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe';    






-- Retrieve the names of all borrowers who do not have any books checked out.
SELECT b.borrower_BorrowerName
FROM tbl_borrower b
LEFT JOIN tbl_book_loans l 
    ON b.borrower_CardNo = l.book_loans_CardNo
WHERE l.book_loans_CardNo IS NULL;


-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
SELECT 
    b.book_Title,
    br.borrower_BorrowerName,
    br.borrower_BorrowerAddress
FROM
    tbl_book_loans bl
        JOIN
    tbl_book b ON bl.book_loans_BookID = b.book_BookID
        JOIN
    tbl_borrower br ON bl.book_loans_CardNo = br.borrower_CardNo
        JOIN
    tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE
    lb.library_branch_BranchName = 'Sharpstown'
        AND bl.book_loans_DueDate = '2018-03-02';
-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT
    lb.library_branch_BranchName,
    COUNT(bl.book_loans_BookID) AS NumberOfLoans
FROM
    tbl_book_loans bl
JOIN
    tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY
    lb.library_branch_BranchName;
-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT
    b.book_Title,
    bc.book_copies_No_Of_Copies
FROM
    tbl_book_authors ba
JOIN
    tbl_book b ON ba.book_authors_BookID = b.book_BookID
JOIN
    tbl_book_copies bc ON b.book_BookID = bc.book_copies_BookID
JOIN
    tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE
    ba.book_authors_AuthorName = 'Stephen King'
    AND lb.library_branch_BranchName = 'Central'