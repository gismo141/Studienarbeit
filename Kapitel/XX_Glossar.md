
# Glossar

Bytecode

:    Quellcode, der in eine maschinenunabhängige Zwischensprache übersetzt wurde. Bei der Ausführung von Bytecode wird ein Interpreter benötigt, der den Bytecode in Objektcode umwandelt. Diese Übersetzung nennt man \gls{JIT}-Compilation.

\gls{JIT}-Compiler

:    Ein \gls{JIT}-Compiler ist ein Programm, das zur Laufzeit einen Bytecode in Objektcode übersetzt und diesen ausführt. Ein Beispiel ist die Programmiersprache Java mit der \gls{JVM}.

Namespace

:   Ein Namespace (engl. für Namensraum) definiert den Gültigkeitsbereich von Funktionen und Variablennamen. Namensräume können ineinander geschachtelt werden, um den Quelltext systematisch zu separieren. Dadurch können stets die gleichen Namen für Funktionen und Variablen verwendet werden, ohne das es zu Komplikationen kommt.

Name-Mangling

:   C++ ist eine objektorientierte Programmiersprache, die wie Java eine Überladung von Funktionen erlaubt. Funktionsüberladung bedeutet, dass Funktionsnamen mehrfach verwendet werden können. Die einzige Bedingung ist, dass die Funktion sich entweder in ihren Übergabeparametern oder in dem Namespace unterscheidet, in dem sie deklariert ist. Bei der Übersetzung des Quellcodes werden die Funktionen in eindeutige Namen umgewandelt. Dabei wird der Funktionsname mit den Namen der Übergabeparameter und Datentypen encodiert. Dieses Verfahren wird gemäß @IBM2003 als *name-mangling* bezeichnet und ist je nach Compiler unterschiedlich implementiert. Diese Umwandlung ist notwendig, weil die ersten C++ Compiler den Quellcode zuerst in die Sprache C umwandelten. In C dürfen Funktionsnamen nur einmalig vergeben werden. Das Verfahren kann im Quelltext durch den `extern "C"`-Bezeichner verhindert werden.

Objektcode

:    Objektcode ist der auf einen Maschinentyp übersetzte Quellcode, er kann direkt ausgeführt werden. Objektcode kann nur auf den Architekturen ausgeführt werden, für die er kompiliert wurde.