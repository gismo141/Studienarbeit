
# Das binSpector-Framework

Das Framework `binSpector` soll eine einheitliche Oberfläche zur grafischen Analyse von Objektcode bieten. Da es sich bei `binSpector` um eine rein grafische Oberfläche handelt, wird in diesem Kapitel die Programmstruktur erläutert und die dafür verwendeten Projekte vorgestellt.

## Die Build-Umgebung mit CMake

Das Build-System der \gls{LLVM}-Compiler-Infrastruktur ist darauf ausgelegt, schnell und einfach die Entwicklung von Drittprojekten zu ermöglichen, die \gls{LLVM}-Header oder Subprojekte verwenden. Für die Erstellung eines Projekts, das die \gls{LLVM}-Compiler-Infrastruktur verwendet, soll gemäß den Codinganweisungen und Anleitungen der \gls{LLVM}-Webseite[^Erstellung_eines_LLVM_Projekts] eine `CMake`-Build-Umgebung verwendet werden.

`CMake` ist eine *out-of-source*-Build-Umgebung[^Build-Umgebung], die erweiterbar und plattformunabhängig ist. Unter *out-of-source* versteht man eine Ordnerstruktur, bei der die entstehenden Objektdateien nicht mit den Quelldateien vermischt abgelegt werden.

### Die Ordnerstruktur eines CMake-Projekts

Die Ordnerstruktur besteht gemäß Abbildung \ref{fig:ordnerstruktur_der_cmake_build_umgebung} aus den Ordnern `build`, `docs`, `include`, `lib` und `tools`. Die Datei `CMakeLists.txt` beinhaltet die Angaben, wie der vorliegende Quellcode mit `CMake` verarbeitet werden soll.
<!--      -->
\begin{figure}[!ht]
\centering
    \fbox{
    \begin{tikzpicture}[dirtree]
    \node {./binSpector}
        child { node {build}
        } 
        child { node {docs/...}
            child { node {CMakeLists.txt}
            }
            child { node {Doxyfile}
            }
        }
        child { node {include/...}
        }
        child { node {lib/...}
            child { node {CMakeLists.txt}
            }
        }
        child { node {tools}
            child { node {binSpector}
                child { node {CMakeLists.txt}
                }
                child { node {main.cpp}
                }
            }
        }
        child { node {CMakeLists.txt}
        };
    \end{tikzpicture}
    }
\caption{Ordnerstruktur der CMake-Build-Umgebung}
\label{fig:ordnerstruktur_der_cmake_build_umgebung}
\end{figure}

#### Der build-Ordner

Dieser Ordner beinhaltet nach der Abarbeitung mit `CMake` die entstandenen Binärdateien sowie eventuell erstellte Bibliotheken (zum Beispiel *shared libraries* oder *static libraries*). Wird der Quellcode eines Projekts verteilt verwaltet, zum Beispiel mit *git*, dann existiert dieser Ordner beim Klonen[^Klonen] noch nicht. Der Ordner muss vor dem Kompilieren vom Anwender erstellt werden. Dadurch wird eine unnötige Verwaltung von möglicherweise nicht auf dem Zielsystem laufender Binärdateien verhindert.

#### Der docs-Ordner

In diesem Ordner befindet sich eine `Doxyfile` und eine `CMakeLists.txt`. Die `CMakeLists.txt`-Datei enthält Anweisungen zur Erstellung der Dokumentation von `binSpector`. Zur Erstellung wird das Programm `doxygen` und die Datei `Doxyfile` verwendet. Letztere enthält Informationen über den Inhalt, das Aussehen der Dokumentation und die Struktur des vorliegenden Quellcodes.

#### Der include-Ordner

Der `include`-Ordner enthält alle notwendigen *Header*-Dateien, die für ein Projekt angelegt wurden. Die *Header* können wiederum in weiteren Unterordnern organisiert werden.

#### Der lib-Ordner

Der `lib`-Ordner enthält alle notwendigen Quellcode-Dateien. Diese Dateien werden beim Kompilieren meist in Bibliotheken miteinander verknüpft und können dann bei der Erstellung der Binärdateien zum Linken verwendet werden. Die Quellcodedateien können ebenfalls in weiteren Unterordnern organisiert werden.

#### Der tools-Ordner

