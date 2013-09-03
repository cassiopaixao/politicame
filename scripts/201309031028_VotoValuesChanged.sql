UPDATE `voto_deputados` SET `voto`= -2 WHERE `voto` = 2;
UPDATE `voto_deputados` SET `voto`= 2 WHERE `voto` = 1;
UPDATE `voto_deputados` SET `voto`= -1 WHERE `voto` = 3;
UPDATE `voto_deputados` SET `voto`= 0 WHERE `voto` = 4;
UPDATE `voto_deputados` SET `voto`= 0 WHERE `voto` = 0;
UPDATE `voto_users` SET `voto`= -1 WHERE `voto` = 2;
