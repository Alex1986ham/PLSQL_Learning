
1. Erstellung der Funktion get_avg_sal
CREATE OR REPLACE FUNCTION get_avg_sal (p_dept_id departments.department_id%type) 
RETURN number AS 
v_avg_sal number;
BEGIN
  select avg(salary) into v_avg_sal 
  from employees 
  where department_id = p_dept_id;
  RETURN v_avg_sal;
END get_avg_sal;
Erklärung:

Zweck: Diese Funktion berechnet das durchschnittliche Gehalt (avg(salary)) für eine bestimmte Abteilung (department_id).
Parameter:
p_dept_id: Ein Parameter, der den Datentyp department_id aus der Tabelle departments übernimmt (dynamische Typbindung).
Rückgabewert: number, das durchschnittliche Gehalt.
Funktionsweise:
Die Funktion verwendet eine SQL-Abfrage, um das durchschnittliche Gehalt aller Mitarbeiter in der Abteilung mit der ID p_dept_id zu berechnen.
Das Ergebnis der Abfrage wird in die Variable v_avg_sal gespeichert.
Der Wert von v_avg_sal wird zurückgegeben.

  
  2. Verwendung der Funktion in einem BEGIN-END-Block
declare
  v_avg_salary number;
begin
  v_avg_salary := get_avg_sal(50);
  dbms_output.put_line(v_avg_salary);
end;
Erklärung:

Deklaration: Die Variable v_avg_salary wird deklariert, um das Ergebnis der Funktion zu speichern.
Funktionsaufruf: get_avg_sal(50) ruft die Funktion auf und übergibt die Abteilungs-ID 50 als Parameter.
Ausgabe: Der Wert des durchschnittlichen Gehalts für Abteilung 50 wird mit dbms_output.put_line ausgegeben.

  
  3. Verwendung der Funktion in einer SELECT-Anweisung
select employee_id, first_name, salary, department_id, get_avg_sal(department_id) avg_sal 
from employees;
Erklärung:

Kontext: Die Funktion get_avg_sal wird in einer Spalte eines SELECT-Befehls verwendet.
Funktionsweise:
Für jede Zeile in der Tabelle employees wird die Funktion aufgerufen.
Der department_id der jeweiligen Zeile wird als Parameter übergeben.
Das Ergebnis (durchschnittliches Gehalt der Abteilung) wird als zusätzliche Spalte avg_sal angezeigt.

  
  
  4. Verwendung der Funktion in WHERE, GROUP BY und ORDER BY-Klauseln
select get_avg_sal(department_id) 
from employees
where salary > get_avg_sal(department_id)
group by get_avg_sal(department_id) 
order by get_avg_sal(department_id);
Erklärung:

Kontext: Die Funktion wird in verschiedenen SQL-Klauseln verwendet:
WHERE-Klausel: Überprüft, ob das Gehalt eines Mitarbeiters (salary) größer ist als das durchschnittliche Gehalt seiner Abteilung.
GROUP BY-Klausel: Gruppiert die Ergebnisse basierend auf dem Ergebnis der Funktion get_avg_sal(department_id).
ORDER BY-Klausel: Sortiert die Ergebnisse basierend auf dem durchschnittlichen Gehalt der Abteilungen.
Achtung: Bei der Verwendung von Funktionen in GROUP BY oder ORDER BY kann die Performance beeinträchtigt werden, da die Funktion möglicherweise für jede Zeile mehrmals ausgeführt wird.

  
  
  5. Löschen der Funktion
drop function get_avg_sal;
Erklärung:

Befehl: Dieser Befehl entfernt die Funktion get_avg_sal aus der Datenbank.
Vorsicht: Nach dem Löschen steht die Funktion nicht mehr zur Verfügung. Abhängige SQL-Anweisungen oder PL/SQL-Blöcke, die die Funktion verwenden, schlagen fehl.
Zusammenfassung
Funktionen in PL/SQL: Ermöglichen die Wiederverwendung von Code und erleichtern komplexe Berechnungen, indem sie in verschiedenen SQL-Kontexten genutzt werden können.
Flexibilität: Funktionen können in SELECT-, WHERE-, GROUP BY-, und ORDER BY-Klauseln verwendet werden, was sie zu einem mächtigen Werkzeug macht.
Performance: Beim häufigen Einsatz in SQL-Abfragen sollte die Performance der Funktion beachtet werden, insbesondere wenn sie komplexe Berechnungen enthält.