Dieser Ordner beinhaltet alle Quellcode-Dateien, die eine `main(...)`
-Funktion enthalten. Diese Dateien repräsentieren die späteren Programme, die auf Funktionalitäten aus den `include`- und `lib`-Ordnern zurückgreifen. Dabei sollte für jede spätere Binärdatei ein Unterordner angelegt werden, in dem sich die entsprechende Quellcode-Datei befindet.

### Der Ablauf eines Build-Prozesses unter CMake

Mit `CMake` selbst können keine Binärdateien erzeugt werden. `CMake` dient vielmehr dazu, Quellcode-Dateien für die unterschiedlichsten Verwendungen vorzubereiten: es können neben `Makefiles` auch *XCode*-, *Eclipse*- oder gar *Visual Studio*-Projekte erzeugt werden.

Für die Entwicklung von `binSpector` wurde auf eine Entwicklungsumgebung wie XCode oder Eclipse verzichtet, sodass diese Fähigkeit von `CMake` nicht weiter beleuchtet wird. Im Folgenden wird der Ablauf eines Build-Prozesses durch erzeugte *Makefiles* näher erläutert.

#### Vorbereitung der Build-Umgebung

Damit `CMake` verwendet werden kann, muss die Datei `CMakeLists.txt` angepasst werden.[^CMake_Tutorial] Listing \ref{lst:binspector_cmakelists_txt} zeigt die globale `CMakeLists.txt`-Datei für das `binSpector`-Framework.[^weitere_CMakeLists]

\begin{code}
    \inputminted[linenos]{cmake}{/Users/michaelriedel/Developer/binSpector/CMakeLists.txt}
    \caption{Die Datei \texttt{binSpector/CMakeLists.txt}}
    \label{lst:binspector_cmakelists_txt}
\end{code}

Eine `CMake`-Datei besteht aus mehreren `Key(Value)`-Tupeln. Der `Value` kann dabei aus mehreren Zeichenketten - getrennt durch ein Leerzeichen - bestehen. Die globale `CMake`-Datei des `binSpector`-Frameworks kann dabei in 5 Abschnitte unterteilt werden:

1. Die Projektbezeichung und Anforderungen an `CMake`;
2. Betriebssystem-spezifische Angaben (hier die Angaben, die OSX benötigt, um die entstehende App korrekt zu erstellen);
3. Angaben zu weiteren Bibliotheken (hier die Angaben, die für die Verwendung von Qt5 mit `CMake` benötigt werden);
4. Die Angabe, in der sich die *Header*-Dateien befinden (dies ermöglicht einen einfachen `#include` in den Quellcode-Dateien, da der Suchbereich `INCLUDE_DIRECTORIES(...)` auf den Ordner "include" gesetzt wird.);
5. Angaben zu Ordnern, in denen sich weitere `CMakeLists.txt`-Dateien befinden (diese werden beim Aufruf von `CMake` abgearbeitet).

Durch `binSpector/docs/CMakeLists.txt` wird gemäß Abschnitt \ref{der-docs-ordner} und Listing \ref{lst:binspector_docs_cmakelists_txt} die Dokumentation vorbereitet. Die Datei `binSpector/lib/CMakeLists.txt` erstellt gemäß Listing \ref{lst:binspector_lib_cmakelists_txt} aus den angegebenen `*.cpp`-Quellcode-Dateien eine Bibliothek. Bei der Erstellung dieser Bibliothek wird ebenfalls die `Qt5_Widgets`-Bibliothek verwendet, um die jeweiligen Abhängigkeiten aufzulösen.

Bei der Erstellung des `binSpector`-Frameworks wird die Bibliothek `binSpectorLib` im Anschluss von der Datei `binSpector/tools/binSpector/CMakeLists.txt` gemäß Listing \ref{lst:binspector_tools_cmakelists_txt} zum Linken verwendet. Damit das Framework erfolgreich kompiliert werden kann, müssen die *Header*- und *Source*-Dateien durch das Qt5-Programm \gls{moc} vorbereitet werden. Das Programm \gls{moc} "wertet die Deklaration von slots und signals in Header-Dateien aus und erzeugt ein zusätzliches .cpp-Modul, welches die notwendige Routing-Funktionalität enthält" [@Pawelczak2013a S. 87]. Sobald die `CMakeLists.txt`-Dateien erstellt sind, kann der eigentliche Build-Prozess gestartet werden.

