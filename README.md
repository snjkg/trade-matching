# Trade Matching
## Background
In a typical securities market, participants can place orders to buy or sell a particular quantity of a security for a particular price. The order is listed in an order book. The order book lists all the price and quantities of all orders. At any time, if within the order book, there is a buy order with a price greater than a sell order the participants of the orders are matched and the order is removed from the order book.

## Usage
Requirements: PostgreSql

1. Run setup.sql
2. Run match-trade.sql
3. Run cancel-trade.sql
4. Use the orders_match and orders_cancel procedures to create and delete orders.
