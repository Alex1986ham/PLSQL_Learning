1. Erstes Beispiel: Richtiges Verwenden von WHERE CURRENT OF
declare
  cursor c_emps is select * from employees 
                    where department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where current of c_emps;
  end loop;  
end;
Erklärung:

Cursor-Deklaration (FOR UPDATE):
Der Cursor c_emps wählt alle Mitarbeiter in der Abteilung mit der department_id = 30 aus. Die Klausel FOR UPDATE sperrt diese Zeilen, um Konflikte mit anderen Transaktionen zu vermeiden.
WHERE CURRENT OF:
Die Klausel WHERE CURRENT OF verweist auf die aktuell durch den Cursor gelesene Zeile. Dadurch wird sichergestellt, dass nur die Zeile, die der Cursor gerade verarbeitet, aktualisiert wird.
Korrektheit:
Dieses Beispiel ist korrekt, da der Cursor direkt auf die Tabelle verweist (employees), und WHERE CURRENT OF kann verwendet werden.
2. Zweites Beispiel: Falsches Verwenden von WHERE CURRENT OF
declare
  cursor c_emps is select e.* from employees e, departments d
                    where 
                    e.department_id = d.department_id
                    and e.department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where current of c_emps;
  end loop;  
end;
Problem:

Cursor-Deklaration mit Join:
Der Cursor c_emps enthält eine Kombination aus den Tabellen employees und departments. Aufgrund dieses Joins wird der Cursor nicht mehr eindeutig einer einzigen Tabelle (employees) zugeordnet.
Fehlerhafte Nutzung von WHERE CURRENT OF:
Die Klausel WHERE CURRENT OF funktioniert nur, wenn der Cursor explizit für eine einzelne Tabelle definiert ist. Da hier mehrere Tabellen (employees und departments) involviert sind, tritt ein Fehler auf.
3. Drittes Beispiel: Verwendung von ROWID als Alternative zu WHERE CURRENT OF
declare
  cursor c_emps is select e.rowid, e.salary from employees e, departments d
                    where 
                    e.department_id = d.department_id
                    and e.department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where rowid = r_emps.rowid;
  end loop;  
end;
Erklärung:

ROWID-Verwendung:
Die ROWID ist ein eindeutiger Zeilenbezeichner in der Datenbank. Im Cursor werden die ROWID-Werte der Tabelle employees abgerufen. Während der Verarbeitung kann die spezifische Zeile durch den Vergleich mit der ROWID aktualisiert werden.
Alternative zu WHERE CURRENT OF:
Da ROWID eindeutig eine Zeile identifiziert, wird das Problem mit Joins (wie im zweiten Beispiel) vermieden. Die Aktualisierung erfolgt gezielt für die aktuell verarbeitete Zeile.