### Kompilieren des Frameworks

Um das Framework zu kompilieren, sind die Schritte gemäß Listing \ref{lst:kompilieren-von-binspector} notwendig. Nach dem Kompilieren des Framework kann binSpector wie im nachfolgenden Kapitel \ref{die-verwendung-von-binspector} erläutert, verwendet werden.

\begin{code}
\begin{minted}[linenos]{bash}
# Setzen des Installations-Pfades
export DESTINATION=$HOME/Developer
# Klonen des Repository
git clone git@github.com:gismo141/binSpector $DESTINATION/binSpector
# Zum geklonten Verzeichnis wechseln
cd $DESTINATION/binSpector
# Das build-Verzeichnis erstellen
mkdir build && cd build
# Das build-Verzeichnis vorbereiten (moc, library, etc.)
cmake ..
# Die Dokumentation, die Bibliothek und binSpector kompilieren
make
\end{minted}
\caption{Befehle zum Kompilieren von binSpector}
\label{lst:kompilieren-von-binspector}
\end{code}

## Die Verwendung von binSpector

Das Programm `binSpector` ist in C++ unter Verwendung der grafischen Bibliothek Qt5 geschrieben. Qt ist eine *open-source*-Bibliothek, die für die Betriebssysteme OSX, iOS, Windows, Linux und Android angepasste grafische Elemente bietet. Dadurch können grafische Oberflächen unabhängig vom späteren Betriebssystem programmiert werden. Nach dem Kompilieren entspricht die grafische Oberfläche den Systemstandards des Betriebssystems, auf dem das Programm ausgeführt wird.

Die Programmiersprache C++ eignet sich auf Grund ihrer objekt-orientierten Programmierung sehr gut, um `binSpector` modular zu entwickeln und einfach zu erweitern.

### Der grafische Aufbau von binSpector

Wenn `binSpector` gestartet wird, öffnet sich im Vordergrund gemäß Abbildung \ref{fig:dialog-oeffnen-von-binspector} ein `QFileDialog`. Dieser Dialog dient dazu, eine Binärdatei auszuwählen, die von `binSpector` im weiteren Verlauf analysiert werden soll. Der Anwender kann ebenfalls eine abgespeicherte Analyse öffnen. Abgespeicherte Analysen werden von `binSpector` stets als Ordner mit der Endung `*.binsp` (`binSpector`-Projekt) abgespeichert. Hat der Anwender eine Datei ausgewählt, wird das Framework mit seiner Hauptansicht geöffnet.

![Dialog "Öffnen eines Projekts/Binärdatei"\label{fig:dialog-oeffnen-von-binspector}](/Users/michaelriedel/Developer/binSpector/docs/images/openDialog.png)

Die Hauptansicht besteht gemäß Abbildung \ref{fig:hauptansicht-von-binspector} aus einem zentralen Hauptfenster, einer Menüleiste und jeweils einem Dock an der linken und rechten Seite des Hauptfensters. Diese Docks können in der Größe verändert und getrennt bewegt oder geschlossen werden. Das linke Dock wird im Folgenden als *binary*-Dock bezeichnet; das rechte Dock ist das *visualizer*-Dock. Beide Docks bieten verschiedene Funktionen, die in Tabs gestaffelt werden können.

![Hauptansicht von binSpector\label{fig:hauptansicht-von-binspector}](/Users/michaelriedel/Developer/binSpector/docs/images/manual.png)

#### Die Menüleiste

Bei OSX wird die Menüleiste stets getrennt vom Programm am oberen Bildschirmrand angezeigt. Über die Menüleiste kann der Benutzer Analyse-Projekte anlegen, speichern, laden und schließen. Ebenfalls können verschiedene Einstellungen bezüglich des Objektcodes vorgenommen werden. Es wird empfohlen, jeden Menüeintrag mit einem Tastaturkürzel zu versehen.

Als Menüleiste wird eine `QMenuBar` verwendet, die bereits folgende `QMenu`'s zur Verfügung stellt:

- **File** (Funktionen zum Datei- und Projektmanagement)
- **Edit** (Bearbeiten von Analysen)
- **View** (Darstellung von `binSpector` verändern)
- **Help** (Hilfestellungen zur Verwendung von `binSpector`)

#### Das zentrale Hauptfenster

