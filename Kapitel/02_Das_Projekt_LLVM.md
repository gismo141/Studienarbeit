
# Das Projekt LLVM

Bei \gls{LLVM} handelt es sich gemäß @Lattner2007 um ein modulares Compiler-Projekt, das seit 2000 unter Chris Lattner und Vikram Adve an der Universität von Illinois entwickelt wird. Das \gls{LLVM}-Projekt setzt sich aus unterschiedlichen Einzelprojekten zusammen. Die bekanntesten Vertreter[^Projektuebersicht] sind:

- LLVM Core (Bibliotheken für den Code-Generator und Optimierer)
- Clang (der native LLVM C/C++/Objective-C Compiler/Frontend)
- LLDB (Ein Debugger, der die Bibliotheken von LLVM und Clang verwendet)
- klee (Eine *symbolic virtual machine*, die versucht, alle dynamischen Pfade eines Programms zu analysieren und somit Bugs zu identifizieren)

## Funktionsweise von LLVM - Unabhängigkeit von Quelle und Ziel

Ein großer Vorteil bei der Verwendung von \gls{LLVM} ist der Aufbau. \gls{LLVM} kann durch Frontends und Backends individuell erweitert werden. Somit können Entwickler ihre eigenen Sprachdefinitionen schreiben[^tutorial-fuer-llvm-sprache] und diese mit den Mitteln von \gls{LLVM} gemäß Abbildung \ref{fig:uebersicht-der-retargetability} (verschiedene Code- und Laufzeitanalysen sowie Optimierungen) für ihre eigenen oder die bereits vorhandenen Backends kompilieren. Um die Unabhängigkeit von Quelle und Ziel sicherzustellen, wird die \gls{LLVM}-\gls{IR}, eine "Zwischensprache", verwendet.

![Übersicht der Funktionsweise von LLVM [@QuantAleaGmbH2014]\label{fig:uebersicht-der-retargetability}](/Users/michaelriedel/Dropbox/Latex/configuration/Bibtex/Dokumente/llvm_three_phase.png)

Der folgende Abschnitt dient zur Veranschaulichung der Projektstruktur von \gls{LLVM}. Er zeigt die Entwicklung eines einfachen C-Programms und dem Kompiliervorgangs für eine Intel x86-64 Prozessor-Architektur.

## Entwicklung eines Beispiel-Programms und Kompilierung mit LLVM

Im folgenden Abschnitt werden zwei Möglichkeiten zur Kompilierung eines C-Programms mit den LLVM-Tools erläutert. Dieses Beispiel zeigt, wie die Komplexität der verschiedenen Zwischensprachen zunimmt, bis aus einem einfachen Programm aus einer Hochsprache die notwendigen Maschineninstruktionen (Objektcode) entstehen. Das Ziel des Experiments ist, zu zeigen, dass man der Zwischensprache \gls{LLVM}-\gls{IR} problemlos eine korrekte ausführbare Objektdatei kompilieren kann.

Aus Gründen der Komplexität wird das folgende Programm sehr einfach gehalten. Durch den Aufruf eines `printf(...)` oder `std::cout`-Befehls würde die kompilierte Objektdatei unnötig aufgebläht, da Bibliotheksfunktionen zusätzlich zum entwickelten Programm geladen, verwendet und kompiliert werden müssten. Als Überprüfung, ob das Programm erfolgreich ausgeführt wurde, wird das Programm nur einen Befehl enthalten, der an die ausführende `Shell` (Kommandozeile) die Zahl 141 zurückgibt.[^nummer-141] Dieser Rückgabewert kann anschließend durch den Befehl `echo $?` ausgelesen werden.[^Angaben-zu-den-Codelistings]

>Zu Beginn wird eine neue C-Datei erstellt, die den zu testenden Programm-Code enthält.
>\inputminted[linenos,firstline=2,lastline=2,firstnumber=1]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}

### Der direkte Weg von C zum Objektcode

>Im Anschluss wird die C-Datei mit dem C-Compiler in Objektcode kompiliert.
\inputminted[linenos,firstline=5,lastline=5,firstnumber=2]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Nachdem der Übersetzungsvorgang abgeschlossen ist, kann das Programm ausgeführt werden.
>\inputminted[linenos,firstline=7,lastline=7,firstnumber=3]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Das Programm wird ohne eine Ausgabe auf das Terminal beendet, anschließend kann der Rückgabewert abgefragt werden.
>\inputminted[linenos,firstline=9,lastline=10,firstnumber=4]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}

