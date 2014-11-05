imganalysis
===========

Softwarepraktikum Bildverarbeitung

## TODO

find_marks:
	- Löcher schließen
	- threshold = 12 
	- Koordinaten sortieren:  [oben links; oben rechts; unten rechts; unten links]


## Funktionsübersicht:

gui
	-Lädt ein gui mit dem man die ecbp Funktion dynamisch auf alle Bilder im Trainingsfolder anwenden kann



backgroundSubtraction( Image, threshold)
	-Lädt das Bild Image, wendet einen threshold darauf an und gibt ein Binärbild x*y*1 zurück



ecbp( Image, channel, threshold )
	-Lädt das Bild Image, lässt alle Pixel deren Farbwert der Kanals channel jeweils um threshold größer ist als die Farbwerte der 2 anderen Kanäle und löscht die restlichen Pixel.



...
