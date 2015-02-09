--read data

relation_user_friends = LOAD 'user-links-small.txt' AS (user:int , friend:int);
relation_user_wallposts = LOAD 'user-wall-small.txt' AS (user:int , friend:int, time_wallpost:long);


--group users and wall posts by user

relation_grouped_user_friends = GROUP relation_user_friends  by user;
relation_grouped_user_wallposts = GROUP relation_user_wallposts by user;

-- count the  number of friends for each user
count_user_links = FOREACH relation_grouped_user_friends GENERATE $0 as user , COUNT($1) as friends;

-- count the number of wallposts of each user

count_wall_posts = FOREACH relation_grouped_user_wallposts GENERATE $0 as user , COUNT($1) as wallposts;

--join the above data on user

relation_join_user_friends_wallposts = JOIN count_user_links by $0,count_wall_posts by $0;

--generate users , number of friends and number of wallposts

relation_user_friends_wallposts = FOREACH relation_join_user_friends_wallposts GENERATE $0 as user, $1 as friends, $3 as wallposts;

--group by number of friends

relation_group_by_friends = GROUP relation_user_friends_wallposts by friends;

--generate number of wall posts for 'n' friends

relation_friends_users_wallposts = FOREACH relation_group_by_friends GENERATE $0 as friends,relation_user_friends_wallposts.user as user, relation_user_friends_wallposts.wallposts as wallposts;

--generate average wall posts for users with 'n' friends

average_wall_posts = FOREACH relation_friends_users_wallposts GENERATE $0 as friends , (double)SUM(wallposts)/COUNT(user) as average_wallposts;

STORE average_wall_posts into 'question-2';