\noindent
Das Programm wurde erfolgreich kompiliert, ausgeführt und lieferte das gewünschte Ergebnis. Nun wird das Programm über den Umweg der \gls{LLVM}-\gls{IR} kompiliert und überprüft, ob das Resultat das selbe ist.

### Der Umweg von C über LLVM-IR und Assembler zu Objektcode

>Zu Beginn wird die vorher erstellte C-Datei in LLVM-IR übersetzt.
>\inputminted[linenos,firstline=13,lastline=13,firstnumber=1]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Anschließend kann die entstandene \gls{LLVM}-Datei ausgelesen werden.[^llvm-code-gekuerzt]
>\inputminted[linenos,firstline=15,lastline=17,firstnumber=2]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>\inputminted[linenos,firstline=18,lastline=27,firstnumber=5]{llvm}{../Resources/Code/c_to_llvm_to_oc.sh}
>Als nächstes wird der \gls{LLVM}-\gls{IR}-Code in Assembler kompiliert.
>\inputminted[linenos,firstline=30,lastline=32,firstnumber=15]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Da es sich bei der ausgegebenen Datei um Bit-Code handelt, muss dieser noch in eine textuelle Version übersetzt werden.
>\inputminted[linenos,firstline=34,lastline=34,firstnumber=18]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Die resultierende Datei enthält den Assemblercode für die Intel x86_64-Architektur in Textform und kann ausgelesen werden.[^assembler-im-anhang] Als letzten Schritt muss die Assembler-Datei in eine Objektdatei kompiliert werden.
>\inputminted[linenos,firstline=64,lastline=64,firstnumber=19]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Wurde die Kompilierung erfolgreich abgeschlossen, kann das Programm ausgeführt werden.
>\inputminted[linenos,firstline=66,lastline=66,firstnumber=20]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}
>Nachdem das Programm beendet wurde, kann der Rückgabewert abgefragt werden.
>\inputminted[linenos,firstline=68,lastline=69,firstnumber=21]{bash}{../Resources/Code/c_to_llvm_to_oc.sh}

\noindent
Das Beispiel zeigt eine erfolgreiche Übersetzung aus der "Zwischensprache" \gls{LLVM}-\gls{IR} in eine Objektdatei. Die Ausführung zeigt erwartungsgemäß das gleiche Ergebnis, wie die direkt kompilierte Datei. Die Tatsache, dass man aus einer \gls{LLVM}-Datei stets eine Objektdatei kompilieren kann, ermöglicht die Verwendung von \gls{LLVM}-\gls{IR} als Analysegrundlage. In den folgenden Abschnitten werden einige weitere Vorteile von \gls{LLVM}-\gls{IR} für die Binärcodeanalyse vorgestellt.

## Vorteile durch die Verwendung von LLVM

In den folgenden Abschnitten werden einige Vorteile erläutert, die durch die Verwendung von \gls{LLVM} entstehen. Diese Vorteile bilden später die Grundlage für die Binärcodeanalyse mit `binSpector`.

### Retargetability

Durch die *Retargetability* ist es gemäß Abbildung \ref{fig:uebersicht-der-retargetability} möglich, Quellcode gleichzeitig mit einer konstanten Analyse- und Optimierungsumgebung für unterschiedliche Architekturen zu kompilieren. Ebenfalls können bereits vorhandene Projekte problemlos auf andere Architekturen portiert werden.

### Detailliertere Diagnoseausgaben

Das Teilprojekt *Clang* verbessert im Unterschied zur Version 4.2 des \gls{gcc} die Analyse von Syntaxfehlern.[^update-gcc] Speziell bei der Entwicklung von Projekten sind solche Fehler- und Warnmeldungen von großem Vorteil bei der Lösung von Problemen. Bei einer Umwandlung von einer Programmiersprache in eine andere können solche Ausgaben ebenso hilfreich sein.

### Die lesbare Zwischensprache LLVM-IR

Das \gls{LLVM}-Projekt verwendet für seine verschiedenen Codeanalysen und Optimierungsstrategien bei der Kompilierung von Quellcode die Zwischensprache \gls{LLVM}-\gls{IR}. Diese Zwischensprache ähnelt stark der C-Syntax.

