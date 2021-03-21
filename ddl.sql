CREATE DATABASE `play_ball` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

-- https://docs.spring.io/spring-batch/docs/3.0.x/reference/html/metaDataSchema.html
CREATE TABLE play_ball.batch_JOB_INSTANCE
(
    JOB_INSTANCE_ID BIGINT       NOT NULL PRIMARY KEY,
    VERSION         BIGINT,
    JOB_NAME        VARCHAR(100) NOT NULL,
    JOB_KEY         VARCHAR(32)  NOT NULL,
    constraint JOB_INST_UN unique (JOB_NAME, JOB_KEY)
) ;

CREATE TABLE play_ball.batch_JOB_EXECUTION
(
    JOB_EXECUTION_ID           BIGINT        NOT NULL PRIMARY KEY,
    VERSION                    BIGINT,
    JOB_INSTANCE_ID            BIGINT        NOT NULL,
    CREATE_TIME                DATETIME      NOT NULL,
    START_TIME                 DATETIME DEFAULT NULL,
    END_TIME                   DATETIME DEFAULT NULL,
    STATUS                     VARCHAR(10),
    EXIT_CODE                  VARCHAR(2500),
    EXIT_MESSAGE               VARCHAR(2500),
    LAST_UPDATED               DATETIME,
    JOB_CONFIGURATION_LOCATION VARCHAR(2500) NULL,
    constraint JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
        references play_ball.batch_JOB_INSTANCE (JOB_INSTANCE_ID)
) ;

CREATE TABLE play_ball.batch_JOB_EXECUTION_PARAMS
(
    JOB_EXECUTION_ID BIGINT       NOT NULL,
    TYPE_CD          VARCHAR(6)   NOT NULL,
    KEY_NAME         VARCHAR(100) NOT NULL,
    STRING_VAL       VARCHAR(250),
    DATE_VAL         DATETIME DEFAULT NULL,
    LONG_VAL         BIGINT,
    DOUBLE_VAL       DOUBLE PRECISION,
    IDENTIFYING      CHAR(1)      NOT NULL,
    constraint JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
        references play_ball.batch_JOB_EXECUTION (JOB_EXECUTION_ID)
) ;

CREATE TABLE play_ball.batch_STEP_EXECUTION
(
    STEP_EXECUTION_ID  BIGINT       NOT NULL PRIMARY KEY,
    VERSION            BIGINT       NOT NULL,
    STEP_NAME          VARCHAR(100) NOT NULL,
    JOB_EXECUTION_ID   BIGINT       NOT NULL,
    START_TIME         DATETIME     NOT NULL,
    END_TIME           DATETIME DEFAULT NULL,
    STATUS             VARCHAR(10),
    COMMIT_COUNT       BIGINT,
    READ_COUNT         BIGINT,
    FILTER_COUNT       BIGINT,
    WRITE_COUNT        BIGINT,
    READ_SKIP_COUNT    BIGINT,
    WRITE_SKIP_COUNT   BIGINT,
    PROCESS_SKIP_COUNT BIGINT,
    ROLLBACK_COUNT     BIGINT,
    EXIT_CODE          VARCHAR(2500),
    EXIT_MESSAGE       VARCHAR(2500),
    LAST_UPDATED       DATETIME,
    constraint JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
        references play_ball.batch_JOB_EXECUTION (JOB_EXECUTION_ID)
) ;

CREATE TABLE play_ball.batch_STEP_EXECUTION_CONTEXT
(
    STEP_EXECUTION_ID  BIGINT        NOT NULL PRIMARY KEY,
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
        references play_ball.batch_STEP_EXECUTION (STEP_EXECUTION_ID)
) ;

CREATE TABLE play_ball.batch_JOB_EXECUTION_CONTEXT
(
    JOB_EXECUTION_ID   BIGINT        NOT NULL PRIMARY KEY,
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
        references play_ball.batch_JOB_EXECUTION (JOB_EXECUTION_ID)
) ;

CREATE TABLE play_ball.batch_STEP_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ;

INSERT INTO play_ball.batch_STEP_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from play_ball.batch_STEP_EXECUTION_SEQ);

CREATE TABLE play_ball.batch_JOB_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ;

INSERT INTO play_ball.batch_JOB_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from play_ball.batch_JOB_EXECUTION_SEQ);

CREATE TABLE play_ball.batch_JOB_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ;

INSERT INTO play_ball.batch_JOB_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from play_ball.batch_JOB_SEQ);



CREATE TABLE play_ball.game (
  `id` varchar(12) NOT NULL,
  `site` varchar(5) DEFAULT NULL,
  `home_team` varchar(3) DEFAULT NULL,
  `visiting_team` varchar(3) DEFAULT NULL,
  `date` varchar(8) DEFAULT NULL,
  `day_night` char(1) DEFAULT NULL,
  `game_num` int DEFAULT NULL,
  `year` int NOT NULL,
  `game_type` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE play_ball.player (
  `id` varchar(8) NOT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `bats` char(1) DEFAULT NULL,
  `pitches` char(1) DEFAULT NULL,
  `team_id` varchar(3) not NULL,
  `year` int NOT NULL,
  PRIMARY KEY (`id`, `team`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `play_ball`.`game_player` (
  `game_id` VARCHAR(12) NOT NULL,
  `player_id` VARCHAR(8) NOT NULL,
  `start_sub` INT NOT NULL,
  `visit_home` INT NOT NULL,
  `batting_order` INT NOT NULL,
  `field_position` int NOT NULL,
  `offense_defense` int NULL, 
    PRIMARY KEY (`game_id`, `player_id`),
    FOREIGN KEY (`game_id`) REFERENCES `play_ball`.`game`(`id`),
    FOREIGN KEY (`player_id`) REFERENCES `play_ball`.`player`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE play_ball.team (
	id	varchar(3) NOT NULL,
    league_id char(1) NOT NULL,
    name varchar(45) NOT NULL,
    city varchar(45) NOT NULL,
    year int NOT NULL,
    game_type char(1),
    PRIMARY KEY (id, year, game_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE play_ball.lookup (
	data_type varchar(25) NOT NULL,
    data_code varchar(10) NOT NULL,
    data_text varchar(25) not null,
    PRIMARY KEY (data_type, data_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE play_ball.disclaimer (
	line_num int NOT NULL,
    line_text varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    
---- ALTER TABLE play_ball.game_player ADD PRIMARY KEY (game_id, player_id, start_sub, batting_order, field_position)    ;

CREATE INDEX idx_gameID
ON play_ball.game_player (game_id);

CREATE INDEX idx_playerID
on play_ball.game_player (player_id);

CREATE INDEX idx_gameID_player_ID
on play_ball.game_player (game_id, player_id);

CREATE INDEX idx_player_playerID
on play_ball.player (id);

CREATE INDEX idx_game_gameID
on play_ball.game (id);

CREATE INDEX idx_team_teamID
on play_ball.team (id);

CREATE INDEX idx_player_playerID_teamID
on play_ball.player (id, team_id);

CREATE INDEX idx_player_playerID_teamID_year
on play_ball.player (id, team_id, year);

CREATE INDEX idx_lookup
on play_ball.lookup (data_type, data_code);