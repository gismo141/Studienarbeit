
# Vom Objektcode zur LLVM-IR

Wenn ein Programm nur in Form einer ausführbaren Datei ohne Quellcode vorliegt, kann es nur sehr schwer von Menschen analysiert werden. Analog zum Kompilieren muss das Programm von einer maschinennahen Repräsentation in eine vom Menschen lesbare Version dekompiliert werden. Dieser Prozess ist sehr schwierig, da die maschinennahen Instruktionen sequentiell sind; sie entsprechen einer Art Rezept, das vom Prozessor abgearbeitet wird.

Damit dieser Code in eine strukturierte Version übersetzt werden kann, sind genaue Kenntnisse über die Prozessorarchitektur, den verwendeten Compiler und die Bibliotheken erforderlich. Sind einige dieser Informationen fehlerhaft oder unbekannt, müssen Annahmen getroffen werden. Dadurch kann der übersetzte Code fehlerhaft sein. Ebenfalls wichtig ist, nach welchen Prinzipien die Dekompilierung durchgeführt wird. Einerseits kann der Objektcode von oben nach unten ge-*parsed* (gelesen) werden, andererseits kann der Objektcode ausgeführt und währenddessen analysiert werden.

Im Kapitel \ref{vorteile-durch-die-verwendung-von-llvm} wurden einige Vorteile erläutert, die die Verwendung von \gls{LLVM}-\gls{IR} als "Zwischensprache" bietet. Im Folgenden werden einige aktuelle Projekte vorgestellt, die sich mit der Dekompilierung von Objektcode in \gls{LLVM}-\gls{IR} auseinandersetzen und verschiedene Lösungsansätze bieten.

## Das Projekt *Dagger*

*Dagger* baut auf der \gls{LLVM}-Projektstruktur auf. Der Ansatz von *Dagger* entspricht einem *recursive traversal disassembler*. Gemäß @Bougacha2013 entspricht *Dagger* damit der Arbeitsweise des IDA Pro Disassemblers. Ein *recursive traversal disassembler* betrachtet den vorliegenden Binärcode nicht zeilenweise, er analysiert die Maschinenbefehle und führt dabei auftretende Sprungbefehle aus. Ein Sprung kann zum Beispiel an eine Adresse im Speicher verweisen, an der offensichtlich keine Funktion beginnt. Springt nun der Disassembler von *Dagger* an diese Adresse, wird der Binärcode ab dieser Adresse komplett neu analysiert. Ein herkömmlicher Disassembler wie `objdump` würde dabei nur auf einen für ihn fehlerhaften Code stoßen und die Disassemblierung abbrechen.

+----------------+------------------------+-----------------------------+
|      x86       |          Mir           |              IR             |
+================+========================+=============================+
|                | `...`                  | `...`                       |
| `sub ebx, ecx` | `sub %td2, ...`        | `%ebx2 = sub i32 ...`       |
|                | `put EBX, %td2`        |                             |
+----------------+------------------------+-----------------------------+
|                | `get %td0, EBX`        |                             |
|                | `mov %td1, 12`         |                             |
| `add ebx, 12`  | `add %td2, %td0, %td1` | `%ebx3 = add i32 %ebx2, 12` |
|                | `put EBX, %td2`        |                             |
+----------------+------------------------+-----------------------------+

Table: Generation von IR Code über die Zwischensprache Mir [@Bougacha2013: S. 43]\label{tab:generation-von-ir-code-über-die-zwischensprache-mir}

Durch *Dagger* ist es möglich, nur die Maschinenanweisungen zu disassemblieren, die bei der Abarbeitung des Objektcodes ausgeführt werden und diese anschließend in \gls{LLVM}-\gls{IR}-Code zu dekompilieren. Um dies zu ermöglichen, verwendet *Dagger* die "Zwischensprache" *Mir*, in der die gesammelten Informationen (Symboltabellen, Sprungtabellen, Registerbenennungen etc.) aufbereitet und verknüpft werden. Gemäß Tabelle \ref{tab:generation-von-ir-code-über-die-zwischensprache-mir} wird beispielhaft der \gls{LLVM}-\gls{IR}-Code aus 2 Assembler-Befehlen rekonstruiert. Dabei werden die Register möglichen Variablen zugeordnet, die durch den Kontrollfluss am wahrscheinlichsten sind. 

