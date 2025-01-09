Das Skript zeigt verschiedene Varianten der Fehlerbehandlung (Exception Handling) in PL/SQL für eine Funktion get_emp. Die Funktion ruft den Datensatz eines Mitarbeiters basierend auf seiner employee_id aus der Tabelle employees ab. Es werden unterschiedliche Ansätze gezeigt, wie mit Fehlern (insbesondere der Ausnahme no_data_found) umgegangen werden kann.

1. Einfache Funktion ohne Fehlerbehandlung
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
begin
  select * into emp from employees where employee_id = emp_num;
  return emp;
end;
Beschreibung

Diese Funktion:
Nimmt die employee_id als Eingabeparameter (emp_num).
Führt eine SELECT ... INTO-Abfrage aus, um den entsprechenden Datensatz in die lokale Variable emp zu speichern.
Gibt den gesamten Datensatz (emp) zurück.
Problem

Wenn es keinen Mitarbeiter mit der angegebenen employee_id gibt, wird eine ungehandelte Ausnahme (no_data_found) ausgelöst.
Es gibt keine Fehlerbehandlung in der Funktion, wodurch jede Abfrage mit einem ungültigen emp_num fehlschlägt.

  
  2. Verwendung der Funktion in einem anonymen Block
declare
  v_emp employees%rowtype;
begin
  dbms_output.put_line('Fetching the employee data!..');
  v_emp := get_emp(10);
  dbms_output.put_line('Some information of the employee are : ');
  dbms_output.put_line('The name of the employee is : ' || v_emp.first_name);
  dbms_output.put_line('The email of the employee is : ' || v_emp.email);
  dbms_output.put_line('The salary of the employee is : ' || v_emp.salary);
end;
Beschreibung

Der anonyme Block:
Ruft die Funktion get_emp mit einer employee_id von 10 auf.
Gibt die Werte bestimmter Spalten (z. B. first_name, email, salary) aus.
Probleme:
Wenn es keinen Mitarbeiter mit employee_id = 10 gibt, schlägt der Block fehl, da die Funktion get_emp keine Fehlerbehandlung enthält.
Das Verhalten ist nicht benutzerfreundlich.

  
  3. Fehlerbehandlung ohne Rückgabewert
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
begin
  select * into emp from employees where employee_id = emp_num;
  return emp;
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the id ' || emp_num);
end;
Beschreibung

Hier wird die Ausnahme no_data_found explizit abgefangen.
Bei einem Fehler gibt die Funktion eine Nachricht aus: "There is no employee with the id ...".
Problem:
Es fehlt ein Rückgabewert im Fehlerfall. Funktionen in PL/SQL müssen immer einen Wert zurückgeben.
Ohne Rückgabe führt dies zu weiteren Fehlern, wenn die Funktion im Block verwendet wird.

  
  4. Fehlerbehandlung mit Weitergabe der Ausnahme
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
begin
  select * into emp from employees where employee_id = emp_num;
  return emp;
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the id ' || emp_num);
    raise no_data_found;
end;
Beschreibung

Fehlerbehandlung:
Die Ausnahme no_data_found wird abgefangen und eine Nachricht ausgegeben.
Danach wird die Ausnahme mit raise erneut ausgelöst.
Verwendung:
Wenn die Funktion im PL/SQL-Block verwendet wird, können die Fehler weiter oben im Programmfluss abgefangen werden.
Vorteil:
Es wird ein klarer Hinweis ausgegeben, während die Ausnahme aufgerufen werden kann, falls der Aufrufer damit umgehen möchte.
5. Fehlerbehandlung für alle möglichen Ausnahmen
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
begin
  select * into emp from employees where employee_id = emp_num;
  return emp;
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the id ' || emp_num);
    raise no_data_found;
  when others then
    dbms_output.put_line('Something unexpected happened!.');
    return null;
end;
Beschreibung

Fehlerbehandlung für alle Ausnahmen:
no_data_found: Gibt eine spezifische Nachricht aus und löst die Ausnahme erneut aus.
others: Fängt alle anderen Fehler ab (z. B. Syntaxfehler, Zugriffsprobleme).
Gibt eine generische Fehlermeldung aus.
Gibt null zurück, um die Funktionsanforderung zu erfüllen.
Vorteil:
Bietet eine umfassende Fehlerbehandlung und vermeidet unerwartete Abstürze.
Nachteil:
Bei generischen Ausnahmen kann es schwieriger sein, die genaue Ursache des Problems zu diagnostizieren.
Vergleich der Varianten
Variante	Vorteile	Nachteile
Ohne Fehlerbehandlung	Einfach, minimaler Code	Führt bei Fehlern zu Abstürzen
Einfache Fehlerbehandlung	Gibt spezifische Fehler aus	Kein Rückgabewert, Funktion bleibt unbrauchbar
Mit Weitergabe der Ausnahme	Fehler wird protokolliert und aufrufbar	Erfordert zusätzliche Verarbeitung im Aufrufer
Umfassende Fehlerbehandlung	Fängt alle Fehler ab, robust	Generische Fehlerbehandlung kann Diagnosen erschweren

  
  Empfehlung
Die letzte Variante ist die robusteste Lösung. Sie ermöglicht:

Spezifische Behandlung bekannter Fehler (z. B. no_data_found).
Abfangung unerwarteter Fehler (z. B. others).
Flexibilität durch die Kombination von Fehlerprotokollierung und Weitergabe von Ausnahmen.
