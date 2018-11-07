# Assignment 05

In diesem Assignment sollen Segues geübt werden

- Der `SettingsViewController` soll erweitert werden, um alle Properties der `DrawingCardView` zu konfigurieren

  - Es kann sein dass ein paar Autolayout Fehler auftreten, weil die Constraints der `ContainerView` nicht mehr alle greifen können. Diese könnt ihr für die Aufgabe ignorieren

- Ein `HighScoreViewController` soll die Highscores der einzelnen Runden anzeigen. Die Einträge sind nach dem Score sortiert

  - Es reicht aus, wenn der ViewController ein `UILabel` hat und die Einträge mit Linebreak (`\n`) getrennt werden. Damit ein Label unendlich viele Zeilen haben kann, muss `numberOfLines` auf 0 gesetzt werden
  - Das Model vom `HighScoreViewController` könnt ihr frei wählen
  - Wenn noch nocht gespielt wurde, kann der `BarButtonItem` entweder ausgegraut werden oder man zeigt im Label eine entsprechende Meldung an (`you have to play first`)

- Das Anzeigen des `HighScoreViewController` ist vermutlich als Segue implementiert.  Jetzt sollt ihr den  ViewController direkt präsentieren

  - der `HighScoreViewController` wird über das `storyboard` instantiziert und über `present(viewController:, animated:)` aufgerufen (siehe Folien)
  - Was ist anders und was ändert sich? Müss der `NavigationController` beachtet werden?

  ![Assigment 05](assignment05.gif)
