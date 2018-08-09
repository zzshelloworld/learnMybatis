DROP PROCEDURE IF EXISTS `select_user_by_id`;
delimiter ;;
CREATE PROCEDURE `select_user_by_id`(
    IN userId BIGINT,
    OUT userName VARCHAR(50),
    OUT userPassword VARCHAR(50),
    OUT userEmail VARCHAR(50),
    OUT userInfo TEXT,
    OUT headImg BLOB ,
    OUT createTime DATETIME)
BEGIN
    #根据用户id 查询其他数据
    select user_name, user_password, user_email, user_info, head_img, create_time
    INTO userName, userPassword, userEmail, userInfo, headImg, createTime
    from sys_user
    WHERE id = userId;
END
;;
delimiter ;

DROP PROCEDURE IF EXISTS `select_user_page`;
DELIMITER ;;
CREATE PROCEDURE `select_user_page`(
    IN userName VARCHAR(50),
    IN _offset BIGINT,
    IN _limit BIGINT,
    OUT total BIGINT)
BEGIN
    #查询数据总数
    select count(*) INTO total
    from sys_user
    where user_name like concat ('%', userName, '%');
    #分页查询数据
    select *
    from sys_user
    where user_name like concat('%', userName, '%')
    limit _offset, _limit;
END
;;
DELIMITER ;


DROP PROCEDURE IF EXISTS `insert_user_and_roles`;
DELIMITER ;;
CREATE PROCEDURE `insert_user_and_roles`(
    OUT userId BIGINT,
    IN userName VARCHAR(50),
    IN userPassword VARCHAR(50),
    IN userEmail VARCHAR(50),
    IN userInfo TEXT,
    IN headImg BLOB,
    OUT createTime DATETIME,
    IN roleIds VARCHAR(200)
)
BEGIN
    #设直当前时间
    SET createTime = NOW() ;
    #插入数据
    INSERT INTO sys_user(user_name, user_password, user_email, user_info,
        head_img, create_time)
    VALUES (userName, userPassword, userEmail, userInfo, headImg , createTime);
    #获取自增主键
    SELECT LAST_INSERT_ID() INTO userId ;
    #保存用户和角色关系数据
    SET roleIds = CONCAT(',',roleIds,',');
    INSERT INTO sys_user_role(user_id , role_id)
    select userId, id from sys_role
    where INSTR(roleIds, CONCAT(',',id,',')) > 0;
END
;;
DELIMITER ;


DROP PROCEDURE IF EXISTS `delete_user_by_id`;
DELIMITER ;;
CREATE PROCEDURE `delete_user_by_id`(IN userId BIGINT)
BEGIN
    DELETE FROM sys_user_role where user_id = userId ;
    DELETE FROM sys_user where id = userId ;
END
;;
DELIMITER ;
