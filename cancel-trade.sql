DROP PROCEDURE IF EXISTS `orders_match`;
DELIMITER $$
 CREATE PROCEDURE orders_cancel (
 id varchar(255) 

)
    BEGIN
	    
		START TRANSACTION;
			Select * from orders where orders.id = id for update;
		    Insert into `orders-archive` select * from orders where orders.id = id
			delete from orders where orders.id = id;		
		COMMIT;
	END
$$
DELIMITER ;
