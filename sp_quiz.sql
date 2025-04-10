/*Build a multiplayer quiz system:
Two players join a session and answer the same questions.
Tracks time taken + correctness.
API decides the winner and stores the score.*/

--tables required for sp
create table Players (
PlayerID INT primary key,
PlayerName varchar(100)
);

insert into Players (PlayerID, PlayerName) values
(1, 'Amol'),
(2, 'Amar');

create table Questions (
QuestionID INT primary key,
QuestionText varchar(255),
CorrectAnswer varchar(100)
);

insert into Questions (QuestionID, QuestionText, CorrectAnswer) values
(1, 'What is the capital of Maharashtra?', 'Mumbai'),
(2, 'What is 2 + 2?', '4'),
(3, 'What is the largest planet in our solar system?', 'Jupiter');


create table Answers (
AnswerID INT primary key identity(1,1),
PlayerID INT,
QuestionID INT,
AnswerText varchar(100),
TimeTaken INT,
foreign key (PlayerID) references Players(PlayerID),
foreign key (QuestionID) references Questions(QuestionID)
);


create table Scores (
ScoreID INT primary key identity(1,1),
PlayerID INT,
TotalScore INT,
foreign key (PlayerID) references Players(PlayerID)
);

create procedure ProcessQuizResult
@Player1ID INT,
@Player2ID INT
AS
begin
declare @TotalScore1 INT = 0;
declare @TotalScore2 INT = 0;

--temporary table for answers and times
create table #Answers (
PlayerID INT,
QuestionID INT,
AnswerText varchar(100),
TimeTaken INT
);

--insert answers for Player 1
insert into #Answers (PlayerID, QuestionID, AnswerText, TimeTaken)
VALUES
(@Player1ID, 1, 'Mumbai', 10),
(@Player1ID, 2, '4', 5),    
(@Player1ID, 3, 'Jupiter', 15);

-- Insert answers for Player 2
insert into #Answers (PlayerID, QuestionID, AnswerText, TimeTaken)
VALUES
(@Player2ID, 1, 'Pune', 12),
(@Player2ID, 2, '4', 6),      
(@Player2ID, 3, 'Jupiter', 14);

--scores for Player 1
SELECT @TotalScore1 = COUNT(*)
FROM #Answers A
JOIN Questions Q ON A.QuestionID = Q.QuestionID
WHERE A.PlayerID = @Player1ID AND A.AnswerText = Q.CorrectAnswer;

--scores for Player 2
select @TotalScore2 = COUNT(*)
FROM #Answers A
JOIN Questions Q ON A.QuestionID = Q.QuestionID
WHERE A.PlayerID = @Player2ID AND A.AnswerText = Q.CorrectAnswer;

--store scores in the Scores table
insert into Scores (PlayerID, TotalScore)
VALUES 
(@Player1ID, @TotalScore1),
(@Player2ID, @TotalScore2);

--deciding the winner
declare @WinnerID INT;
IF @TotalScore1 > @TotalScore2
SET @WinnerID = @Player1ID;
ELSE IF @TotalScore2 > @TotalScore1
SET @WinnerID = @Player2ID;
ELSE
SET @WinnerID = NULL; 

-- Return results
select
@TotalScore1 AS Player1Score,
@TotalScore2 AS Player2Score,
@WinnerID AS WinnerID;

drop table #Answers;
END;

--execute the sp
EXEC ProcessQuizResult @Player1ID = 1, @Player2ID = 2;