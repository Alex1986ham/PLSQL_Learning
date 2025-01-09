Das Skript demonstriert die Erstellung und Verwendung eines Packages in PL/SQL. Ein Package ist eine Sammlung zusammengehöriger PL/SQL-Elemente wie Prozeduren, Funktionen, Variablen und Cursor, die zusammen in einer logischen Einheit organisiert sind.

1. Erstellung der Package-Spezifikation
CREATE OR REPLACE 
PACKAGE EMP AS 
  v_salary_increase_rate number := 0.057; 
  cursor cur_emps is select * from employees;
  
  procedure increase_salaries;
  function get_avg_sal(p_dept_id int) return number;
END EMP;
Beschreibung

Die Package-Spezifikation definiert die Schnittstelle des Packages. Sie enthält:
Variablen:
v_salary_increase_rate: Ein globaler Parameter für die Gehaltserhöhung (5,7%).
Cursor:
cur_emps: Ein Cursor, der alle Zeilen aus der Tabelle employees abruft.
Subprogramme:
procedure increase_salaries: Prozedur zur Erhöhung der Gehälter.
function get_avg_sal: Funktion zur Berechnung des durchschnittlichen Gehalts einer Abteilung.
Wichtig:
Die Implementierung der Prozeduren und Funktionen erfolgt nicht in der Spezifikation, sondern im Package-Body.

  
  2. Erstellung des Package-Bodys
CREATE OR REPLACE
PACKAGE BODY EMP AS
  procedure increase_salaries AS
  BEGIN
    for r1 in cur_emps loop
      update employees_copy set salary = salary + salary * v_salary_increase_rate;
    end loop;
  END increase_salaries;
  
  function get_avg_sal(p_dept_id int) return number AS
  v_avg_sal number := 0;
  BEGIN
    select avg(salary) into v_avg_sal from employees_copy where
          department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
END EMP;
Beschreibung

Der Package-Body implementiert die in der Spezifikation definierten Prozeduren und Funktionen.
Prozedur increase_salaries:
Ziel: Erhöht die Gehälter aller Mitarbeiter in der Tabelle employees_copy.
Ablauf:
Ruft alle Mitarbeiter über den Cursor cur_emps ab.
Erhöht das Gehalt jedes Mitarbeiters um den Wert, der durch den Faktor v_salary_increase_rate definiert ist.
Aktualisiert die Gehälter in der Tabelle employees_copy.
Funktion get_avg_sal:
Ziel: Berechnet das durchschnittliche Gehalt für eine bestimmte Abteilung.
Parameter:
p_dept_id: Die Abteilungs-ID.
Ablauf:
Führt eine SQL-Abfrage aus, um den Durchschnitt der Gehälter (avg(salary)) für die angegebene Abteilung in der Tabelle employees_copy zu berechnen.
Gibt den berechneten Durchschnittswert zurück.

  
  3. Nutzung des Packages
a) Nutzung von Subprogrammen

exec EMP_PKG.increase_salaries;
Erklärung:
Ruft die Prozedur increase_salaries aus dem Package EMP auf.
Führt die Gehaltserhöhung für alle Mitarbeiter in der Tabelle employees_copy durch.
b) Nutzung von Funktionen und Variablen

begin
  dbms_output.put_line(emp_pkg.get_avg_sal(50));
  dbms_output.put_line(emp_pkg.v_salary_increase_rate);
end;
Erklärung:
Ruft die Funktion get_avg_sal auf und übergibt die Abteilungs-ID 50.
Gibt den Wert der globalen Variable v_salary_increase_rate (5,7%) aus.
Zusammenfassung der Package-Komponenten
Komponente	Beschreibung
v_salary_increase_rate	Globale Variable für den Gehaltserhöhungsfaktor (5,7%).
cur_emps	Cursor, der alle Zeilen aus der Tabelle employees lädt.
increase_salaries	Prozedur zur Erhöhung der Gehälter in der Tabelle employees_copy.
get_avg_sal	Funktion zur Berechnung des durchschnittlichen Gehalts einer Abteilung.
Vorteile der Verwendung von Packages
Modularität:
Funktionen, Prozeduren, Variablen und Cursor sind logisch gruppiert.
Kapselung:
Nur in der Spezifikation definierte Elemente sind von außen zugänglich.
Private Elemente können im Body definiert werden.
Performance:
Der gesamte Code eines Packages wird bei der ersten Verwendung in den Speicher geladen, was wiederholte Zugriffe beschleunigt.
Wartbarkeit:
Änderungen am Body des Packages können vorgenommen werden, ohne die Spezifikation zu ändern (sofern keine neuen Schnittstellen eingeführt werden).
Fehlerquellen und Hinweise
Tabelle employees_copy:
Die Prozedur increase_salaries aktualisiert employees_copy, nicht employees. Es muss sichergestellt werden, dass diese Tabelle existiert und die gleichen Spalten wie employees hat.
Initialisierung von Variablen:
Variablen wie v_salary_increase_rate können von außen überschrieben werden, wenn sie nicht geschützt sind.
Exception Handling:
Weder die Prozedur noch die Funktion implementieren Fehlerbehandlungslogik. Es wäre sinnvoll, mögliche Fehler wie no_data_found oder others zu behandeln.