\begin{code}
    \inputminted[linenos]{cpp}{../Resources/Code/main.cpp}
    \inputminted[linenos,firstline=5,lastline=19]{llvm}{../Resources/Code/main.ll}
    \inputminted[linenos]{nasm}{../Resources/Code/main.asm}
    \caption{Vergleich zwischen C++, LLVM-IR und Assembly}
    \label{lst:llvm-compare-main-cpp}
\end{code}

Listing \ref{lst:llvm-compare-main-cpp} zeigt anschaulich die Unterschiede zwischen einem sehr einfachen C-Programm (erster Codeabschnitt), der resultierenden und gekürzten \gls{LLVM}-Syntax (mittlerer Codeabschnitt) und der disassemblierten Objektdatei (letzter Codeabschnitt).

Die \gls{LLVM}-\gls{IR} bietet sich sehr gut für die Binärcodeanalyse an, da die notwendigen Informationen wie Funktionsnamen, Rückgabe- und Übergabeparameter und Funktionsinhalte nachvollziehbar dargestellt werden. Der disassemblierte Objektcode bietet einen guten Überblick über die Maschineninstruktionen. Er erlaubt jedoch kaum Rückschlüsse auf den ursprünglichen Quellcode.

### Eine Vielzahl an Tools zur Visualisierung

Mit der \gls{LLVM}-Programmsuite werden verschiedene Tools zur Analyse von Code mitgeliefert. Die nachfolgenden Visualisierungen wurden nach @Mikushin2013 beispielhaft am Codebeispiel \ref{lst:llvm-compare-main-cpp} durchgeführt. Zur Wahrung der Übersichtlichkeit des Dokuments befinden sich die Abbildungen im Anhang \ref{sec:beispiele-zur-visualisierung}.

#### *Call*-Graph

Ein Call-Graph zeigt die Funktionen und ihre Aufrufe untereinander. Dadurch kann der Ablauf eines Programms sehr gut verfolgt werden. Mit dem Befehl gemäß Listing \ref{lst:ausgabe-callgraph} kann eine einfache `*.cpp` in die Zwischensprache \gls{LLVM}-\gls{IR} übersetzt, optimiert und anschließend ein Call-Graph in eine `*.dot`-Datei exportiert werden. Diese Datei kann anschließend mit dem `dot`-Programm in ein Bild umgewandelt werden. 

\begin{code}
\begin{minted}[linenos]{bash}
c++ -emit-llvm -S -c main.cpp -o -| opt -dot-callgraph -o /dev/null \
    && dot -Tpdf callgraph.dot -o callgraph.pdf
\end{minted}
\caption{Befehl zur Erstellung eines Call-Graphen}
\label{lst:ausgabe-callgraph}
\end{code}

Abbildung \ref{fig:main-callgraph} im Anhang zeigt den resultierenden Call-Graphen.

#### *Controlflow*-Graph (Basicblocks)

Ein Controlflow-Graph stellt die Anweisungen einer Funktion dar, die nacheinander durchlaufen werden. Dabei ist jeder Knoten über mindestens einen Pfad mit dem Einstiegsknoten verbunden. \gls{LLVM} verwendet eine \gls{SSA}-Darstellung von sogenannten *Basic Blocks*. Ein *Basic Block* ist eine finite Liste von Instruktionen, wobei die letzte stets die terminale Instruktion darstellt (siehe @Moll2011: S. 8). Durch diese Instruktion können verschiedene *Basic Blocks* miteinander verknüpft werden. Der Befehl zur Ausgabe einer Abbildung gemäß \ref{fig:main-cfg} wird im Listing \ref{lst:ausgabe-callgraph} aufgezeigt.

\begin{code}
\begin{minted}[linenos]{bash}
c++ -emit-llvm -S -c main.cpp -o -| opt -dot-fg -o /dev/null \
    && dot -Tpdf *.dot -o cfg.pdf
\end{minted}
\caption{Befehl zur Erstellung eines Controlflow-Graphen}
\label{lst:ausgabe-callgraph}
\end{code}

#### *Control-* und *Dataflow* Graph

Ein \gls{CFG-DFG} kann dazu verwendet werden, um zu verstehen, welche Variablen auf welche Weise von welchen Funktionen verwendet werden. Dies kann helfen, unbekannte Variablen sinnvoll zu benennen. 