Das Hauptfenster bietet Platz für die aktuell durchgeführte Analyse. Die Standarddarstellung ist der aktuell betrachtete Objektcode in Assembler. Wurde im *binary*-Dock die Architektur des vorliegenden Objektcodes angegeben oder durch *binSpector* korrekt bestimmt, so kann die resultierende \gls{LLVM}-\gls{IR} im Hauptfenster dargestellt werden. Durch den Aufruf der Hilfe wird eine Anleitung zur Verwendung von `binSpector` im Hauptfenster dargestellt.

#### Das *binary*-Dock

In diesem Dock werden gemäß Abbildung \ref{fig:hauptansicht-von-binspector} alle Funktionen aufgelistet, die mit der Objektdatei an sich in Verbindung gebracht werden können. Beispielhaft sind Ausgabefenster, die den Inhalt des `Comment`-Blocks anzeigen oder Einstellfenster, um die Architektur anzugeben, für die der Objektcode kompiliert wurde. Die in diesem Fenster dargestellten Informationen sind nicht generiert, sondern werden aus der vorhandenen Binärdatei extrahiert. 

#### Das *visualizer*-Dock

Das *visualizer*-Dock ermöglicht gemäß Abbildung \ref{fig:hauptansicht-von-binspector} die grafische Darstellung des analysierten Objektcodes. Zum aktuellen Zeitpunkt wird bei der Analyse ein Kontrollflussgraph angezeigt. Ein Kontrollflussgraph stellt den Ablauf des Objektcodes grafisch dar. Bei der Weiterentwicklung des Programms ist es denkbar, die Graphen mit unterschiedlich vielen Details anzuzeigen. Die Detailtiefe wird vom Benutzer definiert, der dadurch einen besseren Gesamtüberblick über das analysierte Programm erhält.

### Disassemblieren einer Binärdatei

Um eine Binärdatei zu disassemblieren, muss in `binSpector` eine Binärdatei geöffnet sein. Diese kann entweder beim Start von `binSpector` oder über den Menüeintrag *File->New Binary-Analysis* oder das Tastenkürzel `CMD+N` ausgewählt werden. Es ist möglich, `*.app`-Bundles zu öffnen. Dabei handelt es sich um eine Ordnerstruktur, die unter Mac OSX verwendet wird, um Anwendungen mit zusätzlichen Dateien zu bestücken. Wurde eine Datei ausgewählt, überprüft `binSpector`, ob es sich um eine `*.app`-Datei handelt - wenn ja, wird die darin enthaltene Binärdatei unter `<Name-des-Programms>.app/Contents/MacOS/<Name-des-Programs>` geladen.

Anschließend wird im *binary*-Dock der Programmname sowie die Architektur angezeigt, für die sie kompiliert wurde. Diese Informationen werden aus dem UNIX-Tool namens `file` extrahiert. Momentan wird stets x86_64 bevorzugt, wenn es sich um eine sogenannte *fat*-Binärdatei handelt. Eine *fat*-Binärdatei enthält mehrere kompilierte Versionen des Programmcodes, um verschiedene Architekturen zu unterstützen. Die automatische Auswahl kann vom Anwender stets überschrieben werden; dafür muss aus der `QComboBox` nur die gewünschte Architektur ausgewählt werden.

Im Anschluss können die Parameter angegeben werden, die zur Disassemblierung verwendet werden sollen. Für die Disassemblierung wird das OSX-Programm `otool` verwendet. Die Parameter lauten standardmäßig `tV` und produzieren eine disassemblierte Ausgabe von Textstellen und symbolisch disassemblierten Operanden aus der Text-Sektion der Binärdatei.[^optionen-otool]

![Disassemblierung der Anwendung `binSpector` mit den Optionen `t`\label{fig:disassemblierung-von-binspector-mit-t}](/Users/michaelriedel/Developer/binSpector/docs/images/disassembled_x86_64_t.png)