Durch die Zuweisung von Registern zu Variablen wird der generierte \gls{LLVM}-Code stark vergrößert. Listing \ref{lst:llvm-von-obj-mit-dagger} zeigt das Resultat der Dekompilierung der `main.out`-Datei aus Abschnitt \ref{entwicklung-eines-beispiel-programms-und-kompilierung-mit-llvm}, das mit dem Programm `llvm-dec` aus dem Projekt *Dagger* generiert wurde. Es ist eindeutig der Mehranteil an Code im Verhältnis zum direkt-kompilierten \gls{LLVM}-\gls{IR} aus Listing \ref{lst:llvm-von-c} zu erkennen.

Die Entwickler von *Dagger* organisieren das Projekt nicht als eigenständiges Projekt von \gls{LLVM}, sondern integrieren es direkt in den Quellcode. Das hat einen entscheidenden Nachteil: solange *Dagger* nicht erfolgreich in \gls{LLVM} übernommen wurde, muss der Anwender zwei getrennte Installationen des kompletten \gls{LLVM}-Projekts ((1) die von *Dagger* unterstützte Version und (2) die aktuelle offizielle Version) bereithalten.

### Die Installation von *Dagger*

Da es sich bei *Dagger* um eine Weiterentwicklung des \gls{LLVM}-Quellcodes handelt, muss die komplette \gls{LLVM}-Suite heruntergeladen und kompiliert werden. Listing \ref{lst:installation-von-dagger} zeigt die dazu notwendigen Schritte.

\begin{code}
\begin{minted}[linenos]{bash}
# Setzen des Installationspfades
export DESTINATION=$HOME/Developer
# Herunterladen des Quellcodes
git clone http://repzret.org/git/dagger.git $DESTINATION/dagger
# Zum geklonten Verzeichnis wechseln
cd $DESTINATION/dagger
# Erstellen eines build-Verzeichnis
mkdir build && cd build
# Kompilieren von Dagger
cmake .. && make
\end{minted}
\caption{Installation von \textit{Dagger}}
\label{lst:installation-von-dagger}
\end{code}

### Kritik an der Verwendung von *Dagger*

Das Projekt *Dagger* hat einige Nachteile in seiner Umsetzung, die seine Verwendung verkomplizieren. Mit dem Installationspaket wird keine Dokumentation mitgeliefert, die erläutert, wie *Dagger* angewendet werden sollte. *Dagger* wurde direkt in die jeweiligen \gls{LLVM}-Unterprogramme integriert, wodurch zunächst die jeweiligen Programme und die dafür benötigten Übergabeparameter in der Dokumentation der jeweiligen \gls{LLVM}-Programme gefunden werden müssen. Dies ist ein sehr mühsamer Prozess, der viel Zeit in Anspruch nimmt. Ebenfalls fehlen wissenschaftliche Veröffentlichungen zur Erläuterung der Struktur von *Dagger*.

Bei der Verwendung von *Dagger* sind folgende Schwierigkeiten aufgetreten:

1. Die Dekompilierung schlägt teilweise fehl, weil noch nicht alle Instruktionen, die die x86-Architektur zur Verfügung stellt, in *Dagger* implementiert wurden;
2. Die dekompilierten \gls{LLVM}-\gls{IR}-Codes unterscheiden sich grundlegend vom ursprünglichen \gls{LLVM}-\gls{IR}-Code. Es war nicht möglich, festzustellen, ob es sich dabei um das gleiche Programm handelt. Die erneute Kompilierung des generierten \gls{LLVM}-\gls{IR}-Codes schlug aufgrund fehlerhafter Metainformationen fehl.