\begin{code}
\begin{minted}[linenos]{bash}
c++ -emit-llvm -S -c main.cpp -o main.ll && ./graph-llvm-ir main.ll \
    && dot -Tpdf *.dot -o cfg-dfg.pdf
\end{minted}
\caption{Befehl zur Erstellung der \gls{CFG-DFG}}
\label{lst:cfg-dfg-erstellen}
\end{code}

Abbildung \ref{fig:main-cfg-dfg} im Anhang zeigt den zugehörigen \gls{CFG-DFG}. Dieser Graph wurde mit dem Python Skript `graph-llvm-ir` erstellt.[^graph-llvm-ir] Um das Skript verwenden zu können, muss `llvmpy` installiert werden. Dabei handelt es sich um einen \gls{LLVM}-Wrapper für Python.[^llvmpy] Listing \ref{lst:cfg-dfg-erstellen} zeigt den Befehl zum Erstellen des Graphen.

Zum aktuellen Zeitpunkt ist die letzte von `llvmpy` vollständig unterstützte Version \gls{LLVM}-3.3. Dies kann in der zukünftigen weiteren Entwicklung von `binSpector` zu Problemen führen, da Programme wie *Fracture*, die für `binSpector` benötigt werden, höhere Versionen von \gls{LLVM} verwenden. Es kann jedoch sein, dass *Fracture* auch \gls{LLVM}-3.3 unterstützt. Diesbezüglich wurden noch keine Analysen durchgeführt. Alternativ ist denkbar, die Funktionalität des `graph-llvm-ir`-Skripts in C/C++ zu implementieren, sodass die Abhängigkeit von `llvmpy` gelöst wird.

#### *Memory Dependence* Analysen

Gemäß der Dokumentation der Klasse `llvm::MemoryDependenceAnalysis` aus der *Header*-Datei `llvm-3.5/include/llvm/Analysis/MemoryDependenceAnalysis.h` des \gls{LLVM}-Projekts ist eine *Memory Dependence*-Analyse:

>"[...] an analysis that determines, for a given memory operation, what preceding memory operations it depends on."

Diese Analyse kann zum Beispiel dazu verwendet werden, um die Funktionen zu identifizieren, die einen bestimmten Speicherbereich manipulieren. Bei dieser Analyse handelt es sich bisher um eine textuelle Auswertung. Es ist denkbar, alle Speicherbereiche, die verwendet werden, darzustellen und dabei die Bereiche, die am häufigsten verändert werden, farbig zu markieren. Dadurch kann ein Bild über relevante Speicherstellen gewonnen werden.

<!-- Fußnoten -->

[^Angaben-zu-den-Codelistings]: Alle folgenden Codelistings sind zusammenhängend zu betrachten und werden jeweils vor dem Befehl erläutert. Bei den Listings handelt es sich um eingegebene Befehle und Ausgaben, die von aufgerufenen Programmen auf der Standard-Ausgabe (der Kommandozeile) zurückgegeben werden.

[^nummer-141]: Die Zahl wurde zufällig vom Autor gewählt.

[^Projektuebersicht]: Für eine vollständige Liste aller \gls{LLVM}-Teilprojekte siehe \url{http://llvm.org}.

[^tutorial-fuer-llvm-sprache]: Die Entwicklung eines \gls{LLVM}-Frontends kann anhand des Tutorials von @Segal2009 durchgeführt werden.

[^update-gcc]: Seit der Version 4.8 des \gls{gcc} wurden die Diagnosefähigkeiten stark überarbeitet. @Trieu2013 bietet einen Vergleich der Diagnose-Ausgaben zwischen \gls{gcc}-4.2, \gls{gcc}-4.8 und Clang.

[^llvm-code-gekuerzt]: Der \gls{LLVM}-\gls{IR} Code wurde aus Gründen der Übersichtlichkeit um einige Zeilen gekürzt. Es handelt sich dabei um Metadaten, die \gls{LLVM} für interne Analysen und Optimierungen verwendet.

[^assembler-im-anhang]: Der Inhalt der Assemblerdatei befindet sich im Anhang als Listing \ref{lst:assembler-von-llvm}.

[^graph-llvm-ir]: Das Skript kann unter \url{https://github.com/pfalcon/graph-llvm-ir} bezogen werden.

[^llvmpy]: Informationen zur Installation befinden sich unter \url{http://www.llvmpy.org}.