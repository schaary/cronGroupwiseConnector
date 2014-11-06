# Mail Account Notifier

Dieser Cronjob soll die Betreiber des Mailservers der MLU regelmässig über neue
Mail-Accounts informieren, die im IDM der MLU erstellt wurden.

Bisher erfolgte die Zustellung per Mail direkt aus der Oracle-Datenbank heraus.
Das Start-Script, dass den Job in der Datenbank aufruft muss umziehen und die
Funktion in der Datenbank technisch nicht mehr auf dem aktuellen Stand. Deshalb
soll beides durch dieses Script ersetzt werden.

Das Grundsätzliche Vorgehen bleibt erhalten. Es werden alle Accounts aus einem
bestimmten Zeitraum aufgesammelt und daraus eine Mail generiert, die durch die
Betreuer des Mail-Dienstes weiter verwendet werden kann.

Beim Anlegen eines Accounts wird ein Vermerk in der Tabelle `ma_add_tbl`
angelegt, der die Account-ID `umt_login_id`, die Dienst-ID für den Mail-Service
und einen Zeitstempel enthält. Damit wird die Menge der Neueinträge für einen
bestimmten Zeitraum berechnet, die entsprechenden Daten werden aus der Tabelle
Accounts gesucht und alles zusammen durch einen Cursor zugänglich gemacht.
