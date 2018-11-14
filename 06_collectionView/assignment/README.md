# Assignment 06

In diesem Assignment sollen CollectionViews geübt werden

- Die `CollectionView` soll über einen Zoom In und Zoom Out verfügen

  - Zwei `UIBarButtonItems`  inkrementieren bzw. dekrementieren die Anzahl der Items pro Zeile und aktualisieren anschließend die CollectionView.
    Tipp: `collectionView.indexPathForVisibleItems` für animiertes zoomen

  - Der Zoom funktioniert **nicht** während des Editierens

  - Beide Zoom Funktionen haben eine Grenze. Mindestens 1 (Zoom In) und höchstens 6 (Zoom Out) Items pro Zeile

- Der `DetailPhotoViewController` soll auch bei einem Tap auf eine Cell angezeigt werden
  Tipp: schaut euch die Methoden von `UICollectionViewDelegate` an

- Die Bilder in der `PhotoCollectionViewCell` soll *einfaden* wenn sie gesetzt werden (Animation)

- Die Bilder sollen mit `NSCache<NSString, UIImage>` gecached werden

  - Informiert euch über die Funktionsweise und Nutzung von NSCache

  - NSCache funktioniert wie ein Dictionary. Der Key muss allerdings ein `NSObject` sein. In diesem Anwendungsfall eignet sich die URL, denn sie ist per Definition einzigartig. Ihr müsste also die URL in ein NSString umwandeln

  - Der Cache muss selbstverständlich im `ImageLoader` implementiert werden. Glücklicherweise ist der ImageLoader bereits ein Singleton und teilt seinen State (Objekte im Cache) mit allen Objekten (Cells), die ihn verwenden

![Assigment 06](assignment06.gif)
