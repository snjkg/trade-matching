DROP PROCEDURE IF EXISTS `orders_match`;
DELIMITER $$
 CREATE PROCEDURE orders_match (
 id varchar(255) ,
 userid varchar(255) ,
 market varchar(7) ,
 buysell varchar(7) ,
 baseasset varchar(7) ,
 quoteasset varchar(7) ,
 amount bigint  ,
 amountoutstanding bigint ,
 amountgained bigint  ,
 minamount bigint ,
 rate varchar(255) ,
 status varchar(255)  

)

    BEGIN
	    
		-- insert into log (text) values (id);
		START TRANSACTION;


		-- Process the buy orders in the order in which they were created.
		set @BuyerId = Userid;
		-- declare @SellerId as varchar(255)
		-- declare @SellerOrderId as varchar(255)
		-- declare @Balance as bigint
		-- declare @TradedAmount as bigint
		set @B_QtyRemaining = amountoutstanding;
		-- declare @S_QtyRemaining as bigint
		-- declare @S_Complete as Bit

		
		set @buyasset  = case when buysell = 'BUY' then quoteasset else baseasset end;
		set @sellasset = case when buysell = 'BUY' then baseasset else quoteasset end;
		
		-- Update balances set amountavailable = amount-amount where asset = @sellasset and userid = @BuyerId;
		set @hasresult = 1;
		

		
		IF buysell = 'buy' THEN BEGIN
		select  1, S_QtyRemaining, S_Id,S_userid, case when @B_QtyRemaining >= S_QtyRemaining then  S_QtyRemaining else @B_QtyRemaining end, case when @B_QtyRemaining >= S_QtyRemaining then  1 else 0 end, S_rate INTO @hasresult, @S_QtyRemaining,@SellerOrderId,@SellerId,@TradedAmount,@S_Complete,@S_rate
		from (select 
			S.Id as S_Id, 
			S.userid as S_userid, 
			S.amountoutstanding as S_QtyRemaining,
			S.rate as S_rate
			from orders as S 				
				Where S.Status = 'ACTIVE' and  S.rate * case when buysell = 'BUY' then 1 else -1 end >= rate  * case when buysell = 'BUY' then 1 else -1 end and s.market = market and ( (buysell = 'BUY' and s.buysell = 'SELL') or  (buysell = 'SELL' and s.buysell = 'BUY'))
				Order by  S.rate desc, S.dt Limit 1)c for update;
		END; ELSE BEGIN
		select  1, S_QtyRemaining, S_Id,S_userid, case when @B_QtyRemaining >= S_QtyRemaining then  S_QtyRemaining else @B_QtyRemaining end, case when @B_QtyRemaining >= S_QtyRemaining then  1 else 0 end, S_rate INTO @hasresult,  @S_QtyRemaining,@SellerOrderId,@SellerId,@TradedAmount,@S_Complete,@S_rate
		from (select 
			S.Id as S_Id, 
			S.userid as S_userid, 
			S.amountoutstanding as S_QtyRemaining,
			S.rate as S_rate
			from orders as S 				
				Where S.Status = 'ACTIVE' and  S.rate * case when buysell = 'BUY' then 1 else -1 end >= rate  * case when buysell = 'BUY' then 1 else -1 end and s.market = market and ( (buysell = 'BUY' and s.buysell = 'SELL') or  (buysell = 'SELL' and s.buysell = 'BUY'))
				Order by  S.rate asc, S.dt Limit 1)c for update;	
		END;
		END IF;

		
		while @B_QtyRemaining > 0 and @S_QtyRemaining is not null and  @S_QtyRemaining > 0 and @hasresult = 1 do
		  begin
		  insert into log (text) values (@SellerOrderId);		  
		  insert into log (text) values (@B_QtyRemaining);
		  insert into log (text) values (@S_QtyRemaining);
		  insert into log (text) values (@TradedAmount);
		-- select @TradedAmount;
		  Update balances set balances.amount = balances.amount+@TradedAmount / (case when buysell = 'SELL' then @S_rate else 1 end) where balances.asset = @buyasset and balances.userid = @BuyerId;
		  Update balances set balances.amount = balances.amount-@TradedAmount / (case when buysell = 'SELL' then 1 else @S_rate end) where balances.asset = @sellasset and balances.userid = @BuyerId;
		  
		  
		  Update balances set balances.amount = balances.amount-@TradedAmount / (case when buysell = 'SELL' then @S_rate else 1 end) where balances.asset = @buyasset and balances.userid = @SellerId;
		  Update balances set balances.amount = balances.amount+@TradedAmount / (case when buysell = 'SELL'  then 1 else @S_rate end) where balances.asset = @sellasset and balances.userid = @SellerId;
		  
		  SET amountgained = amountgained + coalesce(@TradedAmount * 1/@S_rate,0);
		  
		  SET @S_QtyRemaining = @S_QtyRemaining - @TradedAmount;
		  
		  if @S_QtyRemaining < minamount then
		  begin	  
		   insert into `orders-archive`(`id`, `userid`, `market`, `buysell`, `baseasset`, `quoteasset`, `amount`, `amountoutstanding`, `amountgained`, `minamount`, `rate`, `status`) SELECT o.id ,
				 o.userid ,
				 o.market ,
				 o.buysell ,
					o.baseasset,
					o.quoteasset,
				 o.amount ,
				 @S_QtyRemaining,
				 o.amountgained+coalesce(@TradedAmount * 1/@S_rate,0)  end,
				 o.minamount,
				 o.rate,
				 case when @S_Complete = 1 then'COMPLETE' else 'COMPLETE (QTY REMAINING IS TOO LOW)' end
				 from orders o WHERE o.id = @SellerOrderId;
		   delete from orders WHERE orders.id = @SellerOrderId;
		  end;
		  else
		  begin


			  update orders o
			  set o.amountoutstanding = o.amountoutstanding-@TradedAmount, o.amountgained = o.amountgained+@TradedAmount * case when o.buysell = 'SELL' then 1/@S_rate else @S_rate end
			   where o.`Id` = @SellerOrderId;

		  end;
		  end if;
		  
		  Set @B_QtyRemaining = @B_QtyRemaining - @TradedAmount;

		SET @hasresult = 0;
		IF buysell = 'buy' THEN BEGIN
		select 1, S_QtyRemaining, S_Id,S_userid, case when @B_QtyRemaining >= S_QtyRemaining then  S_QtyRemaining else @B_QtyRemaining end, case when @B_QtyRemaining >= S_QtyRemaining then  1 else 0 end, S_rate INTO @hasresult,  @S_QtyRemaining,@SellerOrderId,@SellerId,@TradedAmount,@S_Complete,@S_rate
		from (select 
			S.Id as S_Id, 
			S.userid as S_userid, 
			S.amountoutstanding as S_QtyRemaining,
			S.rate as S_rate
			from orders as S 				
				Where S.Status = 'ACTIVE' and  S.rate * case when buysell = 'BUY' then 1 else -1 end >= rate  * case when buysell = 'BUY' then 1 else -1 end and s.market = market and ( (buysell = 'BUY' and s.buysell = 'SELL') or  (buysell = 'SELL' and s.buysell = 'BUY'))
				Order by  S.rate desc, S.dt Limit 1)c for update;
		END; ELSE BEGIN
		select 1, S_QtyRemaining, S_Id,S_userid, case when @B_QtyRemaining >= S_QtyRemaining then  S_QtyRemaining else @B_QtyRemaining end, case when @B_QtyRemaining >= S_QtyRemaining then  1 else 0 end, S_rate INTO @hasresult, @S_QtyRemaining,@SellerOrderId,@SellerId,@TradedAmount,@S_Complete,@S_rate
		from (select 
			S.Id as S_Id, 
			S.userid as S_userid, 
			S.amountoutstanding as S_QtyRemaining,
			S.rate as S_rate
			from orders as S 				
				Where S.Status = 'ACTIVE' and  S.rate * case when buysell = 'BUY' then 1 else -1 end >= rate  * case when buysell = 'BUY' then 1 else -1 end and s.market = market and ( (buysell = 'BUY' and s.buysell = 'SELL') or  (buysell = 'SELL' and s.buysell = 'BUY'))
				Order by  S.rate asc, S.dt Limit 1)c for update;	
		END;		
		END IF;

		end;
	  end while;

		  if @B_QtyRemaining < minamount then begin
		  
			   -- insert into `orders-archive` SELECT id ,
					 -- userid ,
					 -- market ,
					 -- buysell,
					 -- baseasset,
					 -- quoteasset,
					 
					 -- amount,
					 -- 0,
					 -- 'COMPLETE',
					 -- dt from orders WHERE id = id;
			   INSERT INTO `orders-archive` (`id`, `userid`, `market`, `buysell`, `baseasset`, `quoteasset`, `amount`, `amountoutstanding`, `amountgained`, `minamount`, `rate`, `status`) VALUES (id,userid,market,buysell,baseasset,quoteasset,amount,@B_QtyRemaining,amountgained  ,minamount,rate,case when @B_QtyRemaining = 0 then "COMPLETE" ELSE "COMPLETE (QTY REMAINING IS TOO LOW)" END);

		  end;
		  else begin
		  			   INSERT INTO `orders` (`id`, `userid`, `market`, `buysell`, `baseasset`, `quoteasset`, `amount`, `amountoutstanding`, `amountgained`, `minamount`, `rate`, `status`) VALUES (id,userid,market,buysell,baseasset,quoteasset,amount,@B_QtyRemaining,amountgained,minamount,rate,"ACTIVE");

		  end;
		  end if;
		  
		 COMMIT;
    END
$$
DELIMITER ;



