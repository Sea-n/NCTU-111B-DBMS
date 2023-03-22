DROP TABLE IF EXISTS games;
CREATE TABLE games (
    Game int NOT NULL,
    away char(3) NOT NULL,
    home char(3) NOT NULL,
    away_score tinyint,
    home_score tinyint,
    Date datetime NOT NULL,
    PRIMARY KEY (Game)
);


DROP TABLE IF EXISTS inning;
CREATE TABLE inning (
    Game int NOT NULL REFERENCES games(Game),
    Inning char(3) NOT NULL,
    Runs tinyint,
    Hits tinyint,
    Errors tinyint,
    PRIMARY KEY (Game, Inning)
);


DROP TABLE IF EXISTS hitters;
CREATE TABLE hitters (
    Game int NOT NULL REFERENCES games(Game),
    Team char(3) NOT NULL,
    AB tinyint,
    R tinyint,
    H tinyint,
    RBI tinyint,
    BB tinyint,
    K tinyint,
    num_P tinyint,
    Position varchar(20),
    Hitter_Id mediumint NOT NULL,
    PRIMARY KEY (Game, Hitter_Id)
);


DROP TABLE IF EXISTS pitchers;
CREATE TABLE pitchers (
    Game int NOT NULL REFERENCES games(Game),
    Team char(3) NOT NULL,
    IP float,
    H tinyint,
    R tinyint,
    ER tinyint,
    BB tinyint,
    K tinyint,
    HR tinyint,
    PC_ST varchar(10),
    Pitcher_Id mediumint NOT NULL,
    PRIMARY KEY (Game, Pitcher_Id)
);


DROP TABLE IF EXISTS pitches;
CREATE TABLE pitches (
    Pitch_Id mediumint NOT NULL,
    Game int NOT NULL REFERENCES games(Game),
    EventId smallint NOT NULL,
    Num tinyint NOT NULL,
    Inning char(3),
    Pitcher varchar(35),
    Pitch varchar(50),
    _Type varchar(20),
    MPH smallint,
    PRIMARY KEY (Pitch_Id)
);


DROP TABLE IF EXISTS players;
CREATE TABLE players (
    Id mediumint NOT NULL,
    Name varchar(20),
    PRIMARY KEY (Id)
);