Durch einen Klick auf den `QPushButton` "Disassemble" wird die Disassemblierung mit den angegebenen "Dis-Options" und der ausgewählten Architektur gestartet. Je nach Größe der Binärdatei dauert die Disassemblierung und Darstellung mehrere Sekunden, in diesem Zeitraum bleibt der `QPushButton` "Disassemble" blau hinterlegt. Sobald die Disassemblierung abgeschlossen ist, wird der Assembler-Code mit dem \gls{GNU}-Programm `c++filt` analysiert, um die Funktionsnamen gemäß der *Name-Mangling*-Konvention aufzulösen und die Zeilen nach 110 Zeichen mit dem UNIX-Programm `fold` umzubrechen. Anschließend wird das Python-Skript *Pygments* verwendet, um den Assembler-Code farbig zu markieren und als `*.html`-Datei zu speichern.[^Zwischendateien] Diese wird dann gemäß Abbildung \ref{fig:disassemblierung-von-binspector-mit-t} im Hauptfenster dargestellt.

### Dekompilieren zu LLVM-IR

Diese Funktionalität ist momentan nicht implementiert, weil die Projekte *Fracture* und *Dagger* bisher keine verifizierbare Ausgabe liefern.

Angedacht ist, dass das Dekompilieren nahezu dem Ablauf zum Disassemblieren entspricht. Nachdem die Binärdatei geladen wurde, muss der Anwender die Optionen zum Dekompilieren im `QPlainTextEdit`-Feld "Dec-Options" angeben und die Architektur auswählen. Durch den Klick auf den `QPushButton` "Decompile to LLVM-IR" wird die Dekompilierung gestartet.

Zum aktuellen Zeitpunkt wird statt der Dekompilierung eine Disassemblierung durchgeführt. Für die erzeugte Ausgabe wird gemäß Abbildung \ref{fig:dekompilierung-von-binspector} die Syntax-Färbung für \gls{LLVM}-\gls{IR} verwendet.

![Disassemblierung der Anwendung `binSpector` mit der Syntax-Färbung für LLVM-IR\label{fig:dekompilierung-von-binspector}](/Users/michaelriedel/Developer/binSpector/docs/images/llvm_ir_x86_64_na.png)

Es ist angedacht, dass die Dekompilierung ähnlich wie die Disassemblierung durch ein externes Programm durchgeführt wird. Die Bedingungen dafür sind, dass jede Datei, die entsteht, im Ordner `/texts/` mit einem eindeutigen Namen abgespeichert wird. Ein eindeutiger Dateiname muss sich wie folgt zusammensetzen: `<verwendete-Architektur>`+`<verwendete-Optionen>`+`.`+`<Dateiendung-des-Resultats` (zum Beispiel: `x86_64.tV.asm`).

### Abspeichern und erneutes Öffnen eines Projekts

Ein analysiertes Projekt wird temporär unter `/tmp/binSpector/<Name-des-analysierten-Programms>` abgelegt. Durch den Menüeintrag *File->Save Project* (`CMD+S`) kann die aktuelle Analyse an einem gewünschten Ort abgespeichert werden. Dabei werden alle Analysedaten aus dem temporären Ordner in den Zielordner kopiert.

Durch *File->Open Project* (`CMD+O`) kann anschließend der abgespeicherte `*.binsp`-Ordner ausgewählt und wieder geöffnet werden.

## Die programmiertechnische Struktur von binSpector

`binSpector` ist als modulares Framework aufgebaut, damit es kontinuierlich im Forschungsbereich der wissenschaftlichen Einrichtung für Betriebssysteme und Rechnerarchitekturen (WE 6) der Universität der Bundeswehr in München weiterentwickelt werden kann. Um den zukünftigen Nutzern die Entwicklung und Benutzung von `binSpector` zu erleichtern, werden in den folgenden Abschnitten die Struktur des Frameworks und der verwendeten Tools und Projekte näher erläutert.

### Die Aufteilung der Namespaces

Das Framework wird gemäß dem *Model-View-Controller*-Pattern entwickelt. Dies ermöglicht eine Aufteilung in Projekte (*Control*), in Daten (*Model*) und in  grafische Oberflächen (*View*), um mit den Objektdateien zu interagieren.
Um das Framework thematisch zu gliedern, werden verschiedene Namespaces verwendet. Diese Namespaces werden auch im Dateisystem durch die Verwendung von Ordnern repräsentiert, wodurch eine homogene Struktur möglich wird.

### Ablauf des Programmstarts

Zum Programmstart wird ein Objekt der `binSpector`-Klasse gemäß Listing \ref{lst:binspector-main-cpp} initialisiert und anschließend dargestellt.

