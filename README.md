imganalysis
===========

Softwarepraktikum Bildverarbeitung

## TODO

find_marks:
	- L�cher schlie�en
	- threshold = 12 
	- Koordinaten sortieren:  [oben links; oben rechts; unten rechts; unten links]


## Funktions�bersicht:

gui
	-L�dt ein gui mit dem man die ecbp Funktion dynamisch auf alle Bilder im Trainingsfolder anwenden kann



backgroundSubtraction( Image, threshold)
	-L�dt das Bild Image, wendet einen threshold darauf an und gibt ein Bin�rbild x*y*1 zur�ck



ecbp( Image, channel, threshold )
	-L�dt das Bild Image, l�sst alle Pixel deren Farbwert der Kanals channel jeweils um threshold gr��er ist als die Farbwerte der 2 anderen Kan�le und l�scht die restlichen Pixel.



...
