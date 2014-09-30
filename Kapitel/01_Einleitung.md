
# Einleitung

Der Mensch ist fähig, komplexe Aufgaben selbstständig umzusetzen. Computer dagegen können dies nicht. Sie sind lediglich in der Lage, eine Abfolge von Befehlen auszuführen. Damit ein von Menschen geschriebener Quellcode auf einem Computer ausgeführt werden kann, muss dieser kompiliert werden. Beim Kompilieren müssen die komplexen Strukturen des Quellcodes analysiert und in einfache Mikrobefehle[^Mikrobefehle] übersetzt werden. Im Anschluss kann das Programm auf dem Prozessor, für den es kompiliert wurde, ausgeführt werden.

Bei der Entwicklung neuer Software-Programme unterscheidet man zwischen *open-source*- und *closed-source*-Entwicklung. Bei *open-source*-Programmen wird der Quellcode direkt an den Endbenutzer weitergegeben. Dieser kann dann das Programm entweder für seine Computer und Betriebssysteme kompilieren oder es weiterentwickeln/verändern. Bei *closed-source* erhält der Anwender nur  kompilierte Binärdateien. Diese können  nur auf den jeweiligen Prozessorarchitekturen verwendet werden, für die sie vom Hersteller kompiliert wurden. Der Anwender hat keine Möglichkeit, den Quellcode zu lesen oder zu verändern. Wenn der Anwender jedoch auf ein *closed-source*-Programm und gleichzeitig auf die Wahrung der Sicherheit seines Computers (Vermeidung von Datenlecks oder Schadcode) angewiesen ist, muss er die Binärdatei analysieren können.

Um Programme zu analysieren, deren Quellcode nicht vorliegt, können Disassembler[^Disassembler] wie IDA Pro oder Hopper verwendet werden. Mit einem Disassembler kann der Programmfluss als Diagramm oder der Objektcode in der Assemblersprache dargestellt werden. Ebenfalls kann der vorliegende Objektcode in eine Pseudosprache übersetzt werden, die der Programmiersprache C ähnelt. Da für die Übersetzung von Objektcode in diese Pseudosprache fest programmierte Annahmen getroffen werden müssen und keine Informationen zur Benennung von Variablen vorliegen, ist das Resultat nur sehr mühsam zu verstehen. Eine Manipulation des Quellcodes oder der Vergleich von zwei Versionen einer Binärdatei[^Updates] ist auf dieser Grundlage nur schwer möglich.

Zum aktuellen Zeitpunkt fehlt ein *open-source*-Disassembler, der dem Benutzer eine komfortablere Darstellung als Assembler oder Pseudocode bietet, um die vorliegenden Maschineninstruktionen zu verstehen. Des Weiteren soll es möglich sein, viele verschiedene Architekturen zu unterstützen und möglicherweise den Objektcode auf diese zu portieren und auf sicherheitsrelevante Eigenschaften zu untersuchen.

In der vorliegenden Studienarbeit bearbeite ich folgende Forschungsfrage: "Wie kann Objektcode in eine Zwischensprache wie \gls{LLVM}-\gls{IR} übersetzt und somit bequem visualisiert und analysiert werden?" Zur Beantwortung dieser Fragestellung habe ich in Kapitel \ref{das-binspector--framework} das `binSpector`-Framework[^binSpector] entwickelt. Es bietet eine erweiterbare grafische Oberfläche unter der Verwendung von Qt5, um eine angenehme Analyse von Objektcode und die Verwendung auf unterschiedlichen Betriebssystemen zu ermöglichen und wird. Zur Dekompilierung von Objektcode zu \gls{LLVM}-\gls{IR} (eine "Zwischensprache" zwischen Assembler und höheren Programmiersprachen, wie C) greife ich auf Projekte wie *Dagger*[^Dagger] und *Fracture*[^Fracture] zurück, die in Kapitel/ref{vom-objektcode-zur-llvm--ir} näher erläutert werden. Zunächst biete ich in Kapitel \ref{das-projekt-llvm} einen Überblick über das \gls{LLVM}-Projekt und zeige Möglichkeiten zur sicherheitstechnischen Analyse von Objektcode auf.

Für die Recherche und die Entwicklung des *binSpector*-Frameworks habe ich das Betriebssystem OSX verwendet. Alle in dieser Arbeit enthaltenen Erkenntnisse, Anweisungen und Code-Listings wurden ausschließlich auf einer Intel Core-i7 CPU und der Betriebssystemversion 10.9.5 getestet. Auf weitere benötigte Programme weise ich im Fließtext hin und erläutere notwendige Schritte für die Installation.

Für die Lektüre dieser Studienarbeit werden fortgeschrittene Kenntnisse im Bereich der Programmerzeugung, höheren Programmiersprachen wie C/C++, UNIX und Intel-Assembler vorausgesetzt. Zur Auffrischung werden die Werke von @Aho2007, @Bach1986, @Eagle2008, @Katz2014, @Kernighan1988, @Lattner2007 und @Pawelczak2013 empfohlen.

<!-- Fußnoten -->
[^Updates]: Aktualisiert der Hersteller seine Software, so wird meist auch die Binärdatei mit dem Objektcode verändert. Um die Unterschiede zu erkennen, müssen beide Binärdateien miteinander verglichen werden. Dies ist zum Beispiel dann sinnvoll, wenn überprüft werden soll, ob ein Update eher Sicherheitslücken öffnet, anstatt sie zu schließen.

[^Debuggen]: Debuggen bedeutet, dass der Quellcode mit einem Programm (einem Debugger) auf Fehler und Probleme untersucht wird.

[^Flag]: Ein Flag ist ein Argument, das einem Programm zur Ausführung übergeben wird. Beim Übersetzen eines Quellcodes kann durch das Setzen verschiedener Flags die resultierende Binärdatei spezialisiert werden. Bekannte Flags sind u. a. die `-O0` bis `-O3`-Flags, die das Optimierungslevel des Compilers bestimmen.

[^Mikrobefehle]: Mikrobefehle bezeichnen die kleinste Befehlsgröße, die Prozessoren abarbeiten können. Mikrobefehle unterteilen sich dabei grob in drei Gruppen: Sprungbefehle (bedingte und unbedingte Sprünge), mathematische Funktionen (`add`, `sub`, `mul` etc.) und Lade-/Speicherbefehle. 

[^Breakpoint]: Ein Breakpoint ist ein vom Benutzer gesetzter Haltepunkt im Quellcode um den Ablauf des Programms an dieser Stelle zu unterbrechen. Dadurch bieten sich dem Entwickler die Möglichkeit, sein Programm schrittweise zu analysieren und die Werte der vorhandenen Variablen zu überprüfen.

[^Disassembler]: Ein Disassembler übersetzt die Maschineninstruktionen des Objektcodes in eine Assemblersprache. Diese Übersetzung basiert auf simplen *look-up*-Tabellen der jeweiligen Maschinenarchitektur.

[^binSpector]: Der Name ist abgeleitet von *binary* und *inspector*.

[^Dagger]: *Dagger* ermöglicht die Umwandlung von Objektcode in die Zwischensprache LLVM-IR, siehe \url{http://dagger.repzret.org}.

[^Fracture]: *Fracture* ermöglicht in der aktuellen Entwicklung die Umwandlung von ARM-Objektcode zur LLVM-IR. Durch die kontinuierliche Weiterentwicklung sollen auch die X86, MIPS und PowerPC-Architekturen unterstützt werden.
