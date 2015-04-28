# Eintragen eines Mail-Accounts in den LDAP des Novell Groupwise des ITZ

Dieser Cronjob trägt neue Accounts in den LDAP-Server des Novell Groupwise des
[IT-Servicezentrums](http://itz.uni-halle.de) der [Martin-Luther-Universität
Halle-Wittenberg](http://uni-halle.de) ein.

Dabei wird wie folgt vorgegangen:

1. Abrufen aller Accounts, die im IDM seit dem letzten Durchlauf dieses
   Cronjobs angelegt wuden.
2. Umwandlung in ein Objekt vom Typ Account mit Berechnung der Prüfsumme des
   Eintrages.
3. Für alle unter 1. abgerufenen Accounts: Wenn der Account noch nicht im
   Groupwise-LDAP existiert, dann wird der Account in den LDAP des Groupwise
   eingetragen.
4. Es wird ein Vermerk über den erfolgreichen Ablauf des Cronjobs ins IDM
   geschrieben.