Ein weiteres Problem am Projekt *Dagger* ist eine unklare Veröffentlichungsstruktur. Ursprünglich war *Dagger* nicht als *open-source*-Projekt geplant. Auf Drängen der \gls{LLVM}-Community wurde der Quellcode auf der Webseite des Projekts veröffentlicht. Es handelt sich dabei um ein privates git-Repository (siehe \url{http://dagger.repzret.org}), das nur stückweise aktualisiert wird. Der aktuelle Fortschritt ist nur schwer nachvollziehbar, sodass *Dagger* auf lange Sicht keine gute Basis für `binSpector` ist.

## Das Projekt *Fracture*

Das Projekt *Fracture* ist ein Architektur-unabhängiger Decompiler von Objektcode zu \gls{LLVM}-\gls{IR}-Code. Das Projekt wird aktiv vom *Charles Stark Draper Laboratory*[^Draper] in Cambridge (MA) entwickelt. Zum aktuellen Zeitpunkt können nur Binärdateien der ARM-Architektur von *Fracture* analysiert werden. Eine Unterstützung für die Architekturen x86, PowerPC und MIPS befindet sich momentan in der Entwicklung.

Das Projekt *Fracture* wird über ein `git`-Repository[^Fracture] von Draper Laboratories entwickelt und publiziert. Dadurch ist es möglich, an der Entwicklung mitzuwirken und Verbesserungen einzubringen. Der Hauptentwickler ist Richard Carback, der jegliche Anfragen per Mail oder *Github* binnen kürzester Zeit beantwortet und stets mit Rat und Tat zur Seite steht.

### Die Installation von *Fracture*

Da es sich bei *Fracture* um ein Projekt handelt, das die Infrastruktur von \gls{LLVM} verwendet und auf diverse interne Symbole angewiesen ist, muss \gls{LLVM} mit `--enable-debug-symbols` kompiliert werden. Damit die *Fracture*-Bibliothek kompiliert werden kann, muss ebenfalls eine bestimmte Version von Clang verwendet werden, die von *Draper* gesondert zur Verfügung gestellt wird. Das Listing \ref{lst:kompilieren-von-fracture} zeigt die notwendigen Schritte zur Installation von *Fracture*.

### Die grundlegende Verwendung von *Fracture*

Nach der Installation befinden sich im Ordner `Debug+Asserts` von *Fracture* folgende Programme:

- `fracture-cl` (Eine Disassembler Shell)
- `fracture-tblgen` (Ein LLVM-Tabellengenerator, wird von `fracture-cl` verwendet)
- `mkAllInsts` (Erstellt einen Ordner mit einer Objektdatei je unterstützter Instruktion einer übergebenen Architektur)

Das Hauptprogramm ist `fracture-cl` und wird mit der Übergabe einer Objektdatei sowie der Prozessorarchitektur, für die die Objektdatei kompiliert wurde, gestartet. Anschließend kann der Anwender über die Kommandozeile die Binärdatei analysieren. Es ist unter anderem möglich, die verschiedenen Sektionen und Symbole zu extrahieren sowie die Binärdatei zu disassemblieren und in die \gls{LLVM}-\gls{IR} zu dekompilieren.

### Aktueller Stand des Projekts

Zum aktuellen Zeitpunkt steht in `fracture-cl` keine Funktion zum Speichern der Ausgabe zur Verfügung. Ebenfalls existiert ein Bug, der die Shell durch die Eingabe von CTRL+D abstürzen lässt. Dadurch ist es nicht möglich, mit mehreren *PIPE*'s die Ein- und Ausgabe durch ein anderes Programm zu steuern.

Trotz der Voraussetzung spezieller Versionen von \gls{LLVM} und Clang sind die Entwickler stets bemüht, ihren Programmcode kompatibel zu den aktuellsten Entwicklerversionen von \gls{LLVM} zu halten. Dadurch kann *Fracture* bereits mit der Version 3.5 von \gls{LLVM} verwendet werden. Bei diesem Projekt mangelt es ebenfalls an einer vollständigen Dokumentation. Diese wird abschnittsweise freigegeben, sobald die jeweilige Fähigkeit vollständig zur Verfügung steht.

## Das Projekt *McSema*

*McSema* ist der Spitzname für \gls{MC} Semantics und ist ein von \gls{DARPA} finanziertes Projekt. Die Entwicklung ist noch sehr jung und wurde auf der diesjährigen REcon[^REcon] [@Dinaburg2014] offiziell vorgestellt. Es hat genau wie *Dagger* das Ziel, x86-Binärdateien in \gls{LLVM}-\gls{IR} umzuwandeln. Die Entwickler wählen aber eine andere Herangehensweise. *McSema* führt eine statische Übersetzung von x86-Instruktionen in \gls{LLVM}-\gls{IR}-Code durch und versucht dabei die Nachteile von *Dagger* und *Fracture* zu vermeiden.

Zur Analyse einer Objektdatei, werden von *McSema* die Instruktionen und der Kontrollfluss unabhängig voneinander betrachtet. Diese Denkweise ist sinnvoll, da bereits bei der Gewinnung des Kontrollflusses viele unbekannte Faktoren eine schwierige Ausgangssituation darstellen. Im folgenden Abschnitt werden einige Probleme und ihre Lösungsansätze erläutert.

### Erstellung eines Controlflow-Graphen

Das Erstellen eines Controlflow-Graphen ist je nach vorliegender Objektdatei schwierig. Je nachdem, ob der Entwickler aktiv *Code Obfuscation* ("Verstümmelung" von Code, der eine Dekompilierung erschwert) vorgenommen hat, kann es zu einigen Problemen bei einer reinen *Control Flow Recovery*-Strategie kommen:

- Indirekte Sprungbefehle durch im Programm berechnete Adressen (das Sprungziel ist bei der Dekompilierung unbekannt);
- Sprungtabellen mit zur Ausführung berechneten Offsets;
- Programmcode, der mit Daten vermischt ist;
- Die Bedeutung der vorliegenden Bytes ist unbekannt. Es könnte sich um Konstanten, Daten oder Code handeln.

Um einen Controlflow-Graphen zu extrahieren, verwendet *McSema* den IDA-Pro Disassembler. Für weitere Entwicklungen ist es angedacht, die Graphen durch symbolische Ausführungen zu erhalten; möglicherweise wird dafür das Projekt klee verwendet.

### Generierung der LLVM-IR

Sobald der komplette Controlflow-Graph extrahiert wurde, beginnt die Übersetzung zu \gls{LLVM}-\gls{IR}. Dabei werden verschiedene Wissensquellen vereint:

- *Mapping* der Instruktionen auf den jeweils aktuellen Kontext des Prozessors;
- Betrachtung der Veränderung des Speichers;
- Übersetzung der einzelnen Funktionen in den aktuellen Kontext (Ersetzen von Registern durch mögliche Variablen);
- Optimierung der extrahierten Funktionen durch automatisierte Compiler;
- Verwendung von externem Wissen wie Windows DLL's zur Gewinnung von möglichen (Funktions-, Variablen-)Namen.

### Aktueller Stand des Projekts

Bisher wurden laut Aussagen der Entwickler bereits folgende Fähigkeiten der x86-Architektur implementiert:

- einige Gleitpunkt-Register und -Instruktionen
- alle Integer-Instruktionen
- Unit-Tests
- alle \gls{SSE}-Register
- sehr wenige \gls{SSE}-Instruktionen
- Callbacks
- einige externe Aufrufe
- Sprungtabellen
- Datenreferenzen

Die Entwicklung an *McSema* ist sehr aktiv, da es sich um ein *open-source*-Projekt auf *Github* handelt.[^McSema] Zum aktuellen Zeitpunkt werden nur die Betriebssysteme Windows und Linux unterstützt. Ob eine Unterstützung für *Mach-O* (OSX) Binärdateien geplant ist, ist nicht bekannt. Auf Grund der noch fehlenden Unterstützung für Mac OSX kann *McSema* in dieser Studienarbeit nicht weiter betrachtet werden.

<!-- Fußnoten -->

[^nummer-141]: Bei der gewählten Zahl handelt es sich um eine zufällig gewählte Zahl. Ihr Wert hat keine Relevanz in Bezug auf die Ausführung des Programms und entspricht ungewollt dem Geburtstag und Geburtsmonat des Autors.

[^Fracture]: Link zum Repository inklusive Beispielen zur Verwendung: \url{https://github.com/draperlaboratory/Fracture}.

[^Draper]: Link zum Webauftritt der Draper-Laboratories: \url{http://www.draper.com}.

[^REcon]: REcon ist eine Computer-Sicherheits-Konferenz, die den Fokus auf *reverse engineering* und fortgeschrittene *Exploit*-Techniken legt. Sie findet jährlich in Montreal, Kanada statt.

[^McSema]: Link zum Repository: \url{https://github.com/trailofbits/mcsema}. Link zum Webauftritt: \url{http://blog.trailofbits.com/?s=mcsema}.