\begin{code}
\inputminted[linenos]{c++}{/Users/michaelriedel/Developer/binSpector/tools/binSpector/main.cpp}
\caption{Die \texttt{main()}-Funktion von \texttt{binSpector}}
\label{lst:binspector-main-cpp}
\end{code}

Im Konstruktor der `view::binspector`-Klasse wird anschließend gemäß Abbildung \ref{fig:hauptansicht-von-binspector} die Hauptansicht mit den Menüeinträgen, der Hilfe zu `binSpector` sowie den *visualizer*- und *binary*-Docks initialisiert und dargestellt.

Das *visualizer*-Dock wird mit 4 Visualisierungen als Tabs initialisiert:

- der Call-Graph (`view::visualizer::callGraph`)
- der Controlflow-Graph (`view::visualizer::controlFlowGraph`)
- der \gls{CFG-DFG} (`view::visualizer::controlFlowAndDataFlowGraph`)
- Memory-Dependence (`view::visualizer::memoryDependence`)

Das *binary*-Dock wird mit dem `view::binary::basicInfo`-Tab geladen. Dieser Tab ermöglicht das Disassemblieren und Dekompilieren. Bei der Initialisierung des `view::binary::basicInfo`-Tabs wird der *codeViewer* geladen, der wiederum den `control::Disassembler` und `control::Decompiler` instantiiert. Ab diesem Moment ist `binSpector` einsatzbereit.

![Kollaborationsdiagramm zur `view::binspector`-Klasse\label{fig:kollaborationsdiagramm-zur-view::binspector-klasse}](/Users/michaelriedel/Developer/binSpector/build/docs/html/classview_1_1binspector__coll__graph.png)

Abbildung \ref{fig:kollaborationsdiagramm-zur-view::binspector-klasse} zeigt das Kollaborationsdiagramm der `view::binspector`-Klasse. Anhand der *Doxygen*-Dokumentation von `binSpector` können die aufgerufenen Funktionen und Parameter analysiert und visualisiert werden.

### Der Entwicklungsstand von binSpector

In der vorliegenden Version ist `binSpector` in der Lage, eine gewünschte Binärdatei mit den vom Anwender angegebenen Optionen zu disassemblieren und das Ergebnis farbig darzustellen. Analysen lassen sich als Projekte abspeichern und können wieder geladen werden.

Bisher konnten die vorgestellten Projekte *Fracture* oder *Dagger* noch nicht erfolgreich in das `binSpector`-Framework implementiert werden. Auf Grund dessen sind die Visualisierungen ebenfalls ohne Funktion, da zur Erstellung der Graphen eine \gls{LLVM}-\gls{IR}-Datei benötigt wird.

<!-- Fußnoten -->

[^Erstellung_eines_LLVM_Projekts]: Für weitere Informationen zur Erstellung eines LLVM-Projekts siehe: \url{http://llvm.org/docs/Projects.html}.

[^Build-Umgebung]: Eine Build-Umgebung beschreibt die Struktur von Dateien und Ordnern sowie den Ablauf, wie die Quelldateien miteinander verknüpft werden, um zum Schluss ein ausführbares Programm zu ermöglichen. Wird der Build (das Kompilieren und Linken von Quellcode) durchgeführt, werden alle Zwischenprodukte wie temporäre Dateien und Nebenprodukte (zum Beispiel eine *static* oder *shared library*) entsprechend der Ordnerstruktur abgelegt.

[^Klonen]: Klonen bezeichnet das Beziehen des Quellcodes aus einem Repository.

[^CMake_Tutorial]: Ein zuverlässiges und hilfreiches Tutorial zur Erstellung einer `CMake`-Struktur und der notwendigen `CMakeLists.txt`-Dateien findet man bei @Kiefer2014.

[^weitere_CMakeLists]: Weiterführend befinden sich Listings der `CMakeLists.txt` der Unterordner `docs`, `lib` und `tools` im Anhang \ref{sec:die_erstellung_eines_cmake_projekts_am_beispiel_von_binspector}.

[^optionen-otool]: Weitere Optionen sind in den `manpages` von `otool` aufgelistet.

[^Zwischendateien]: Durch das kontinuierliche Speichern der Zwischendateien wird dem Verlust einer Analyse vorgebeugt. Sollte das Programm `binSpector` abstürzen, können die bereits analysierten Dateien aus dem Ordner `/tmp/binSpector/<Name-des-analysierten-Programms>/` extrahiert werden.