--read data from the input dataset
relation_user_friends = LOAD 'user-links-small.txt' AS (user:int , friend:int);

--group by user
relation_grouped_user_friends = GROUP relation_user_friends BY user;

-- count number of friends for each user
relation_count_friends = FOREACH relation_grouped_user_friends GENERATE $0 as user, COUNT($1) as friends;


--For no of users with 'n'friends, group by no of friends
relation_group_by_friends = GROUP relation_count_friends by $1  ;

--count the number of users with 'n' friends
relation_degree_node = FOREACH relation_group_by_friends GENERATE $0 as num_of_friends,COUNT($1) as num_of_users;

--sort the result in the increasing order of degree-node
relation_degree_node_sorted_by_friends = ORDER relation_degree_node by $0 asc;

--save in a file
STORE  relation_degree_node_sorted_by_friends INTO 'question-1';
~                                                                    
