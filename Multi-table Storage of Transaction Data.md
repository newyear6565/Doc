# Multi-table Storage of Transaction Data

## 1. Project Introduction
&ensp;&ensp;&ensp;&ensp;Accounts, transactions, events and other data are stored in the rocksdb database.The way to read and write these data is through the Trie structure.

&ensp;&ensp;&ensp;&ensp;For example, when receiving a new block, for the verification and writing of the transaction data, it is necessary to find the transaction Trie root of the previous block, and then insert the data into the Trie in a certain manner.

&ensp;&ensp;&ensp;&ensp;The process of inserting needs to involve reading and processing the data of each node on the Trie path.In the process of data reading, since the historical data is too large in a data table,And the data stored by rocksdb is likely to be sorted to a deeper level, resulting in data reading will take a long time, which is not conducive to the overall performance of the system.

&ensp;&ensp;&ensp;&ensp;Therefore, we proposed this project to write the newly generated data into a new data table, in an effort to reduce the data reading time, thereby improving the overall performance of the system.

## 2. Project Objectives
&ensp;&ensp;&ensp;&ensp;For the latest data, a new data table is allocated for storage. As the reason for the project introduced above, we need to reduce the data reading time by using the multi-table to improve the overall performance of the system. It is expected that the overall performance will be improved by 15% through the multi-table, and it is expected to increase the TPS by 15%.

## 3. Project Implementation
**3.1** For events and txs data, it is clear that most of the operations are to read and write the latest data, while the accounts data is not the same, such as the existence of the cold wallet, it is very likely that the situation is to save to the wallet a sum of nas, and after several years to perform the Money withdrawal operation. This situation cause the reading of the accounts data is unpredictable. Therefore, we currently only divide the events and the tx data, divide a new Trie root every 1 million blocks, and separate a new data table to store lastest events and tx data. (For the number of block partitions, this data needs a lot of further testing, initially set to 1 million blocks, and can be configured through the configuration file)

**3.2** Store each Trie root and order relationship, convenient for backtracking query

**3.3** Insert the new txs and events data into the new Trie. For external query requests, first query the new Trie. If the data is not exist, query the previous Trie tree.

**3.4** For the **GET** operation, firstly query the latest data table, if the data is not exist, query the previous table; For the **PUT** operation, all put into the latest table; For the **DEL** operation, first do **GET** operation to find data is in which table, then execute the **DEL** operation in the specified table

**3.5** In order to ensure the stability of the system and the purpose of fast data query, the data storage has certain redundancy. For example, when the height is 1 million, the transaction and the event data generated by the latter 200,000 heights are simultaneously stored in the old table and the new table respectively. The request for the query is still to query the data from the old table. When it reaches the height of 1.2 million, the root of the Trie is switched to the new root and the data is queried from the new table. Initially set 200,000 of this, the better value needs further testing, and can be written to the configuration file for configuration.