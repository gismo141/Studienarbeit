
# Fazit und empfohlene Weiterentwicklung am binSpector-Framework

Die Präsenz von Technik, die uns umgibt, hat im letzten Jahrzehnt stark zugenommen. Stets werden neue Apps auf unseren Mobilgeräten veröffentlicht, aktualisiert oder durch andere Produkte ausgetauscht. Im Computerbereich werden teilweise bereits im Jahrestakt neue Betriebssysteme veröffentlicht. Bei so schnellen Veränderungen ist es kaum möglich, alle Sicherheitslücken eines Systems zu schließen, ohne bei Aktualisierungen weitere zu öffnen.

Da viele Softwarelösungen als *closed-source*-Produkte veröffentlicht werden, ist es schwer möglich, Sicherheitslücken zu identifizieren, geschweige denn, sie zu schließen. Eine mögliche Lösung ist das Disassemblieren solcher Anwendungen. Auf Grund der maschinennahen Struktur des Assembler-Codes ist eine Analyse sehr mühsam und erfordert viele Kenntnisse über die vorliegende Prozessorarchitektur.

Das \gls{LLVM}-Projekt ist eine vielseitige Plattform im *open-source*-Bereich, die es ermöglicht, verschiedene Compiler und Prozessorarchitekturen auf der gemeinsamen "Zwischensprache" \gls{LLVM}-\gls{IR} zu vereinen. Die Syntax von \gls{LLVM}-\gls{IR} ähnelt stark der C-Syntax und ermöglicht damit ein besseres Verständnis als Assembler. Das Ziel ist es, einen Decompiler zu entwickeln, der Maschineninstruktionen in \gls{LLVM}-\gls{IR} zuverlässig umwandelt.

Seit zirka 2 Jahren ist ein wachsendes Interesse im Bereich der Dekompilierung zu vermerken. In der vorliegenden Studienarbeit wurden 3 Projekte vorgestellt, die explizit in diesem Bereich forschen. Insbesondere die Rüstungsindustrie hat großes Interesse an Weiterentwicklungen und finanziert entsprechende Projekte. Zum Beispiel wird das Projekt *McSema* von \gls{DARPA} finanziert, *Fracture* wird an den *Draper Laboratories* für das amerikanische Verteidigungsministerium entwickelt.

Das `binSpector`-Framework ist meine Antwort auf die eingangs gestellte Forschungsfrage: "Wie kann Objektcode in eine Zwischensprache wie LLVM-IR übersetzt und somit bequem visualisiert und analysiert werden?" Das `binSpector`-Framework bietet die Möglichkeit, verschiedene Projekte zur Dekompilierung zu verwenden, zu vergleichen und zu visualisieren. Das Projekt `binSpector` ist im Bereich der visuellen Analyse von \gls{LLVM}-\gls{IR}-Code einzigartig, weil bisher kein *open-source* Projekt diese Nische als Framework abdeckt.

Das Projekt ist zukunftsträchtig, weil zusammen mit dem \gls{LLVM}-Projekt eine mächtige Plattform geboten wird, die für viele Betriebssysteme und Prozessorarchitekturen die notwendige Unterstützung bietet.

Die zukünftige Entwicklung von `binSpector` sollte im Sinne der Integration der Projekte wie *Dagger* und *Fracture* fortgeführt werden. Im aktuellen Stadium ist `binSpector` eine visuell ansprechende und leicht zu verstehende Anwendung. Die Einfachheit der Anwendung sollte auch weiterhin einen wichtigen Stellenwert einnehmen. Sobald die korrekte Umwandlung von Maschinencode in \gls{LLVM}-\gls{IR} möglich ist, sind kreativen Weiterentwicklungen keine Grenzen gesetzt.

Zukünftige Projekte bieten sich im Bereich der Visualisierung von \gls{LLVM}-\gls{IR}-Code sowie im Bereich der Portierung von Binärdateien auf unterschiedliche Architekturen an. Ebenfalls ist es denkbar, aus dem generierten \gls{LLVM}-\gls{IR}-Code eine korrekte Dekompilierung in C/C++/Objective-C zu erhalten.